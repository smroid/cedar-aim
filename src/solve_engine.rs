use crate::detect_engine::{DetectEngine, DetectResult};

use std::ops::DerefMut;
use std::sync::{Arc, Condvar, Mutex};
use std::thread;
use std::time::{Duration, Instant};

use canonical_error::{CanonicalError, invalid_argument_error};
use image::GrayImage;
//use log::{debug, error, info};
use log::{info};
use tonic::transport::{Endpoint, Uri};
use tokio::net::UnixStream;
use tower::service_fn;

pub mod tetra3 {
    tonic::include_proto!("tetra3_server");
}

use tetra3::{ImageCoord, SolveRequest};
use tetra3::tetra3_client::Tetra3Client;

pub struct SolveEngine {
    // Our state, shared between SolveEngine methods and the worker thread.
    state: Arc<Mutex<SolveState>>,

    // Condition variable signalled whenever `state.solve_result` is populated.
    // Also signalled when the worker thread exits.
    solve_result_available: Arc<Condvar>,

    // The Tetra3 server we invoke for plate solving.
    tetra3_server_address: String,
}

// State shared between worker thread and the SolveEngine methods.
struct SolveState {
    // Detect engine settings can be adjusted behind our back.
    detect_engine: Arc<Mutex<DetectEngine>>,
    frame_id: Option<i32>,

    // Zero means go fast as star detections are computed.
    update_interval: Duration,

    // Parameters for plate solver. See documentation of Tetra3's
    // solve_from_centroids() function for a description of these items.
    fov_estimate: Option<f32>,
    fov_max_error: Option<f32>,
    pattern_checking_stars: i32,
    match_radius: f32,
    match_threshold: f32,
    solve_timeout: Duration,
    target_pixel: Option<ImageCoord>,
    distortion: f32,
    return_matches: bool,
    match_max_error: f32,

    solve_result: Option<SolveResult>,

    // Set by stop(); the worker thread exits when it sees this.
    stop_request: bool,

    worker_thread: Option<thread::JoinHandle<()>>,
}

impl Drop for SolveEngine {
    fn drop(&mut self) {
        self.stop();
    }
}

impl SolveEngine {
    pub fn new(detect_engine: Arc<Mutex<DetectEngine>>,
               tetra3_server_address: String,
               update_interval: Duration) -> SolveEngine {
        SolveEngine{
            state: Arc::new(Mutex::new(SolveState{
                detect_engine: detect_engine.clone(),
                frame_id: None,
                update_interval,
                fov_estimate: None,
                fov_max_error: None,
                pattern_checking_stars: 8,
                match_radius: 0.01,
                match_threshold: 0.001,
                solve_timeout: Duration::from_secs(1),
                target_pixel: None,
                distortion: 0.0,
                return_matches: true,
                match_max_error: 0.005,
                solve_result: None,
                stop_request: false,
                worker_thread: None,
            })),
            solve_result_available: Arc::new(Condvar::new()),
            tetra3_server_address,
        }
    }

    pub fn set_update_interval(&mut self, update_interval: Duration)
                               -> Result<(), CanonicalError> {
        let mut locked_state = self.state.lock().unwrap();
        locked_state.update_interval = update_interval;
        // Don't need to do anything, worker thread will pick up the change when
        // it finishes the current interval.
        Ok(())
    }

    pub fn set_fov_estimate(&mut self, fov_estimate: Option<f32>,
                            fov_max_error: Option<f32>)
                               -> Result<(), CanonicalError> {
        let mut locked_state = self.state.lock().unwrap();
        if fov_estimate.is_some() && fov_estimate.unwrap() <= 0.0 {
            return Err(invalid_argument_error(
                format!("fov_estimate must be positive; got {}",
                        fov_estimate.unwrap()).as_str()));
        }
        if fov_max_error.is_some() && fov_max_error.unwrap() <= 0.0 {
            return Err(invalid_argument_error(
                format!("fov_max_error must be positive; got {}",
                        fov_max_error.unwrap()).as_str()));
        }
        if fov_estimate.is_none() && fov_max_error.is_some() {
            return Err(invalid_argument_error(
                "Cannot provide fov_max_error without fov_estimate"));
        }
        locked_state.fov_estimate = fov_estimate;
        locked_state.fov_max_error = fov_max_error;
        // Don't need to do anything, worker thread will pick up the change when
        // it finishes the current interval.
        Ok(())
    }

