#!/usr/bin/python

from time import sleep

from lsm6ds33 import LSM6DS33
from lis3mdl import LIS3MDL
from lps25h import LPS25H

imu = LSM6DS33()
imu.enableLSM()

magnet = LIS3MDL()
magnet.enableLIS()

baro = LPS25H()
baro.enableLPS()
###Uncomment below lines to show debug###
"""
while True:
    print "Gyro:", imu.getGyroscopeRaw()
    print "Accelerometer:", imu.getAccelerometerRaw()
    print "Magnet:", magnet.getMagnetometerRaw()
    print "hPa:", baro.getBarometerMillibars()
    print "Altitude:", baro.getAltitude()
    sleep(5)
"""
def read_altimu():
	string=",".join(map(str,imu.getGyroscopeRaw()+imu.getAccelerometerRaw()+magnet.getMagnetometerRaw()+baro.getBarometerMillibars()+baro.getAltitude()))
	return(string)
