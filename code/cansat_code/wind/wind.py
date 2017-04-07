import Adafruit_ADS1x15
import time
adc = Adafruit_ADS1x15.ADS1115()
GAIN = 1
DATARATE = 128
ENC_NUM = 3 #may be 2 or 3
SAMPLE_SIZE = 5
BORDER_VALUE = 3200

def read_state():
    value = adc.read_adc(ENC_NUM, gain=GAIN, data_rate=DATARATE)
    if value<BORDER_VALUE:
        return 0
    else:
        return 1


def read_time():
    primary_time=time.time()
    primary=read_state()
    end_time = time.time()
    while read_state() == primary:
        end_time=time.time()
    return end_time-primary_time


def read_frequency():
    return 1/read_time()


def read_mean_frequency():
    total=0
    for i in range(0, SAMPLE_SIZE):
        total += read_frequency()
    return total/SAMPLE_SIZE