    pub fn set_target_pixel(&mut self, target_pixel: Option<ImageCoord>)
                               -> Result<(), CanonicalError> {
        let mut locked_state = self.state.lock().unwrap();
        locked_state.target_pixel = target_pixel;
        // Don't need to do anything, worker thread will pick up the change when
        // it finishes the current interval.
        Ok(())
    }

    pub fn set_distortion(&mut self, distortion: f32)
                               -> Result<(), CanonicalError> {
        let mut locked_state = self.state.lock().unwrap();
        if distortion < -0.2 || distortion > 0.2 {
            return Err(invalid_argument_error(
                format!("distortion must be in [-0.2, 0.2]; got {}",
                        distortion).as_str()));
        }
        locked_state.distortion = distortion;
        // Don't need to do anything, worker thread will pick up the change when
        // it finishes the current interval.
        Ok(())
    }

    pub fn set_match_max_error(&mut self, match_max_error: f32)
                               -> Result<(), CanonicalError> {
        let mut locked_state = self.state.lock().unwrap();
        if match_max_error < 0.0 || match_max_error >= 0.1 {
            return Err(invalid_argument_error(
                format!("match_max_error must be in [0, 0.1); got {}",
                        match_max_error).as_str()));
        }
        locked_state.match_max_error = match_max_error;
        // Don't need to do anything, worker thread will pick up the change when
        // it finishes the current interval.
        Ok(())
    }

    // Note: we don't currently provide methods to change pattern_checking_stars,
    // match_radius, match_threshold, solve_timeout, or return_matches. The
    // defaults for these should be fine.

    /// Obtains a result bundle, as configured above. The returned result is
    /// "fresh" in that we either wait to solve a new detect result or return
    /// the result of solving the most recently completed star detection.
    /// This function does not "consume" the information that it returns;
    /// multiple callers will receive the current solve result (or next solve
    /// result, if there is not yet a current result) if `prev_frame_id` is
    /// omitted.
    /// If `prev_frame_id` is supplied, the call blocks while the current result
    /// has the same id value.
    /// Returns: the processed result along with its frame_id value.
    pub fn get_next_result(&mut self, prev_frame_id: Option<i32>) -> SolveResult {
        let mut state = self.state.lock().unwrap();
        // Start worker thread if not yet started.
        if state.worker_thread.is_none() {
            let cloned_addr = self.tetra3_server_address.clone();
            let cloned_state = self.state.clone();
            let cloned_condvar = self.solve_result_available.clone();
            state.worker_thread = Some(thread::spawn(|| {
                let rt = tokio::runtime::Runtime::new().unwrap();
                rt.block_on(SolveEngine::worker(cloned_addr, cloned_state, cloned_condvar));
            }));
        }
        // Get the most recently posted result.
        loop {
            if state.solve_result.is_none() {
                state = self.solve_result_available.wait(state).unwrap();
                continue;
            }
            // Wait if the posted result is the same as the one the caller has
            // already obtained.
            if prev_frame_id.is_some() &&
                state.solve_result.as_ref().unwrap().frame_id == prev_frame_id.unwrap()
            {
                state = self.solve_result_available.wait(state).unwrap();
                continue;
            }
            break;
        }
        // Don't consume it, other clients may want it.
        state.solve_result.clone().unwrap()
    }

    /// Shuts down the worker thread; this can save power if get_next_result()
    /// will not be called soon. A subsequent call to get_next_result() will
    /// re-start processing, at the expense of that first get_next_result() call
    /// taking longer than usual.
    pub fn stop(&mut self) {
        let mut state = self.state.lock().unwrap();
        if state.worker_thread.is_none() {
            return;
        }
        state.stop_request = true;
        while state.worker_thread.is_some() {
            state = self.solve_result_available.wait(state).unwrap();
        }
    }

