import RPi.GPIO as GPIO
from time import sleep
import logging


class TemperatureSensor():

    def __init__(self, delay):
        self.DHTpin = 23
        logging.basicConfig(format='%(asctime)s --> %(message)s', level=logging.DEBUG)  # ,  filename='test.log')
        logging.debug('\nSTARTING TEST')
        if delay is not int:
            logging.warning('Input a proper value <int>.')
            quit()

    def __initiazlize(self):
        GPIO.setmode(GPIO.BCM)
        GPIO.setup(self.DHTpin, GPIO.IN)
        logging.info('Initialized pin')

    def __get_sensor_data(self):
        self.__initiazlize()
        data = GPIO.input(self.DHTpin)
        logging.info('Got data from pin')
        return data

    def loop(self):
        logging.info('Starting loop')
        loop_counter = 0
        while True:
            try:
                loop_counter += 1
                data = self.__get_sensor_data()
                logging.info('{} - data: {}'.format(loop_counter, data))
                sleep(self.myDelay)

            except:
                logging.exception('Quitting')
                break
