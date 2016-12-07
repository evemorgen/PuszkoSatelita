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
        return 0
        GPIO.setmode(GPIO.BCM)
        GPIO.setup(self.RCpin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

    def getSensorData(self):
        return ('jj', 'cansat')
        RHW, TW = Adafruit_DHT.read_retry(Adafruit_DHT.DHT11, self.DHTpin)
        return str(RHW, TW)

    def RCtime(self):
        return '69'
        LT = 0

        if GPIO.input(self.RCpin) is True:
            LT += 1
        return str(LT)

    def loop(self):
        print("DHT11 test program by JJCanSat team")
        print('            Starting...')

        while True:
            try:
                print('chuj')
                RHW, TW = self.getSensorData()
                print('fuck'+ RHW, TW)
                LT = self.RCtime()
                print()
                print(RHW + ' -- ' + TW + ' -- ' + LT)
                sleep(self.myDelay)

            except:
                print('Exiting. cunt')
                break
