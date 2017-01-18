extern crate i2cdev;

use std::thread;
use std::time::Duration;

use i2cdev::core::*;
use i2cdev::linux::{LinuxI2CError, LinuxI2CDevice};

const ADAFRUIT_THERMOMETER_ADDR: u16 = 0x44;

fn main() {
    match read_temp() {
        LinuxI2CDevice => println!("no i dziala nie");
    }
}


fn read_temp() -> Result<(), LinuxI2CError> {
    let mut dev = try!(LinuxI2CDevice::new("/dev/i2c-0", ADAFRUIT_THERMOMETER_ADDR));

    loop {
        let mut buf: [u8; 6] = [0; 6];

        dev.smbus_write_byte(0x00).unwrap();
        thread::sleep(Duration::from_millis(10));
        dev.read(&mut buf).unwrap();
        println!("Reading: {:?}", buf);
        thread::sleep(Duration::from_millis(1000));   
    }
}
