#!/bin/bash
while true
do
readnumber=$(($(more ~/data/temperature/last_read_number.txt )+1))
echo $readnumber > ~/data/temperature/last_read_number.txt
python SHT31_temperature_reader.py >> ~/data/temperature/$readnumber .txt
echo $readnumber,$(date) >> ~/data/temperature/datatable.txt
readnumber=$(($(more ~/data/humidity/last_read_number.txt )+1))
echo $readnumber > ~/data/humidity/last_read_number.txt
python SHT31_humidity_reader.py >> ~/data/humidity/$readnumber .txt
echo $readnumber,$(date) >> ~/data/humidity/datatable.txt
sleep 1
done
