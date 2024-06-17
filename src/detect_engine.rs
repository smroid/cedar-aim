use cedar_camera::abstract_camera::{AbstractCamera, CapturedImage};

use std::sync::{Arc, Mutex};
use std::sync::atomic::{AtomicBool, Ordering};
use std::time::{Duration, Instant};

use canonical_error::CanonicalError;
use image::{GenericImageView, GrayImage};
use imageproc::rect::Rect;
use log::{debug, error};
use cedar_detect::algorithm::{StarDescription, estimate_noise_from_image,
                              get_stars_from_image, summarize_region_of_interest};
use cedar_detect::histogram_funcs::{average_top_values,
                                    get_level_for_fraction,
                                    remove_stars_from_histogram};
use crate::scale_image::scale_image_mut;
use crate::value_stats::ValueStatsAccumulator;
use crate::cedar;

pub struct DetectEngine {
    // Bounds the range of exposure durations to be set by auto-exposure.
    // The set_exposure_time() function is not bound by these limits.
    min_exposure_duration: Duration,
    max_exposure_duration: Duration,

    // Parameters for star detection algorithm.
    detection_min_sigma: f32,
    detection_sigma: f32,
    detection_max_size: i32,

    // In operate mode (`focus_mode_enabled` is false), the auto-exposure
    // algorithm uses this as the desired number of detected stars. The
    // algorithm allows the number of detected stars to vary around the goal by
    // a large amount to the high side (is OK to have more stars than needed)
    // but only a small amount to the low side.
    star_count_goal: i32,

    // Note: camera settings can be adjusted behind our back.
    camera: Arc<tokio::sync::Mutex<Box<dyn AbstractCamera + Send>>>,

    // Our state, shared between DetectEngine methods and the worker thread.
    state: Arc<Mutex<DetectState>>,

    // Executes worker().
    worker_thread: Option<std::thread::JoinHandle<()>>,

    // Signaled at worker_thread exit.
    worker_done: Arc<AtomicBool>,
}

// State shared between worker thread and the DetectEngine methods.
struct DetectState {
    frame_id: Option<i32>,

    // If true, use auto exposure.
    auto_exposure: bool,

    // Zero means go fast as images are captured.
    update_interval: Duration,

    // True means populate `DetectResult.focus_aid` info.
    focus_mode_enabled: bool,

    // Tells if the input image has been 2x2 sampled.
    // See "About Resolutions" in cedar_server.rs.
    sampled: bool,

    // When running CedarDetect, this supplies the `binning` value used. This
    // is passed in set_focus_mode(); the caller takes into account how much
    // binning is needed and whether the input image has already been sampled.
    // See "About Resolutions" in cedar_server.rs.
    binning_for_detect: u32,

    // When using auto exposure in operate mode, this is the exposure duration
    // determined (by calibration) to yield `star_count_goal` detected stars.
    // Auto exposure logic will only deviate from this by a bounded amount.
    // None if calibration result is not yet available.
    calibrated_exposure_duration: Option<Duration>,

    // Value used to alter operating constants. A value >1 means the detection
    // logic and/or auto exposure system should be biased towards more accurate
    // operation; a value < 1 instead favors speed. Range is roughly [0.5 .. 1.5].
    accuracy_multiplier: f32,

    detect_latency_stats: ValueStatsAccumulator,

    // Estimated time at which `detect_result` will next be updated.
    eta: Option<Instant>,

    detect_result: Option<DetectResult>,

    // Set by stop(); the worker thread exits when it sees this.
    stop_request: bool,
}

impl Drop for DetectEngine {
    fn drop(&mut self) {
        // https://stackoverflow.com/questions/71541765/rust-async-drop
        futures::executor::block_on(self.stop());
    }
}

impl DetectEngine {
    pub fn new(min_exposure_duration: Duration,
               max_exposure_duration: Duration,
               detection_min_sigma: f32,
               detection_sigma: f32,
               detection_max_size: i32,
               star_count_goal: i32,
               camera: Arc<tokio::sync::Mutex<Box<dyn AbstractCamera + Send>>>,
               update_interval: Duration, auto_exposure: bool,
               focus_mode_enabled: bool, stats_capacity: usize)
               -> Self {
        DetectEngine{
            min_exposure_duration,
            max_exposure_duration,
            detection_min_sigma,
            detection_sigma,
            detection_max_size,
            star_count_goal,
            camera: camera.clone(),
            state: Arc::new(Mutex::new(DetectState{
                frame_id: None,
                auto_exposure,
                update_interval,
                focus_mode_enabled,
                sampled: false,
                binning_for_detect: 1,
                calibrated_exposure_duration: None,
                accuracy_multiplier: 1.0,
                detect_latency_stats: ValueStatsAccumulator::new(stats_capacity),
                eta: None,
                detect_result: None,
                stop_request: false,
            })),
            worker_thread: None,
            worker_done: Arc::new(AtomicBool::new(false)),
        }
    }

