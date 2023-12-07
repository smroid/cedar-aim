// Adapted from
// https://github.com/tokio-rs/axum/tree/main/examples/rest-grpc-multiplex
// https://github.com/tokio-rs/axum/blob/main/examples/static-file-server

use std::io::Cursor;
use std::net::SocketAddr;
use std::sync::{Arc, Mutex};
use std::time::Duration;
use std::time::Instant;

use camera_service::abstract_camera::{AbstractCamera, Gain, Offset};
use camera_service::asi_camera;
use canonical_error::{CanonicalError, CanonicalErrorCode};
use image::ImageOutputFormat;

use axum::Router;
use env_logger;
use log::{debug};
use tower_http::{services::ServeDir, cors::CorsLayer, cors::Any};
use tonic_web::GrpcWebLayer;

use crate::cedar::cedar_server::{Cedar, CedarServer};
use crate::cedar::{CalibrationPhase, FrameRequest, FrameResult, Image, ImageMode,
                   ImageCoord, OperatingMode, OperationSettings, Rectangle,
                   StarCentroid};
use ::cedar::detect_engine::DetectEngine;
use ::cedar::solve_engine::SolveEngine;

use self::multiplex_service::MultiplexService;

fn tonic_status(canonical_error: CanonicalError) -> tonic::Status {
    tonic::Status::new(
        match canonical_error.code {
            CanonicalErrorCode::Unknown => tonic::Code::Unknown,
            CanonicalErrorCode::InvalidArgument => tonic::Code::InvalidArgument,
            CanonicalErrorCode::DeadlineExceeded => tonic::Code::DeadlineExceeded,
            CanonicalErrorCode::NotFound => tonic::Code::NotFound,
            CanonicalErrorCode::AlreadyExists => tonic::Code::AlreadyExists,
            CanonicalErrorCode::PermissionDenied => tonic::Code::PermissionDenied,
            CanonicalErrorCode::Unauthenticated => tonic::Code::Unauthenticated,
            CanonicalErrorCode::ResourceExhausted => tonic::Code::ResourceExhausted,
            CanonicalErrorCode::FailedPrecondition => tonic::Code::FailedPrecondition,
            CanonicalErrorCode::Aborted => tonic::Code::Aborted,
            CanonicalErrorCode::OutOfRange => tonic::Code::OutOfRange,
            CanonicalErrorCode::Unimplemented => tonic::Code::Unimplemented,
            CanonicalErrorCode::Internal => tonic::Code::Internal,
            CanonicalErrorCode::Unavailable => tonic::Code::Unavailable,
            CanonicalErrorCode::DataLoss => tonic::Code::DataLoss,
            // canonical_error module does not model Ok or Cancelled.
        },
        canonical_error.message)
}

pub mod cedar {
    // The string specified here must match the proto package name.
    tonic::include_proto!("cedar");
}

struct MyCedar {
    camera: Arc<Mutex<asi_camera::ASICamera>>,
    operation_settings: Mutex<OperationSettings>,
    detect_engine: Arc<Mutex<DetectEngine>>,
    solve_engine: Arc<Mutex<SolveEngine>>,
    // TODO: calibration_engine.
}

#[tonic::async_trait]
impl Cedar for MyCedar {
    // TODO: get_server_information RPC.
    // TODO: update_fixed_settings RPC.

