#!/usr/bin/python

import pigpio

RX=5

try:
    pi = pigpio.pi()
    pi.set_mode(RX, pigpio.INPUT)
    pi.bb_serial_read_open(RX, 9600, 8)
    line_counter = 0
    while 1:
        string=""
        while line_counter <4 :
                (count, data) = pi.bb_serial_read(RX)
                if "\n" in data:
                        line_counter += 1
                if count:
                        string += data
        file_output = open('/home/pi/data/gps/current.txt', 'w')
        file_output.write(string)
        file_output.close()
        line_counter = 0
except:
        pi.bb_serial_read_close(RX)
        pi.stop()
