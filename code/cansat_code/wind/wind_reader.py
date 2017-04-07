#!/usr/bin/python

from wind import *
from datetime import datetime
import time
file_datetable = open('/home/pi/data/wind/datetable.txt', 'a')
while True:
        file_last_read = open('/home/pi/data/wind/last_read_number.txt', 'r')
        last_read=int(file_last_read.read())
        file_last_read.close()
        read=last_read+1
        file_output = open('/home/pi/data/wind/'+str(read), 'w')
        file_output.write(str(read_mean_frequency()))
        file_output.close()
        file_last_read = open('/home/pi/data/wind/last_read_number.txt', 'w')
        file_last_read.write(str(read))
        file_last_read.close()
        file_datetable.write(str(read)+','+datetime.now().strftime('%Y,%m,%d,%H,%M,%S')+'\n')
###     uncomment next line for less data flow  ###
        time.sleep(1)
