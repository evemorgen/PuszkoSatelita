# import RPi.GPIO as GPIO
from time import sleep
from random import randint as r
# import Adafruit_DHT


class TemperatureSensor():

    def __init__(self, delay):
        self.DEBUG = 1
        self.RCpin = 24
        self.DHTpin = 23
        self.read_index = 0
        try:
            self.myDelay = int(delay)
        except Exception:
            print("Input a proper value <int>.")
            raise Exception

    def initiazlize(self):
        return 0
        GPIO.setmode(GPIO.BCM)
        GPIO.setup(self.RCpin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

    def getSensorData(self):
        self.read_index += 1
        return (str(r(10, 100)), str(r(10, 100)))
        hum, temp = Adafruit_DHT.read_retry(Adafruit_DHT.DHT11, self.DHTpin)
        return str(temp, hum)

    def loop(self):
        print("DHT11 test program by JJCanSat team")
        print('            Starting...')

        while True:
            try:
                hum, temp = self.getSensorData()
                print(str(self.read_index) + ':\t' + temp + '*C | ' + hum + '%')
                sleep(self.myDelay)

            except Exception:
                print('Exiting. cunt')
                raise Exception
                break
