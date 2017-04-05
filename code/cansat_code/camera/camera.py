#!/usr/bin/python

from picamera import PiCamera
from time import sleep
camera = PiCamera()

while True:
    file_last_read = open('/home/pi/data/camera/last_read_number.txt', 'r+')
    last_read = int(file_last_read.read())
    file_last_read.close()
    read = last_read + 1
    camera.capture('/home/pi/data/camera/image{0:04d}.jpg'.format(read))
    file_last_read = open('/home/pi/data/camera/last_read_number.txt', 'w')
    file_last_read.write(str(read))
    file_last_read.close()
    sleep (10)
