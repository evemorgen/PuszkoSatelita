import datetime
import time

while True:
    lasttemperature = open(
        '/home/pi/data/temperature/last_read_number.txt').readline()
    temperature = str(round(float(open(
        '/home/pi/data/temperature/'+str(lasttemperature)).readline()),2))
    lasthumidity = open(
        '/home/pi/data/humidity/last_read_number.txt').readline()
    humidity = str(round(float(open(
        '/home/pi/data/humidity/' + str(lasthumidity)).readline()),2))
    lastgps = open(
        '/home/pi/data/gps/last_read_number.txt').readline()
    gps = open(
        '/home/pi/data/gps/' + str(lastgps)).readline()
    string=temperature+','+humidity+','+gps
    print string
    time.sleep(10)