    // If `exp_time` is zero, enables auto exposure. In setup mode, auto
    // exposure is based on a histogram of the central region, and aims to make
    // the brightest part of the central region bright but not saturated. In
    // operate mode, auto exposure is based on the number of detected stars in
    // the entire image.
    pub async fn set_exposure_time(&mut self, exp_time: Duration)
                                   -> Result<(), CanonicalError> {
        if !exp_time.is_zero() {
            let mut locked_camera = self.camera.lock().await;
            locked_camera.set_exposure_duration(exp_time)?
        }
        let mut locked_state = self.state.lock().unwrap();
        locked_state.auto_exposure = exp_time.is_zero();
        // Don't need to do anything, worker thread will pick up the change when
        // it finishes the current interval.
        Ok(())
    }

    // Determines how often the detect engine operates (obtains an image, produces
    // a DetectResult).
    // An interval of zero means run continuously-- as soon as a DetectResult is
    // produced, the next one is started.
    pub fn set_update_interval(&mut self, update_interval: Duration)
                               -> Result<(), CanonicalError> {
        let mut locked_state = self.state.lock().unwrap();
        locked_state.update_interval = update_interval;
        // Don't need to do anything, worker thread will pick up the change when
        // it finishes the current interval.
        Ok(())
    }

    pub fn set_focus_mode(&mut self, enabled: bool, sampled: bool, binning: u32) {
        let mut locked_state = self.state.lock().unwrap();
        locked_state.focus_mode_enabled = enabled;
        locked_state.sampled = sampled;
        locked_state.binning_for_detect = binning;
        // Don't need to do anything, worker thread will pick up the change when
        // it finishes the current interval.
    }

    pub fn get_detection_sigma(&self) -> f32 {
        return self.detection_sigma;
    }
    pub fn get_detection_max_size(&self) -> i32 {
        return self.detection_max_size;
    }
    pub fn get_star_count_goal(&self) -> i32 {
        return self.star_count_goal;
    }

    pub fn set_calibrated_exposure_duration(
        &mut self, calibrated_exposure_duration: Duration) {
        let mut locked_state = self.state.lock().unwrap();
        locked_state.calibrated_exposure_duration = Some(calibrated_exposure_duration);
        // Don't need to do anything, worker thread will pick up the change when
        // it finishes the current interval.
    }

    pub fn set_accuracy_multiplier(&mut self, accuracy_multiplier: f32) {
        let mut locked_state = self.state.lock().unwrap();
        locked_state.accuracy_multiplier = accuracy_multiplier;
        // Don't need to do anything, worker thread will pick up the change when
        // it finishes the current interval.
    }

