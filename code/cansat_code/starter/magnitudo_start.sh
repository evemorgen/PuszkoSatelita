#!/bin/sh

daemon -r ~/PuszkoSatelita/code/cansat_code/gps/gps_reader.py
daemon -r ~/PuszkoSatelita/code/cansat_code/altimu/altimu_reader.py
daemon -r ~/PuszkoSatelita/code/cansat_code/thermometer_humidity_sensor/SHT31_humidity_reader.py
daemon -r ~/PuszkoSatelita/code/cansat_code/thermometer_humidity_sensor/SHT31_temperature_reader.py
#having next line commented may decrease stability
sleep 2
daemon -r ~/PuszkoSatelita/code/cansat_code/aggregator/aggregator.py
daemon -r ~/PuszkoSatelita/code/cansat_code/radio/radio_transmitter.py

echo Magnitudo started!

