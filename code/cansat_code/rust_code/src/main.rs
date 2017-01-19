use std::thread::sleep;
use std::time::Duration;

use pi::i2c::{Master, Read, Write};
mod sensors;

fn main() {
    let bus = Master::open(1).unwrap();

    let mut rd_buf = [0u8; ..2];

    loop {
        bus.transaction(0x44, [
            Write([0x00]),
            Read(rd_buf.as_mut_slice())]).unwrap();
        println!("{}", rd_buf[1]);

        sleep(Duration::from_millis(500));
    }
}
