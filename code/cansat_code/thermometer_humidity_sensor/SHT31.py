#imports
from Adafruit_SHT31 import *
#sensor address declaration
sensor = SHT31(address = 0x44)
#main functions definitions
def read_temperature():
	sensor = SHT31(address = 0x44)
	return (sensor.read_temperature())
def read_humidity():
	sensor = SHT31(address = 0x44)
	return (sensor.read_humidity())