    /// Obtains a result bundle, as configured above. The returned result is
    /// "fresh" in that we either wait to process a new exposure or return the
    /// result of processing the most recently completed exposure.
    /// This function does not "consume" the information that it returns;
    /// multiple callers will receive the current result bundle (or next result,
    /// if there is not yet a current result) if `prev_frame_id` is omitted. If
    /// `prev_frame_id` is supplied, the call blocks while the current result
    /// has the same id value.
    /// Returns: the processed result along with its frame_id value.
    pub async fn get_next_result(&mut self, prev_frame_id: Option<i32>) -> DetectResult {
        // Has the worker terminated for some reason?
        if self.worker_done.load(Ordering::Relaxed) {
            self.worker_done.store(false, Ordering::Relaxed);
            self.worker_thread = None;
        }
        // Start worker thread if terminated or not yet started.
        if self.worker_thread.is_none() {
            let min_exposure_duration = self.min_exposure_duration;
            let max_exposure_duration = self.max_exposure_duration;
            let detection_min_sigma = self.detection_min_sigma;
            let detection_sigma = self.detection_sigma;
            let detection_max_size = self.detection_max_size;
            let star_count_goal = self.star_count_goal;
            let cloned_state = self.state.clone();
            let cloned_camera = self.camera.clone();
            let cloned_done = self.worker_done.clone();

            // The DetectEngine::worker() function is async because it uses the
            // camera interface, which is async. Note however that worker()
            // logic calls the non-async get_stars_from_image() function, which
            // takes ~10ms in release builds and ~200ms in debug builds. Such
            // compute durations are well beyond the guidelines for running
            // async code without an .await yield point.
            //
            // We thus run DetectEngine::worker() on its own async runtime. See
            // https://thenewstack.io/using-rustlangs-async-tokio-runtime-for-cpu-bound-tasks/
            self.worker_thread = Some(std::thread::spawn(move || {
                let runtime = tokio::runtime::Builder::new_multi_thread()
                    .enable_all()
                    .thread_name("detect_engine")
                    .build().unwrap();
                runtime.block_on(async move {
                    DetectEngine::worker(
                        min_exposure_duration, max_exposure_duration,
                        detection_min_sigma, detection_sigma, detection_max_size,
                        star_count_goal, cloned_state, cloned_camera, cloned_done).await;
                });
            }));
        }
        // Get the most recently posted result; wait if there is none yet or the
        // currently posted result is the same as the one the caller has already
        // obtained.
        loop {
            let mut sleep_duration = Duration::from_millis(1);
            {
                let locked_state = self.state.lock().unwrap();
                if locked_state.detect_result.is_some() &&
                    (prev_frame_id.is_none() ||
                     prev_frame_id.unwrap() !=
                     locked_state.detect_result.as_ref().unwrap().frame_id)
                {
                    // Don't consume it, other clients may want it.
                    return locked_state.detect_result.clone().unwrap();
                }
                if locked_state.eta.is_some() {
                    let time_to_eta =
                        locked_state.eta.unwrap().saturating_duration_since(Instant::now());
                    if time_to_eta > sleep_duration {
                        sleep_duration = time_to_eta;
                    }
                }
            }
            tokio::time::sleep(sleep_duration).await;
        }
    }

    pub fn reset_session_stats(&mut self) {
        let mut state = self.state.lock().unwrap();
        state.detect_latency_stats.reset_session();
    }

    pub fn estimate_delay(&self, prev_frame_id: Option<i32>) -> Option<Duration> {
        let locked_state = self.state.lock().unwrap();
        if locked_state.detect_result.is_some() &&
            (prev_frame_id.is_none() ||
             prev_frame_id.unwrap() !=
             locked_state.detect_result.as_ref().unwrap().frame_id)
        {
            Some(Duration::ZERO)
        } else if locked_state.eta.is_some() {
            Some(locked_state.eta.unwrap().saturating_duration_since(Instant::now()))
        } else {
            None
        }
    }

    /// Shuts down the worker thread; this can save power if get_next_result()
    /// will not be called soon. A subsequent call to get_next_result() will
    /// re-start processing, at the expense of that first get_next_result() call
    /// taking longer than usual.
    pub async fn stop(&mut self) {
        if self.worker_thread.is_some() {
            self.state.lock().unwrap().stop_request = true;
            loop {
                if self.worker_done.load(Ordering::Relaxed) {
                    self.worker_done.store(false, Ordering::Relaxed);
                    self.worker_thread = None;
                    break;
                }
                tokio::time::sleep(Duration::from_millis(10)).await;
            }
        }
    }

