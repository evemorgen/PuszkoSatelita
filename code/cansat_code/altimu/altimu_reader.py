from read_altimu import read_altimu
from datetime import datetime
import time

file_datetable = open('/home/pi/data/altimu/datetable.txt', 'a')
while True:
    file_last_read = open('/home/pi/data/altimu/last_read_number.txt', 'r+')
    last_read = int(file_last_read.read())
    read = last_read + 1
    file_output = open('/home/pi/data/altimu/' + str(read), 'w')
    file_output.write(str(read_altimu()))
    file_last_read = open('/home/pi/data/altimu/last_read_number.txt', 'w')
    file_last_read.write(str(read))
    file_datetable.write(str(read) + ',' + datetime.now().strftime('%Y,%m,%d,%H,%M,%S') + '\n')
    ###     uncomment next line for less data flow  ###
    time.sleep(1)