    async fn update_operation_settings(
        &self, request: tonic::Request<OperationSettings>)
        -> Result<tonic::Response<OperationSettings>, tonic::Status>
    {
        let req: OperationSettings = request.into_inner();
        if req.camera_gain.is_some() {
            let mut locked_camera = self.camera.lock().unwrap();
            match locked_camera.set_gain(Gain::new(req.camera_gain.unwrap())) {
                Ok(()) => (),
                Err(x) => { return Err(tonic_status(x)); }
            }
            self.operation_settings.lock().unwrap().camera_gain = req.camera_gain;
        }
        if req.camera_offset.is_some() {
            let mut locked_camera = self.camera.lock().unwrap();
            match locked_camera.set_offset(Offset::new(req.camera_offset.unwrap())) {
                Ok(()) => (),
                Err(x) => { return Err(tonic_status(x)); }
            }
            self.operation_settings.lock().unwrap().camera_offset = req.camera_offset;
        }
        if req.operating_mode.is_some() {
            return Err(tonic::Status::unimplemented(
                "rpc UpdateOperationSettings not implemented for operating_mode."));
        }
        if req.exposure_time.is_some() {
            let exp_time = req.exposure_time.clone().unwrap();
            if exp_time.seconds < 0 || exp_time.nanos < 0 {
                return Err(tonic::Status::invalid_argument(
                    format!("Got negative exposure_time: {}.", exp_time)));
            }
            let detect_engine = &mut self.detect_engine.lock().unwrap();
            let std_duration = std::time::Duration::try_from(exp_time).unwrap();
            match detect_engine.set_exposure_time(std_duration) {
                Ok(()) => (),
                Err(x) => { return Err(tonic_status(x)); }
            }
            // TODO: also set in solve_engine?
            self.operation_settings.lock().unwrap().exposure_time =
                Some(req.exposure_time.unwrap());
        }
        if req.stargate_sigma.is_some() {
            return Err(tonic::Status::unimplemented(
                "rpc UpdateOperationSettings not implemented for stargate_sigma."));
        }
        if req.stargate_max_size.is_some() {
            return Err(tonic::Status::unimplemented(
                "rpc UpdateOperationSettings not implemented for stargate_max_size."));
        }
        if req.update_interval.is_some() {
            let update_interval = req.update_interval.clone().unwrap();
            if update_interval.seconds < 0 || update_interval.nanos < 0 {
                return Err(tonic::Status::invalid_argument(
                    format!("Got negative update_interval: {}.", update_interval)));
            }
            let detect_engine = &mut self.detect_engine.lock().unwrap();
            let std_interval = std::time::Duration::try_from(update_interval).unwrap();
            match detect_engine.set_update_interval(std_interval) {
                Ok(()) => (),
                Err(x) => { return Err(tonic_status(x)); }
            }
            // TODO: also set in operation_engine.
            self.operation_settings.lock().unwrap().update_interval =
                Some(req.update_interval.unwrap());
        }
        if req.dwell_update_interval.is_some() {
            return Err(tonic::Status::unimplemented(
                "rpc UpdateOperationSettings not implemented for dwell_update_interval."));
        }
        if req.log_dwelled_positions.is_some() {
            return Err(tonic::Status::unimplemented(
                "rpc UpdateOperationSettings not implemented for log_dwelled_positions."));
        }

        Ok(tonic::Response::new(self.operation_settings.lock().unwrap().clone()))
    }

