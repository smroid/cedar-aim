use std::sync::{Arc, Mutex};

use ascom_alpaca::{ASCOMResult, Server};
use ascom_alpaca::api::{AlignmentMode, CargoServerInfo, Device, EquatorialSystem, Telescope};
use async_trait::async_trait;

#[derive(Default, Debug)]
pub struct CelestialPosition {
    // Both in degrees.
    pub ra: f64,  // 0..360
    pub dec: f64, // -90..90

    // If true, ra/dec are current. If false, ra/dec are stale.
    pub valid: bool,

    // SkySafari does not provide a way to signal that the ra/dec values are
    // not valid. We instead "animate" the reported ra/dec position during
    // times of invalidity.
    updates_while_invalid: i32,
}

impl CelestialPosition {
    pub fn new() -> Self {
        // Sky Safari doesn't display (0.0, 0.0).
        CelestialPosition{ra: 180.0, dec: 0.0, ..Default::default()}
    }
}

#[derive(Debug)]
pub struct MyTelescope {
    position: Arc<Mutex<CelestialPosition>>
}

impl MyTelescope {
    pub fn new(position: Arc<Mutex<CelestialPosition>>) -> Self {
        MyTelescope{ position }
    }
}

#[async_trait]
impl Device for MyTelescope {
    fn static_name(&self) -> &str { "CedarTelescopeEmulator" }
    fn unique_id(&self) -> &str { "CedarTelescopeEmulator-42" }

    async fn connected(&self) -> ASCOMResult<bool> { Ok(true) }
    async fn set_connected(&self, _connected: bool) -> ASCOMResult { Ok(()) }
}

#[async_trait]
impl Telescope for MyTelescope {
    async fn alignment_mode(&self) -> ASCOMResult<AlignmentMode> {
        Ok(AlignmentMode::Polar)
    }

    async fn equatorial_system(&self) -> ASCOMResult<EquatorialSystem> {
        Ok(EquatorialSystem::J2000)
    }

    // Degrees.
    async fn declination(&self) -> ASCOMResult<f64> {
        let mut locked_position = self.position.lock().unwrap();
        if locked_position.valid {
            Ok(locked_position.dec)
        } else {
            // Sky Safari does not respond to error returns. To indicate
            // the position data is stale, we "wiggle" the position.
            locked_position.updates_while_invalid += 1;
            if locked_position.updates_while_invalid & 1 == 0 {
                if locked_position.dec > 0.0 {
                    Ok(locked_position.dec - 1.0)
                } else {
                    Ok(locked_position.dec + 1.0)
                }
            } else {
                Ok(locked_position.dec)
            }
        }
    }

    // Hours.
    async fn right_ascension(&self) -> ASCOMResult<f64> {
        let locked_position = self.position.lock().unwrap();
        Ok(locked_position.ra / 15.0)
    }

    async fn tracking(&self) -> ASCOMResult<bool> {
        Ok(false)
    }
}

pub fn create_alpaca_server(position: Arc<Mutex<CelestialPosition>>) -> Server {
    let mut server = Server {
        info: CargoServerInfo!(),
        ..Default::default()
    };
    server.listen_addr.set_port(11111);
    server.devices.register(MyTelescope::new(position));
    server
}
