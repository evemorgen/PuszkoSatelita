extern crate sysfs_gpio;

use sysfs_gpio::{Direction, Pin};
use std::env;
use std::thread::sleep_ms;
use std::time::Duration;

fn main() {
    match poll(23) {
        Ok(()) => println!("Polling complete!"),
        Err(err) => println!("Error: {}", err),
    }
}

fn poll(pin_num: u8) -> sysfs_gpio::Result<()> {
    let input = Pin::new(pin_num)
    input.with_exported(|| {
        try!(input.set_direction(Direction::In));
        let mut prev_val: u8 = 255;
        loop {
            let val = try!(input.get_value());
            if val != prev_val {
                println!("Pin State: {}", 
                         if val == 0 {
                            "Low"
                         }
                         else {
                            "High"
                         });
                prev_val = val;
            }
            sleep_ms(Duration::from_millis(10));
        }
    })
}