    async fn get_frame(&self, request: tonic::Request<FrameRequest>)
                       -> Result<tonic::Response<FrameResult>, tonic::Status> {
        let req_start = Instant::now();
        let req: FrameRequest = request.into_inner();
        let prev_frame_id = req.prev_frame_id;
        let main_image_mode = req.main_image_mode;

        let detect_result;
        {
            let detect_engine = &mut self.detect_engine.lock().unwrap();
            detect_result = detect_engine.get_next_result(prev_frame_id);
        }
        let _solve_result;
        {
            let solve_engine = &mut self.solve_engine.lock().unwrap();
            _solve_result = solve_engine.get_next_result(prev_frame_id);
        }

        let captured_image = &detect_result.captured_image;
        let (width, height) = captured_image.image.dimensions();
        let image_rectangle = Rectangle{
            origin_x: 0, origin_y: 0,
            width: width as i32,
            height: height as i32,
        };

        let mut centroids = Vec::<StarCentroid>::new();
        for star in detect_result.star_candidates {
            centroids.push(StarCentroid{
                centroid_position: Some(ImageCoord {
                    x: star.centroid_x, y: star.centroid_y,
                }),
                stddev_x: star.stddev_x, stddev_y: star.stddev_y,
                mean_brightness: star.mean_brightness,
                background: star.background,
                num_saturated: star.num_saturated as i32,
            });
        }

        let mut frame_result = cedar::FrameResult {
            frame_id: detect_result.frame_id,
            operation_settings: Some(self.operation_settings.lock().unwrap().clone()),
            image: None,  // Is set below.
            star_candidates: centroids,
            hot_pixel_count: detect_result.hot_pixel_count,
            exposure_time: Some(prost_types::Duration::try_from(
                captured_image.capture_params.exposure_duration).unwrap()),
            result_update_interval: None,  // TODO: compute this as moving average.
            capture_time: Some(prost_types::Timestamp::try_from(
                captured_image.readout_time).unwrap()),
            camera_temperature_celsius: captured_image.temperature.0 as f32,
            center_region: match &detect_result.focus_aid {
                Some(fa) => Some(Rectangle {
                    origin_x: fa.center_region.left(),
                    origin_y: fa.center_region.top(),
                    width: fa.center_region.width() as i32,
                    height: fa.center_region.height() as i32,
                }),
                None => None,
            },
            center_peak_position: match &detect_result.focus_aid {
                Some(fa) => Some(ImageCoord {
                    x: fa.center_peak_position.0 as f32,
                    y: fa.center_peak_position.1 as f32,
                }),
                None => None,
            },
            center_peak_image: None,  // Is set below.
            calibration_phase: CalibrationPhase::None as i32,
            calibration_progress: None,
            plate_solution: None,
            camera_motion: None,
            ra_rate: None,
            dec_rate: None,
        };
        // Populate `image` if requested.
        if main_image_mode == ImageMode::Default as i32 {
            let mut main_bmp_buf = Vec::<u8>::new();
            let image = &captured_image.image;
            main_bmp_buf.reserve((2 * width * height) as usize);
            image.write_to(&mut Cursor::new(&mut main_bmp_buf),
                           ImageOutputFormat::Bmp).unwrap();
            frame_result.image = Some(Image{
                binning_factor: 1,
                rectangle: Some(image_rectangle),
                image_data: main_bmp_buf,
            });
        } else if main_image_mode == ImageMode::Binned as i32 {
            let mut binned_bmp_buf = Vec::<u8>::new();
            let binned_image = &detect_result.binned_image;
            let (binned_width, binned_height) = binned_image.dimensions();
            binned_bmp_buf.reserve((2 * binned_width * binned_height) as usize);
            binned_image.write_to(&mut Cursor::new(&mut binned_bmp_buf),
                                  ImageOutputFormat::Bmp).unwrap();
            frame_result.image = Some(Image{
                binning_factor: 2,
                // Rectangle is always in full resolution coordinates.
                rectangle: Some(image_rectangle),
                image_data: binned_bmp_buf,
            });
        }
        if detect_result.focus_aid.is_some() {
            // Populate `center_peak_image`.
            let mut center_peak_bmp_buf = Vec::<u8>::new();
            let center_peak_image = &detect_result.focus_aid.as_ref().unwrap().peak_image;
            let peak_image_region = &detect_result.focus_aid.as_ref().unwrap().peak_image_region;
            let (center_peak_width, center_peak_height) =
                center_peak_image.dimensions();
            center_peak_bmp_buf.reserve(
                (2 * center_peak_width * center_peak_height) as usize);
            center_peak_image.write_to(&mut Cursor::new(&mut center_peak_bmp_buf),
                                       ImageOutputFormat::Bmp).unwrap();
            frame_result.center_peak_image = Some(Image{
                binning_factor: 1,
                rectangle: Some(Rectangle{
                    origin_x: peak_image_region.left(),
                    origin_y: peak_image_region.top(),
                    width: peak_image_region.width() as i32,
                    height: peak_image_region.height() as i32,
                }),
                image_data: center_peak_bmp_buf,
            });
        }

        debug!("Responding to request: {:?} after {:?}", req, req_start.elapsed());
        Ok(tonic::Response::new(frame_result))
    }  // get_frame().
}

impl MyCedar {
    pub fn new(camera: Arc<Mutex<asi_camera::ASICamera>>) -> Self {
        let detect_engine = Arc::new(Mutex::new(DetectEngine::new(
            camera.clone(),
            /*update_interval=*/Duration::ZERO,
            /*exposure_time=*/Duration::ZERO,
            /*focus_mode_enabled=*/true)));
        let solve_engine = Arc::new(Mutex::new(SolveEngine::new(
            detect_engine.clone(),
            // TODO(smr): where to get this from?
            "/home/pi/tetra3.sock".to_string(),
            /*update_interval=*/Duration::ZERO)));
        MyCedar {
            camera: camera.clone(),
            operation_settings: Mutex::new(OperationSettings {
                camera_gain: Some(100),
                camera_offset: Some(0),
                operating_mode: Some(OperatingMode::Setup as i32),
                exposure_time: Some(prost_types::Duration {
                    seconds: 0, nanos: 0,
                }),
                stargate_sigma: Some(8.0),
                stargate_max_size: Some(5),
                update_interval: Some(prost_types::Duration {
                    seconds: 0, nanos: 0,
                }),
                dwell_update_interval: Some(prost_types::Duration {
                    seconds: 1, nanos: 0,
                }),
                log_dwelled_positions: Some(false),
            }),
            detect_engine: detect_engine.clone(),
            solve_engine: solve_engine.clone(),
        }
    }
}

