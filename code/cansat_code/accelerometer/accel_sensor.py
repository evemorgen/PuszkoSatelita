from time import sleep
from datetime import datetime
from altimu import AltIMU

imu = AltIMU()
imu.enable()

imu.calibrateGyroAngles()
start = datetime.now()

while True:
    stop = datetime.now() - start
    start = datetime.now()
    deltaT = stop.microseconds/1000000.0
    print(" ")
    print("Loop:", deltaT)
    print("Accel:", imu.getAccelerometerAngles())
    print("Gyro:", imu.trackGyroAngles(deltaT = deltaT))
    sleep(0.5)