    async fn worker(min_exposure_duration: Duration,
                    max_exposure_duration: Duration,
                    detection_min_sigma: f32,
                    detection_sigma: f32,
                    detection_max_size: i32,
                    star_count_goal: i32,
                    state: Arc<Mutex<DetectState>>,
                    camera: Arc<tokio::sync::Mutex<Box<dyn AbstractCamera + Send>>>,
                    done: Arc<AtomicBool>) {
        debug!("Starting detect engine");
        // Keep track of when we started the detect cycle.
        let mut last_result_time: Option<Instant> = None;
        loop {
            let auto_exposure: bool;
            let update_interval: Duration;
            let focus_mode_enabled: bool;
            let binning_for_detect: u32;
            let calibrated_exposure_duration: Option<Duration>;
            let accuracy_multiplier: f32;
            let coord_scale: f32;
            {
                let mut locked_state = state.lock().unwrap();
                if locked_state.stop_request {
                    debug!("Stopping detect engine");
                    locked_state.stop_request = false;
                    done.store(true, Ordering::Relaxed);
                    return;  // Exit thread.
                }
                auto_exposure = locked_state.auto_exposure;
                update_interval = locked_state.update_interval;
                focus_mode_enabled = locked_state.focus_mode_enabled;
                binning_for_detect = locked_state.binning_for_detect;
                calibrated_exposure_duration =
                    locked_state.calibrated_exposure_duration;
                accuracy_multiplier = locked_state.accuracy_multiplier;
                coord_scale = if locked_state.sampled { 2.0 } else { 1.0 };
            }
            // Is it time to generate the next DetectResult?
            let now = Instant::now();
            if last_result_time.is_some() {
                let next_update_time = last_result_time.unwrap() + update_interval;
                if next_update_time > now {
                    let delay = next_update_time - now;
                    state.lock().unwrap().eta = Some(Instant::now() + delay);
                    tokio::time::sleep(delay).await;
                    continue;
                }
                state.lock().unwrap().eta = None;
            }

            // Time to do a detect processing cycle.
            last_result_time = Some(now);

            let frame_id = state.lock().unwrap().frame_id;
            let captured_image;
            {
                let mut locked_camera = camera.lock().await;
                let delay_est = locked_camera.estimate_delay(frame_id);
                if delay_est.is_some() {
                    state.lock().unwrap().eta =
                        Some(Instant::now() + delay_est.unwrap());
                }
                match locked_camera.capture_image(frame_id).await {
                    Ok((img, id)) => {
                        captured_image = img;
                        state.lock().unwrap().frame_id = Some(id);
                    }
                    Err(e) => {
                        error!("Error capturing image: {}", &e.to_string());
                        break;  // Abandon thread execution!
                    }
                }
            }

            // Process the just-acquired image.
            let process_start_time = Instant::now();
            let image: &GrayImage = &captured_image.image;
            // Note: `image` is not necessarily at full resolution; it might
            // have been 2x2 sampled.
            let (width, height) = image.dimensions();
            let center_size = std::cmp::min(width, height) / 3;
            let center_region = Rect::at(((width - center_size) / 2) as i32,
                                         ((height - center_size) / 2) as i32)
                .of_size(center_size, center_size);
            let noise_estimate = estimate_noise_from_image(&image);
            let prev_exposure_duration_secs =
                captured_image.capture_params.exposure_duration.as_secs_f32();
            let mut new_exposure_duration_secs = prev_exposure_duration_secs;

            let mut focus_aid: Option<FocusAid> = None;
            if focus_mode_enabled {
                let roi_summary = summarize_region_of_interest(
                    &image, &center_region, noise_estimate, detection_sigma);
                let mut roi_histogram = roi_summary.histogram;

                // Compute peak_value as the average of the 5 brightest pixels.
                let peak_value = average_top_values(&roi_histogram, 5);

                if auto_exposure {
                    // Adjust exposure time based on peak value of center_region.

                    // For auto_exposure in focus mode, what is the target value
                    // of the brightest pixel in the center region? Note that a
                    // lower brightness_goal value allows for faster exposures,
                    // which is nice in focus mode.
                    let brightness_goal = 128.0 * accuracy_multiplier;

                    // Compute how much to scale the previous exposure
                    // integration time to move towards the goal. Assumes linear
                    // detector response.

                    // Move proportionally towards the goal.
                    let correction_factor = brightness_goal / peak_value as f32;
                    // Don't adjust exposure time too often, is a bit janky
                    // because the camera re-initializes.
                    if correction_factor < 0.7 || correction_factor > 1.3 {
                        new_exposure_duration_secs =
                            prev_exposure_duration_secs * correction_factor;
                    }
                }  // auto_exposure

                let image_rect = Rect::at(0, 0).of_size(width, height);
                // Get a small sub-image centered on the peak coordinates.
                let peak_position = (roi_summary.peak_x, roi_summary.peak_y);
                let sub_image_size = 30;
                let peak_region =
                    Rect::at((peak_position.0 as i32 - sub_image_size/2) as i32,
                             (peak_position.1 as i32 - sub_image_size/2) as i32)
                    .of_size(sub_image_size as u32, sub_image_size as u32);
                let peak_region = peak_region.intersect(image_rect).unwrap();
                debug!("peak {} at x/y {}/{}",
                       peak_value, peak_region.left(), peak_region.top());
                // Get a good black level for display.
                remove_stars_from_histogram(&mut roi_histogram, /*sigma=*/8.0);
                let black_level = get_level_for_fraction(&roi_histogram, 0.9);

                // We scale up the pixel values in the peak_image for good
                // display visibility.
                let mut peak_image = image.view(peak_region.left() as u32,
                                                peak_region.top() as u32,
                                                sub_image_size as u32,
                                                sub_image_size as u32).to_image();
                scale_image_mut(&mut peak_image, black_level as u8, peak_value, /*gamma=*/0.7);
                focus_aid = Some(FocusAid{
                    center_peak_position: Self::scale_coord(peak_position, coord_scale),
                    center_peak_value: peak_value,
                    peak_image,
                    peak_image_region: Self::scale_rect(peak_region, coord_scale as u32),
                });
            }  // focus_mode_enabled

            // Run CedarDetect on the image.
            {
                let mut locked_state = state.lock().unwrap();
                if let Some(recent_stats) =
                    &locked_state.detect_latency_stats.value_stats.recent
                {
                    let detect_duration = Duration::from_secs_f64(recent_stats.min);
                    locked_state.eta = Some(Instant::now() + detect_duration);
                }
            }
            let adjusted_sigma = f32::max(detection_sigma * accuracy_multiplier,
                                          detection_min_sigma);
            let (mut stars, hot_pixel_count, detect_binned_image, mut histogram) =
                get_stars_from_image(
                    &image, noise_estimate,
                    adjusted_sigma, detection_max_size as u32,
                    /*binning=*/binning_for_detect,
                    /*detect_hot_pixels=*/true,
                    /*return_binned_image=*/binning_for_detect != 1);
            let binned_image = if let Some(bi) = detect_binned_image {
                Some(Arc::new(bi))
            } else {
                None
            };

            // Average the peak pixels of the N brightest stars. Also adjust the
            // coordinates of `stars` to full resolution.
            let mut sum_peak: i32 = 0;
            let mut num_peak = 0;
            const NUM_PEAKS: i32 = 10;
            for star in stars.iter_mut() {
                star.centroid_x *= coord_scale;
                star.centroid_y *= coord_scale;
                sum_peak += star.peak_value as i32;
                num_peak += 1;
                if num_peak >= NUM_PEAKS {
                    break;
                }
            }
            let peak_star_pixel =
                if num_peak == 0 {
                    255
                } else {
                    sum_peak / num_peak
                };
            assert!(peak_star_pixel <= 255);

            // Get a good black level for display.
            remove_stars_from_histogram(&mut histogram, /*sigma=*/8.0);
            let black_level = get_level_for_fraction(&histogram, 0.99);

            let elapsed = process_start_time.elapsed();
            state.lock().unwrap().detect_latency_stats.add_value(elapsed.as_secs_f64());

            if !focus_mode_enabled && auto_exposure &&
                calibrated_exposure_duration.is_some()
            {
                let adjusted_star_count_goal =
                    star_count_goal as f32 * accuracy_multiplier;
                let adjusted_exposure_duration_secs =
                    calibrated_exposure_duration.unwrap().as_secs_f32() * accuracy_multiplier;

                let num_stars_detected = stars.len();
                if num_stars_detected == 0 {
                    // Revert to safety: use adjusted calibrated exposure duration.
                    new_exposure_duration_secs = adjusted_exposure_duration_secs;
                } else {
                    // >1 if we have more stars than goal; <1 if fewer stars than
                    // goal.
                    let star_goal_fraction =
                        num_stars_detected as f32 / adjusted_star_count_goal;
                    // Don't adjust exposure time too often, is a bit janky because the
                    // camera re-initializes. Allow number of detected stars to greatly
                    // exceed goal, but don't allow much of a shortfall.
                    if star_goal_fraction < 0.8 || star_goal_fraction > 2.0 {
                        // What is the relationship between exposure time and number
                        // of stars detected?
                        // * If we increase the exposure time by 2.5x, we'll be able
                        //   to detect stars 40% as bright. This corresponds to an
                        //   increase of one stellar magnitude.
                        // * Per https://www.hnsky.org/star_count, at mag=5 a one
                        //   magnitude increase corresponds to around 3x the number
                        //   of stars.
                        // * 2.5x and 3x are "close enough", so we model the number
                        //   of detectable stars as being simply proportional to the
                        //   exposure time. This is OK because we'll only be varying
                        //   the exposure time a modest amount relative to the
                        //   adjusted_exposure_duration.
                        new_exposure_duration_secs =
                            prev_exposure_duration_secs / star_goal_fraction;
                        // Bound exposure duration to be within two stops of
                        // adjusted_exposure_duration.
                        new_exposure_duration_secs = f32::max(
                            new_exposure_duration_secs,
                            adjusted_exposure_duration_secs / 4.0);
                        new_exposure_duration_secs = f32::min(
                            new_exposure_duration_secs,
                            adjusted_exposure_duration_secs * 4.0);
                    }
                }
            }

            // Update camera exposure time if auto-exposure calls for an
            // adjustment.
            if auto_exposure {
                // Bound auto-exposure duration to given limits.
                new_exposure_duration_secs = f32::max(new_exposure_duration_secs,
                                                      min_exposure_duration.as_secs_f32());
                new_exposure_duration_secs = f32::min(new_exposure_duration_secs,
                                                      max_exposure_duration.as_secs_f32());
                if prev_exposure_duration_secs != new_exposure_duration_secs {
                    debug!("Setting new exposure duration {}s",
                           new_exposure_duration_secs);
                    let mut locked_camera = camera.lock().await;
                    match locked_camera.set_exposure_duration(
                        Duration::from_secs_f32(new_exposure_duration_secs)) {
                        Ok(()) => (),
                        Err(e) => {
                            error!("Error updating exposure duration: {}",
                                   &e.to_string());
                            done.store(true, Ordering::Relaxed);
                            return;  // Abandon thread execution!
                        }
                    }
                }
            }

            // Post the result.
            let mut locked_state = state.lock().unwrap();
            locked_state.detect_result = Some(DetectResult{
                frame_id: locked_state.frame_id.unwrap(),
                captured_image: captured_image,
                binned_image,
                star_candidates: stars,
                display_black_level: black_level as u8,
                noise_estimate,
                hot_pixel_count: hot_pixel_count as i32,
                peak_star_pixel: peak_star_pixel as u8,
                focus_aid,
                center_region: Self::scale_rect(center_region, coord_scale as u32),
                processing_duration: elapsed,
                detect_latency_stats:
                locked_state.detect_latency_stats.value_stats.clone(),
            });
        }  // loop.
    }

