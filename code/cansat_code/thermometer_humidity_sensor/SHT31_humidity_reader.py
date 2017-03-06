#!/usr/bin/python

from SHT31 import *
from datetime import datetime
import time
file_datetable = open('/home/pi/data/humidity/datetable.txt', 'a')
while True:
        file_last_read = open('/home/pi/data/humidity/last_read_number.txt', 'r+')
        last_read=int(file_last_read.read())
        read=last_read+1
        file_output = open('/home/pi/data/humidity/'+str(read), 'w')
        file_output.write(str(read_humidity()))
        file_last_read = open('/home/pi/data/humidity/last_read_number.txt', 'w')
        file_last_read.write(str(read))
        file_datetable.write(str(read)+','+datetime.now().strftime('%Y,%m,%d,%H,%M,%S')+'\n')
###     uncomment next line for less data flow  ###
       time.sleep(1)
