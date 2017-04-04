#!/usr/bin/env bash
#!/bin/bash
for d in /home/pi/data/*
do
rm $d/1*
rm $d/2*
rm $d/3*
rm $d/4*
rm $d/5*
rm $d/6*
rm $d/7*
rm $d/8*
rm $d/9*
rm $d/0*
rm $d/last_read_number.txt
echo -n "0" > $d/last_read_number.txt
rm $d/datetable.txt
echo -n "0" > $d/0
done
echo -n "0,0,0,0,0,0,0,0,0,0,0" > /home/pi/data/altimu/0
echo -n "0,0,0,0,0,0,0,0,0" > /home/pi/data/gps/0




