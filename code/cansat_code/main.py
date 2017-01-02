"""
JJ CanSat team code
Licensed under h3h3 license
"""

from time import sleep
from thermometer import temperature_sensor as temp


def main():
    temp_sensor = temp.TemperatureSensor(1)
    temp_sensor.loop()


if __name__ == '__main__':
    main()
