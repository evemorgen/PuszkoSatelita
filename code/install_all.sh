sudo apt-get install git
mkdir /home/pi/data
mkdir /home/pi/data/altimu /home/pi/data/gps /home/pi/data/radio
mkdir /home/pi/data/camera /home/pi/data/temperature /home/pi/data/humidity /home/pi/data/wind /home/pi/data/voltage0 /home/pi/data/voltage1
sudo apt-get install i2c-tools
sudo apt-get install python-smbus
sudo apt-get install python-dev 
sudo apt-get install build-essential python-pip python-dev python-smbus git
# don't forget to enable i2c in raspi-config

git clone https://github.com/adafruit/Adafruit_Python_GPIO.git
cd Adafruit_Python_GPIO
sudo python setup.py install
cd ~
