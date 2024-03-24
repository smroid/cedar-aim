use log::{debug, warn};
use std::time::{Duration, SystemTime};

use crate::cedar::{MotionEstimate, MotionType};
use crate::rate_estimator::RateEstimation;
use crate::tetra3_server::CelestialCoord;

#[derive(Debug, PartialEq)]
enum State {
    // MotionEstimator is newly constructed, or too much time has passed without
    // a position passed to add().
    Unknown,

    // While Unknown, a call to add() received a position. Alternately, while
    // Moving, Stopped, or SteadyRate, another add() with a very different
    // position was received.
    Moving,

    // While Moving, a call to add() received a position very similar to the
    // previous position, consistent with a fixed mount (position moving at
    // sidereal rate) or a tracking mount (position nearly motionless in ra/dec)
    // that is "motionless" (not slewing).
    Stopped,

    // From Stopped, the next add()ed position is consistent with the previous
    // two points, for either a tracking or fixed mount. We continue in SteadyRate
    // as long as newly add()ed positions are consistent with the existing rate
    // estimates.
    SteadyRate,
}

pub struct MotionEstimator {
    // The current state of this MotionEstimator.
    state: State,

    // How long we can tolerate lack of position updates before reverting
    // to Unknown state.
    gap_tolerance: Duration,

    // Time/position passed to most recent add() call. Updated only for add() calls
    // with non-None position arg.
    prev_time: Option<SystemTime>,
    prev_position: Option<CelestialCoord>,

    // Tracking rate estimation, used when add()ed positions are consistent with
    // a motionless fixed mount or tracking mount.
    ra_rate: RateEstimation,
    dec_rate: RateEstimation,
}

impl MotionEstimator {
    // `gap_tolerance` The amount of time add() calls can have position=None
    //     before our state reverts to Unknown.
    pub fn new(gap_tolerance: Duration) -> Self {
        MotionEstimator{
            state: State::Unknown,
            gap_tolerance,
            prev_time: None,
            prev_position: None,
            ra_rate: RateEstimation::new(100),
            dec_rate: RateEstimation::new(100),
        }
    }

    // `time` Time at which the image corresponding to `boresight_position` was
    //     captured. Must not be earlier than `time` passed to previous add()
    //     call.
    // `position` A successfully plate-solved determination of the telescope's
    //     aim point as of `time`. None if there was no solution (perhaps
    //     because the telescope is slewing).
    // `position_rmse` If `position` is provided, this will be the RMS error (in
    //     arcseconds) of the plate solution. This represents the noise level
    //     associated with `position`.
    pub fn add(&mut self, mut time: SystemTime, position: Option<CelestialCoord>,
               position_rmse: Option<f32>) {
        let prev_time = self.prev_time;
        let prev_pos = self.prev_position.clone();
        if position.is_some() {
            self.prev_time = Some(time);
            self.prev_position = position.clone();
        }
        if prev_time.is_none() {
            if position.is_some() {
                // This is the first call to add() with a position.
                self.set_state(State::Moving);
            }
            return;
        }
        let prev_time = prev_time.unwrap();
        let prev_pos = prev_pos.unwrap();
        if time < prev_time {
            warn!("Time arg regressed from {:?} to {:?}", prev_time, time);
            time = prev_time + Duration::from_micros(1);
            if position.is_some() {
                self.prev_time = Some(time);
            }
        }

        if position.is_none() {
            if self.state == State::Unknown {
                return;
            }
            // Has gap persisted for too long?
            if time.duration_since(prev_time).unwrap() > self.gap_tolerance {
                self.set_state(State::Unknown);
                self.ra_rate.clear();
                self.dec_rate.clear();
            }
            return;
        }
        let position = position.unwrap();
        let position_rmse = position_rmse.unwrap() / 3600.0;  // arcsec->deg.
        match self.state {
            State::Unknown => {
                self.set_state(State::Moving);
            },
            State::Moving => {
                // Compare new position/time to previous position/time.
                if Self::is_stopped(time, &position, position_rmse, prev_time, &prev_pos) {
                    self.set_state(State::Stopped);
                    // Enter the two points into our rate trackers.
                    self.ra_rate.add(
                        prev_time, prev_pos.ra as f64);
                    self.ra_rate.add(time, position.ra as f64);
                    self.dec_rate.add(
                        prev_time, prev_pos.dec as f64);
                    self.dec_rate.add(time, position.dec as f64);
                }
            },
            State::Stopped => {
                // Compare new position/time to previous position/time.
                if Self::is_stopped(time, &position, position_rmse, prev_time, &prev_pos) {
                    self.set_state(State::SteadyRate);
                    self.ra_rate.add(time, position.ra as f64);
                    self.dec_rate.add(time, position.dec as f64);
                } else {
                    self.set_state(State::Moving);
                    self.ra_rate.clear();
                    self.dec_rate.clear();
                }
            },
            State::SteadyRate => {
                if self.ra_rate.fits_trend(time, position.ra as f64, /*sigma=*/8.0) &&
                    self.dec_rate.fits_trend(time, position.dec as f64, /*sigma=*/8.0)
                {
                    self.ra_rate.add(time, position.ra as f64);
                    self.dec_rate.add(time, position.dec as f64);
                } else {
                    self.set_state(State::Moving);
                    self.ra_rate.clear();
                    self.dec_rate.clear();
                }
            },
        }
    }