    fn scale_coord(coord: (f32, f32), scale: f32) -> (f32, f32) {
        (coord.0 * scale, coord.1 * scale)
    }

    fn scale_rect(rect: Rect, scale: u32) -> Rect {
        Rect::at(rect.left() * scale as i32, rect.top() * scale as i32)
            .of_size(rect.width() * scale, rect.height() * scale)
    }
}

#[derive(Clone)]
pub struct DetectResult {
    // See the corresponding field in cedar.FrameResult proto message.
    pub frame_id: i32,

    // The camera image used to produce the information in this detect result.
    // Note that in focus mode this might be a 2x2 sampling of the camera's full
    // resolution.
    pub captured_image: CapturedImage,

    // If binning was applied prior to detect, this is the 2x2 or 4x4 binned
    // (and hot pixel removed) image.
    pub binned_image: Option<Arc<GrayImage>>,

    // The star candidates detected by CedarDetect; ordered by highest
    // StarDescription.mean_brightness first.
    pub star_candidates: Vec<StarDescription>,

    // When displaying the captured (or binned) image, map this pixel value to
    // black. This is chosen to allow stars to be visible but supress the
    // background level.
    pub display_black_level: u8,

    // Estimate of the RMS noise of the full-resolution image.
    pub noise_estimate: f32,

    // The number of hot pixels detected by CedarDetect.
    pub hot_pixel_count: i32,

    // The peak pixel value of star_candidates. If star_candidates is empty,
    // this value is fixed to 255.
    pub peak_star_pixel: u8,

    // Included if `focus_mode_enabled`.
    pub focus_aid: Option<FocusAid>,

    // See the corresponding field in FrameResult. Note that this is populated
    // even when not in `focus_mode_enabled`.
    // This is in full resolution coordinates.
    pub center_region: Rect,

    // Time taken to produce this DetectResult, excluding the time taken to
    // acquire the image.
    pub processing_duration: std::time::Duration,

    // Distribution of `processing_duration` values.
    pub detect_latency_stats: cedar::ValueStats,
}

#[derive(Clone)]
pub struct FocusAid {
    // See the corresponding field in FrameResult.
    pub center_peak_position: (f32, f32),

    // See the corresponding field in FrameResult.
    pub center_peak_value: u8,

    // A small crop of `captured_image` centered at `center_peak_position`.
    // Brightness scaled to full range for visibility.
    pub peak_image: GrayImage,

    // The location of `peak_image`.
    pub peak_image_region: Rect,
}