#[tokio::main]
async fn main() {
    env_logger::Builder::from_env(
        env_logger::Env::default().default_filter_or("info")).init();

    // Build the static content web service.
    let rest = Router::new().nest_service(
        "/", ServeDir::new("/home/pi/projects/cedar/cedar_flutter/build/web"));

    let mut camera = asi_camera::ASICamera::new(
        asi_camera2::asi_camera2_sdk::ASICamera::new(0)).unwrap();
    camera.set_exposure_duration(Duration::from_millis(5)).unwrap();
    camera.set_gain(Gain::new(100)).unwrap();
    let shared_camera = Arc::new(Mutex::new(camera));

    // Build the grpc service.
    let grpc = tonic::transport::Server::builder()
        .accept_http1(true)
        .layer(GrpcWebLayer::new())
        .layer(CorsLayer::new().allow_origin(Any).allow_methods(Any))
        .add_service(CedarServer::new(MyCedar::new(shared_camera.clone())))
        .into_service();

    // Combine them into one service.
    let service = MultiplexService::new(rest, grpc);

    // Listen on any address for the given port.
    let addr = SocketAddr::from(([0, 0, 0, 0], 8080));
    hyper::Server::bind(&addr)
        .serve(tower::make::Shared::new(service))
        .await
        .unwrap();
}

mod multiplex_service {
    // Adapted from
    // https://github.com/tokio-rs/axum/tree/main/examples/rest-grpc-multiplex
    use axum::{
        http::Request,
        http::header::CONTENT_TYPE,
        response::{IntoResponse, Response},
    };
    use futures::{future::BoxFuture, ready};
    use std::{
        convert::Infallible,
        task::{Context, Poll},
    };
    use tower::Service;

    pub struct MultiplexService<A, B> {
        rest: A,
        rest_ready: bool,
        grpc: B,
        grpc_ready: bool,
    }

    impl<A, B> MultiplexService<A, B> {
        pub fn new(rest: A, grpc: B) -> Self {
            Self {
                rest,
                rest_ready: false,
                grpc,
                grpc_ready: false,
            }
        }
    }

    impl<A, B> Clone for MultiplexService<A, B>
    where
        A: Clone,
        B: Clone,
    {
        fn clone(&self) -> Self {
            Self {
                rest: self.rest.clone(),
                grpc: self.grpc.clone(),
                // the cloned services probably wont be ready
                rest_ready: false,
                grpc_ready: false,
            }
        }
    }

    impl<A, B> Service<Request<hyper::Body>> for MultiplexService<A, B>
    where
        A: Service<Request<hyper::Body>, Error = Infallible>,
        A::Response: IntoResponse,
        A::Future: Send + 'static,
        B: Service<Request<hyper::Body>>,
        B::Response: IntoResponse,
        B::Future: Send + 'static,
    {
        type Response = Response;
        type Error = B::Error;
        type Future = BoxFuture<'static, Result<Self::Response, Self::Error>>;

        fn poll_ready(&mut self, cx: &mut Context<'_>) -> Poll<Result<(), Self::Error>> {
            // drive readiness for each inner service and record which is ready
            loop {
                match (self.rest_ready, self.grpc_ready) {
                    (true, true) => {
                        return Ok(()).into();
                    }
                    (false, _) => {
                        ready!(self.rest.poll_ready(cx)).map_err(|err| match err {})?;
                        self.rest_ready = true;
                    }
                    (_, false) => {
                        ready!(self.grpc.poll_ready(cx))?;
                        self.grpc_ready = true;
                    }
                }
            }
        }

        fn call(&mut self, req: Request<hyper::Body>) -> Self::Future {
            // require users to call `poll_ready` first, if they don't we're allowed to panic
            // as per the `tower::Service` contract
            assert!(
                self.grpc_ready,
                "grpc service not ready. Did you forget to call `poll_ready`?"
            );
            assert!(
                self.rest_ready,
                "rest service not ready. Did you forget to call `poll_ready`?"
            );

            // if we get a grpc request call the grpc service, otherwise call the rest service
            // when calling a service it becomes not-ready so we have drive readiness again
            if is_grpc_request(&req) {
                self.grpc_ready = false;
                let future = self.grpc.call(req);
                Box::pin(async move {
                    let res = future.await?;
                    Ok(res.into_response())
                })
            } else {
                self.rest_ready = false;
                let future = self.rest.call(req);
                Box::pin(async move {
                    let res = future.await.map_err(|err| match err {})?;
                    Ok(res.into_response())
                })
            }
        }
    }

    fn is_grpc_request<B>(req: &Request<B>) -> bool {
        req.headers()
            .get(CONTENT_TYPE)
            .map(|content_type| content_type.as_bytes())
            .filter(|content_type| content_type.starts_with(b"application/grpc"))
            .is_some()
    }
}