    fn set_state(&mut self, state: State) {
        debug!("state -> {:?}", state);
        self.state = state;
    }

    pub fn get_estimate(&self) -> MotionEstimate {
        match self.state {
            State::Unknown => {
                MotionEstimate{camera_motion: MotionType::Unknown.into(),
                               ..Default::default()}
            },
            State::Moving | State::Stopped => {
                MotionEstimate{camera_motion: MotionType::Moving.into(),
                               ..Default::default()}
            },
            State::SteadyRate => {
                MotionEstimate{
                    camera_motion: MotionType::Dwelling.into(),
                    ra_rate: Some(self.ra_rate.slope() as f32),
                    ra_rate_error: Some(self.ra_rate.rate_interval_bound() as f32),
                    dec_rate: Some(self.dec_rate.slope() as f32),
                    dec_rate_error: Some(self.dec_rate.rate_interval_bound() as f32),
                }
            },
        }
    }

    fn is_stopped(time: SystemTime, pos: &CelestialCoord, pos_rmse: f32,
                  prev_time: SystemTime, prev_pos: &CelestialCoord) -> bool {
        let elapsed_secs =
            time.duration_since(prev_time).unwrap().as_secs_f32();

        // Max movement rate below which we are considered to be stopped.
        let max_rate = f32::max(pos_rmse * 8.0, Self::SIDEREAL_RATE * 2.0);

        let dec_rate = Self::dec_change(prev_pos.dec, pos.dec) / elapsed_secs;
        if dec_rate.abs() > max_rate {
            return false;
        }
        let ra_rate = Self::ra_change(prev_pos.ra, pos.ra) / elapsed_secs;
        ra_rate.abs() <= max_rate
    }

    const SIDEREAL_RATE: f32 = 15.04 / 3600.0;  // Degrees per second.

    // Computes the change in declination between `prev_dec` and `cur_dec`. All
    // are in degrees.
    fn dec_change(prev_dec: f32, cur_dec: f32) -> f32 {
        cur_dec - prev_dec
    }

    // Computes the change in right ascension between `prev_ra` and `cur_ra`.
    // Care is taken when crossing the 360..0 boundary.
    // All are in degrees.
    fn ra_change(mut prev_ra: f32, mut cur_ra: f32) -> f32 {
        if prev_ra < 45.0 && cur_ra > 315.0 {
            prev_ra += 360.0;
        }
        if cur_ra < 45.0 && prev_ra > 315.0 {
            cur_ra += 360.0;
        }
        cur_ra - prev_ra
    }
}

#[cfg(test)]
mod tests {
    // extern crate approx;
    // use approx::assert_abs_diff_eq;
    use super::*;

    #[test]
    fn test_dec_change() {
        assert_eq!(MotionEstimator::dec_change(10.0, 15.0), 5.0);
        assert_eq!(MotionEstimator::dec_change(-10.0, 15.0), 25.0);
        assert_eq!(MotionEstimator::dec_change(15.0, 10.0), -5.0);
    }

    #[test]
    fn test_ra_change() {
        assert_eq!(MotionEstimator::ra_change(10.0, 15.0), 5.0);
        assert_eq!(MotionEstimator::ra_change(350.0, 355.0), 5.0);
        assert_eq!(MotionEstimator::ra_change(355.0, 360.0), 5.0);
        assert_eq!(MotionEstimator::ra_change(356.0, 1.0), 5.0);

        assert_eq!(MotionEstimator::ra_change(15.0, 10.0), -5.0);
        assert_eq!(MotionEstimator::ra_change(355.0, 350.0), -5.0);
        assert_eq!(MotionEstimator::ra_change(360.0, 355.0), -5.0);
        assert_eq!(MotionEstimator::ra_change(1.0, 356.0), -5.0);
    }

}  // mod tests.
