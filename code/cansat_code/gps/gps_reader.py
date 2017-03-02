from gps import read_gps_data
from datetime import datetime
import time
file_datetable = open('/home/pi/data/gps/datetable.txt', 'a')
while True:
        file_last_read = open('/home/pi/data/gps/last_read_number.txt', 'r+')
        last_read=int(file_last_read.read())
        file_last_read = open('/home/pi/data/gps/last_read_number.txt', 'w')
        read = last_read + 1
        file_last_read.write(str(read))
        file_last_read.close()
        data = str(read_gps_data())
        file_output = open('/home/pi/data/gps/'+str(read), 'w')
        file_output.write(data)
        file_output.close()
        file_datetable.write(str(read)+','+datetime.now().strftime('%Y,%m,%d,%H,%M,%S')+'\n')
###     uncomment next line for less data flow  ###
        time.sleep(1)
