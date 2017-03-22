import Adafruit_ADS1x15
adc = Adafruit_ADS1x15.ADS1115()
GAIN = 1
DATARATE=128
def read_voltage(batnum):
    value = adc.read_adc(batnum, gain=GAIN, data_rate=DATARATE)
    return value

