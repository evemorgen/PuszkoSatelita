#!/usr/bin/python

from datetime import datetime
import time
import struct
import logging
def reader(name):
    last = open('/home/pi/data/'+name+'/last_read_number.txt').readline()
    if last=="":
        lastfile=open('/home/pi/data/'+name+'/last_read_number.txt', 'w')
        lastfile.write("50000")
        lastfile.close()
        file5k = open('/home/pi/data/' + name + '/50000', 'w')
        file5k.write("0")
        file5k.close()
        logging.info("fix applied to " + name)
        return 1
    return last

def compress(string):
    string=string.split(",")
    print string
    floatlist=[float(i) for i in string]
    x = struct.pack('%sf' % len(floatlist), *floatlist)
    print len(x)
    return x
formatter = "[%(asctime)s %(funcName)s %(process)d] %(message)s"
logging.basicConfig(level=logging.INFO, format=formatter, filename="/home/pi/data/agg_log.log")


while True:
    lasttxstamp_file= open('/home/pi/data/radio/last_tx_stamp.txt', 'r')
    lasttxstamp=lasttxstamp_file.read()
    lasttxstamp_file.close()
    txstamp=(str(int(lasttxstamp) + 1))
    lasttemperature = reader("temperature")
    logging.info("last_temp_read"+lasttemperature)
    temperature = str(round(float(open(
        '/home/pi/data/temperature/'+str(lasttemperature)).readline()),2))
    lasthumidity = reader("humidity")
    logging.info("last_hum_read" + lasthumidity)
    humidity = str(round(float(open(
        '/home/pi/data/humidity/' + str(lasthumidity)).readline()),2))
    lastgps = reader("gps")
    logging.info("last_gps_read" + lastgps)
    gps = open(
        '/home/pi/data/gps/' + str(lastgps)).readline()
    lastaltimu = reader("altimu")
    logging.info("last_alt_read" + lastaltimu)
    altimu = open(
        '/home/pi/data/altimu/' + str(lastaltimu)).readline()
    lastvoltage0 = reader("voltage0")
    logging.info("last_vol0_read" + lastvoltage0)
    voltage0 = open(
        '/home/pi/data/voltage0/' + str(lastvoltage0)).readline()
    lastvoltage1 = reader("voltage1")
    logging.info("last_vol1_read" + lastvoltage1)
    voltage1 = open(
        '/home/pi/data/voltage1/' + str(lastvoltage1)).readline()
    lastwind = reader("wind")
    logging.info("last_wind_read" + lastwind)
    wind = open(
        '/home/pi/data/wind/' + str(lastwind)).readline()
    timedate=str(datetime.now().strftime('%Y,%m,%d,%H,%M,%S'))
    date=timedate
    date = date.split(",")
    date=float(date[2])*86400+float(date[3])*3600+float(date[4])*60+float(date[5])
    date=str(date)
    string=txstamp+','+date+","+temperature+','+humidity+','+gps+','+altimu+','+voltage0+','+voltage1+','+wind
    logging.info(string)
    decoded = open('/home/pi/data/radio/decoded.txt', 'w')
    decoded.write(string)
    decoded.close()
    string = compress(string)
    current = open('/home/pi/data/radio/current.txt', 'w')
    current.write(string)
    current.close()
    lasttxstamp_file = open('/home/pi/data/radio/last_tx_stamp.txt', 'w')
    lasttxstamp_file.write(str(int(lasttxstamp) + 1))
    lasttxstamp_file.close()
    time.sleep(0.5)
