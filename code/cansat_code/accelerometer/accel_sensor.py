from time import sleep

from altimu import AltIMU

imu = AltIMU()
imu.enable()

imu.calibrateGyroAngles()


while True:
    print("Accel:", imu.getAccelerometerAngles())
    print("Gyro:", imu.trackGyroAngles(deltaT = deltaT))
    sleep(0.5)