    async fn worker(tetra3_server_address: String,
                    state: Arc<Mutex<SolveState>>,
                    solve_result_available: Arc<Condvar>) {
        // Set up gRPC client, connect to a UDS socket. URL is ignored.
        let channel = Endpoint::try_from("http://[::]:50051").unwrap()
            .connect_with_connector(service_fn(move |_: Uri| {
                UnixStream::connect(tetra3_server_address.clone())
            })).await.unwrap();
        let mut client = Tetra3Client::new(channel);

        // Keep track of when we started the solve cycle.
        let mut last_result_time: Option<Instant> = None;
        loop {
            let update_interval: Duration;
            {
                let mut locked_state = state.lock().unwrap();
                update_interval = locked_state.update_interval;
                if locked_state.stop_request {
                    info!("Stopping solve engine");
                    locked_state.stop_request = false;
                    break;
                }
                // TODO: another stopping condition can be: if no
                // get_next_result() calls are seen for more than N seconds,
                // stop. The next get_next_result() call will restart the worker
                // thread.
            }
            // Is it time to generate the next SolveResult?
            let now = Instant::now();
            if last_result_time.is_some() {
                let next_update_time = last_result_time.unwrap() + update_interval;
                if next_update_time > now {
                    thread::sleep(next_update_time - now);
                    continue;
                }
            }

            // Time to do a solve processing cycle.
            last_result_time = Some(now);

            let detect_result: DetectResult;
            let mut solve_request = SolveRequest::default();
            {
                let mut locked_state = state.lock().unwrap();

                // Set up SolveRequest.
                solve_request.fov_estimate = locked_state.fov_estimate;
                solve_request.fov_max_error = locked_state.fov_max_error;
                solve_request.pattern_checking_stars = Some(locked_state.pattern_checking_stars);
                solve_request.match_radius = Some(locked_state.match_radius);
                solve_request.match_threshold = Some(locked_state.match_threshold);
                if locked_state.target_pixel.is_some() {
                    solve_request.target_pixels.push(
                        locked_state.target_pixel.as_ref().unwrap().clone());
                }
                solve_request.distortion = Some(locked_state.distortion);
                solve_request.return_matches = locked_state.return_matches;
                solve_request.match_max_error = Some(locked_state.match_max_error);

                // Get the most recent star detection result.
                let locked_state_mut = locked_state.deref_mut();
                let mut locked_detect_engine = locked_state_mut.detect_engine.lock().unwrap();
                detect_result = locked_detect_engine.get_next_result(
                    locked_state_mut.frame_id);
                // TODO(smr): do this later, when publishing solve result.
                // locked_state_mut.frame_id = Some(detect_result.frame_id);
            }
            let image: &GrayImage = &detect_result.captured_image.image;
            let (width, height) = image.dimensions();

            // Plate-solve using the just-acquired detected stars.
            for sc in detect_result.star_candidates {
                solve_request.star_centroids.push(ImageCoord{x: sc.centroid_x,
                                                             y: sc.centroid_y});
            }
            solve_request.image_width = width as i32;
            solve_request.image_height = height as i32;

            let solve_response = client.solve_from_centroids(solve_request).await;
            // println!("response={:?}", response);


    //         let center_size = std::cmp::min(width, height) / 3;
    //         let center_region = Rect::at(((width - center_size) / 2) as i32,
    //                                      ((height - center_size) / 2) as i32)
    //             .of_size(center_size, center_size);
    //         let noise_estimate = estimate_noise_from_image(&image);

    //         let mut focus_aid: Option<FocusAid> = None;
    //         if focus_mode_enabled || exp_time.is_zero() {
    //             let roi_summary = summarize_region_of_interest(
    //                 &image, &center_region, noise_estimate, sigma);
    //             let mut peak_value = 1_u8;  // Avoid div0 below.
    //             let histogram = &roi_summary.histogram;
    //             for bin in 2..256 {
    //                 if histogram[bin] > 0 {
    //                     peak_value = bin as u8;
    //                 }
    //             }
    //             if exp_time.is_zero() {
    //                 // Adjust exposure time based on histogram of center_region.
    //                 let peak_value_goal = 200;
    //                 // Compute how much to scale the previous exposure
    //                 // integration time to move towards the goal.
    //                 let correction_factor =
    //                     if peak_value == 255 {
    //                         // We don't know how overexposed we are. Cut the
    //                         // exposure time in half.
    //                         0.5
    //                     } else {
    //                         // Move proportionally towards the goal.
    //                         peak_value_goal as f32 / peak_value as f32
    //                     };
    //                 if correction_factor < 0.8 || correction_factor > 1.2 {
    //                     let prev_exposure_duration_secs =
    //                         captured_image.capture_params.exposure_duration.as_secs_f32();
    //                     let mut new_exposure_duration_secs =
    //                         prev_exposure_duration_secs * correction_factor;
    //                     // Bound exposure duration to 0.01ms..1s.
    //                     new_exposure_duration_secs = f32::max(
    //                         new_exposure_duration_secs, 0.00001);
    //                     new_exposure_duration_secs = f32::min(
    //                         new_exposure_duration_secs, 1.0);
    //                     if prev_exposure_duration_secs != new_exposure_duration_secs {
    //                         debug!("Setting new exposure duration {}s",
    //                                new_exposure_duration_secs);
    //                         let locked_state = state.lock().unwrap();
    //                         let mut locked_camera = locked_state.camera.lock().unwrap();
    //                         match locked_camera.set_exposure_duration(
    //                             Duration::from_secs_f32(new_exposure_duration_secs)) {
    //                             Ok(()) => (),
    //                             Err(e) => {
    //                                 error!("Error updating exposure duration: {}",
    //                                        &e.to_string());
    //                                 break;  // Abandon thread execution!
    //                             }
    //                         }
    //                     }
    //                 }
    //             }
    //             if focus_mode_enabled {
    //                 // Get a small sub-image centered on the peak coordinates.
    //                 let peak_position = (roi_summary.peak_x, roi_summary.peak_y);
    //                 let sub_image_size = 30;
    //                 let peak_region = Rect::at((peak_position.0 - sub_image_size/2) as i32,
    //                                            (peak_position.1 - sub_image_size/2) as i32)
    //                     .of_size(sub_image_size as u32, sub_image_size as u32);
    //                 debug!("peak {} at x/y {}/{}",
    //                        peak_value, peak_region.left(), peak_region.top());
    //                 // We scale up the pixel values in the peak_image for good
    //                 // display visibility.
    //                 let mut peak_image = image.view(peak_region.left() as u32,
    //                                                 peak_region.top() as u32,
    //                                                 sub_image_size as u32,
    //                                                 sub_image_size as u32).to_image();
    //                 contrast::stretch_contrast_mut(&mut peak_image, 0, 255);
    //                 // contrast::stretch_contrast_mut(&mut peak_image, 0, peak_value);
    //                 focus_aid = Some(FocusAid{
    //                     center_region,
    //                     center_peak_position: peak_position,
    //                     peak_image,
    //                     peak_image_region: peak_region,
    //                 });
    //             }
    //         }

    //         // Get 2x2 binned image with hot pixels removed.
    //         let (binned_image, hot_pixel_count) =
    //             bin_image(&image, noise_estimate, sigma);
    //         // Run StarGate on the binned image.
    //         let binned_noise_estimate = estimate_noise_from_image(&binned_image);
    //         let (mut stars, _, _) =
    //             get_stars_from_image(&binned_image, Some(&image),
    //                                  binned_noise_estimate,
    //                                  sigma, max_size as u32,
    //                                  /*detect_hot_pixels=*/false,
    //                                  /*create_binned_image=*/false);
    //         // Sort by brightness estimate, brightest first.
    //         stars.sort_by(|a, b| b.mean_brightness.partial_cmp(&a.mean_brightness).unwrap());

    //         // Post the result.
    //         let mut locked_state = state.lock().unwrap();
    //         locked_state.detect_result = Some(DetectResult{
    //             frame_id: locked_state.frame_id.unwrap(),
    //             captured_image: captured_image.clone(),
    //             binned_image: Arc::new(binned_image),
    //             star_candidates: stars,
    //             hot_pixel_count: hot_pixel_count as i32,
    //             focus_aid,
    //             processing_duration: last_result_time.unwrap().elapsed(),
    //         });
            solve_result_available.notify_all();
        }  // loop.
        let mut locked_state = state.lock().unwrap();
        locked_state.worker_thread = None;
        solve_result_available.notify_all();
    }
}

#[derive(Clone)]
pub struct SolveResult {
    // See the corresponding field in cedar.FrameResult proto message.
    pub frame_id: i32,

    // The detect result used to produce the information in this solve result.
    pub detect_result: Arc<DetectResult>,

    // TBD: solve result info
}
