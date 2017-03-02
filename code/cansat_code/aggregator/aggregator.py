from datetime import datetime
import time

while True:
    lasttxstamp_file= open('/home/pi/data/radio/last_tx_stamp.txt', 'r')
    lasttxstamp=lasttxstamp_file.readline()
    lasttxstamp_file = open('/home/pi/data/radio/last_tx_stamp.txt', 'w')
    lasttxstamp_file.write(str(int(lasttxstamp)+1))
    lasttxstamp_file.close()
    txstamp=(str(int(lasttxstamp) + 1))
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
    lastaltimu = open(
        '/home/pi/data/altimu/last_read_number.txt', 'r').readline()
    altimu = open(
        '/home/pi/data/altimu/' + str(lastaltimu)).readline()
    timedate=datetime.now().strftime('%Y,%m,%d,%H,%M,%S')
    string=txstamp+','+timedate+","+temperature+','+humidity+','+gps+','+altimu
    current = open('/home/pi/data/radio/current.txt', 'w')
    current.write(string)
    current.close()
    time.sleep(1)