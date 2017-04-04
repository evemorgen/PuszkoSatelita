#!/usr/bin/python

from datetime import datetime
import time
import struct
import array


def compress(string):
    string=string.split(",")
    print string
    floatlist=[float(i) for i in string]
    x = struct.pack('%sf' % len(floatlist), *floatlist)
    print len(x)
    return x



while True:
    lasttxstamp_file= open('/home/pi/data/radio/last_tx_stamp.txt', 'r')
    lasttxstamp=lasttxstamp_file.read()
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
    lastvoltage0 = open(
        '/home/pi/data/voltage0/last_read_number.txt', 'r').readline()
    voltage0 = open(
        '/home/pi/data/voltage0/' + str(lastvoltage0)).readline()
    lastvoltage1 = open(
        '/home/pi/data/voltage1/last_read_number.txt', 'r').readline()
    voltage1 = open(
        '/home/pi/data/voltage1/' + str(lastvoltage1)).readline()
    lastwind = open(
        '/home/pi/data/wind/last_read_number.txt', 'r').readline()
    wind = open(
        '/home/pi/data/wind/' + str(lastwind)).readline()
    timedate=str(datetime.now().strftime('%Y,%m,%d,%H,%M,%S'))
    date=timedate
    date = date.split(",")
    date=float(date[2])*86400+float(date[3])*3600+float(date[4])*60+float(date[5])
    date=str(date)
    string=txstamp+','+date+","+temperature+','+humidity+','+gps+','+altimu+','+voltage0+','+voltage1+','+wind
    print (string)
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
