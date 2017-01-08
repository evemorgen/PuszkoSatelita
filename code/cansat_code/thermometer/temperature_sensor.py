# import RPi.GPIO as GPIO
from time import sleep
# import Adafruit_DHT


class TemperatureSensor():

    def __init__(self, delay):
        self.DEBUG = 1
        self.RCpin = 24
        self.DHTpin = 23
        try:
            self.myDelay = int(delay)
        except Exception:
            print("Input a proper value <int>.")
            raise Exception

    def initiazlize(self):
        GPIO.setmode(GPIO.BCM)
        GPIO.setup(self.RCpin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

    def getSensorData(self):
        RHW, TW = Adafruit_DHT.read_retry(Adafruit_DHT.DHT11, self.DHTpin)
        return str(RHW, TW)

    def RCtime(self):
        LT = 0
        if GPIO.input(self.RCpin) is True:
            LT += 1
        return str(LT)

    def loop(self):
        print("DHT11 test program by JJCanSat team")
        print('            Starting...')

        while True:
            try:
                RHW, TW = self.getSensorData()
                print(RHW, TW)
                LT = self.RCtime()
                print()
                print(RHW + ' -- ' + TW + ' -- ' + LT)
                sleep(self.myDelay)

            except:
                print('Exiting.')
                break
