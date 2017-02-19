from smbus import SMBus
from functions import *
bus = SMBus(1)
LSM = 0x6b #address on the raspberry pi
### Part originally from karl16 who did great work creating an almost complete lib for Pololu Altimu ###

#Control register addresses -- from LSM303D datasheet(acc and mag)
LSM_CTRL_0 = 0x1F #General settings
LSM_CTRL_1 = 0x20 #Turns on accelerometer and configures data rate
LSM_CTRL_2 = 0x21 #Self test accelerometer, anti-aliasing accel filter
LSM_CTRL_3 = 0x22 #Interrupts
LSM_CTRL_4 = 0x23 #Interrupts
LSM_CTRL_5 = 0x24 #Turns on temperature sensor
LSM_CTRL_6 = 0x25 #Magnetic resolution selection, data rate config
LSM_CTRL_7 = 0x26 #Turns on magnetometer and adjusts mode

#Control register addresses -- from L3GD20H datasheet (GYRO)
L3G_CTRL_1 = 0x20 #Turns on Gyro and configures data rate
L3G_CTRL_2 = 0x21 #Filter mode and edge or level sensitive enable 
L3G_CTRL_3 = 0x22 #Interrupts
L3G_CTRL_4 = 0x23 #Interrupts and also self test
L3G_CTRL_5 = 0x24 #General settings

#Control register addresses -- from LPS25H datasheet (barometer/altimeter)
LPS_CTRL_1 = 0x20 #
LPS_CTRL_2 = 0x21 #General settings
LPS_CTRL_3 = 0x22 #
LPS_CTRL_4 = 0x23 #
LPS_CTRL_5 = 0x24 #Interrupts called INTERRUPT_CFG
LPS_CTRL_6 = 0x25 #Interrupt called INT_SOURCE

#LSM303D
#Registers holding twos-complemented MSB and LSB of magnetometer readings -- from LSM303D datasheet
MAG_X_LSB = 0x08 # x
MAG_X_MSB = 0x09
MAG_Y_LSB = 0x0A # y
MAG_Y_MSB = 0x0B
MAG_Z_LSB = 0x0C # z
MAG_Z_MSB = 0x0D
#Registers holding twos-complemented MSB and LSB of magnetometer readings -- from LSM303D datasheet
ACC_X_LSB = 0x28 # x
ACC_X_MSB = 0x29
ACC_Y_LSB = 0x2A # y
ACC_Y_MSB = 0x2B
ACC_Z_LSB = 0x2C # z
ACC_Z_MSB = 0x2D
#Registers holding 12-bit right justified, twos-complemented temperature data -- from LSM303D datasheet
TEMP_MSB = 0x05
TEMP_LSB = 0x06

#LPS25H
#Registers holding the 12-bit two's complemented pressure data-- from datasheet LPS25H
PRESS_XL = 0x28 #lowest part of the pressure
PRESS_L = 0x29 #middle part of the pressure
PRESS_H = 0x2A # highest part of the pressure 
#registers holding 12-bit twos-complemented temperature data-- from datasheet LPS25H
TEMP_L = 0x2B #low part of temperature
TEMP_H = 0x2C #high part of the temperature

#L3GD20H
#Registers holding twos-complemented gyro readings -- L3GD20H datasheet
GYRO_X_L = 0x28 #X
GYRO_X_H = 0x29 
GYRO_Y_L = 0x2A #Y
GYRO_Y_H = 0x2B 
GYRO_Z_L = 0x2C #Z 
GYRO_Z_H = 0x2D

def initiate():
    bus.write_byte_data(LSM, LSM_CTRL_1, 0b01010111)
    bus.write_byte_data(LSM, LSM_CTRL_2, 0x00) #may require further changes to compute maxg
    bus.write_byte_data(LSM, LSM_CTRL_5, 0b11100100) 
    bus.write_byte_data(LSM, LSM_CTRL_7, 0b00010000)
def read_acceleration(direction):
    if (direction==0):
        ret = (twos_comp_combine(bus.read_byte_data(LSM, ACC_X_MSB), bus.read_byte_data(LSM, ACC_X_LSB)))
    if (direction==1):
        ret = (twos_comp_combine(bus.read_byte_data(LSM, ACC_Y_MSB), bus.read_byte_data(LSM, ACC_Y_LSB)))
    if (direction==2):
        ret = (twos_comp_combine(bus.read_byte_data(LSM, ACC_Z_MSB), bus.read_byte_data(LSM, ACC_Z_LSB)))
    ret=convert_acc(ret)
    return (ret)
