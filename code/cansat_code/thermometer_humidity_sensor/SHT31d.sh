#!/bin/bash
daemon -r /home/pi/PuszkoSatelita/code/cansat_code/thermometer_humidity_sensor/SHT31_temperature_reader.sh
daemon -r /home/pi/PuszkoSatelita/code/cansat_code/thermometer_humidity_sensor/SHT31_humidity_reader.sh
