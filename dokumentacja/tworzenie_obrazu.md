Raspbian image preparation
=
1. The base system for our CanSat is a Raspbian Jessie image from 2017-01-11 with a kernel version of 4.4. This will be a step by step description of the steps we took to make it more memory efficient.

2. Our first step is deleting the Graphical Interface server X.org. Using the following commands:
	
		sudo apt-get remove x11-* --purge
		sudo apt-get autoremove --purge
In this way we clean all things related to the GUI and let the system do the cleanup.
3. After that we disable the HDMI port by adding the following line at the bottom of the /etc/rc.local file:

		echo "/usr/bin/tvservice -o" | sudo tee -a  "/etc/rc.local"
4. The next thing to do is turning off the LED on the board:

		echo none | sudo tee "/sys/class/leds/led0/trigger"
		echo 1 | sudo tee /sys/class/leds/led0/brightness
	
	This doesn't make it more memory efficient but saves a little bit of power.
	To make these changes permanent we append the following lines to /boot/config.txt:

		dtparam=act_led_trigger=none
		dtparam=act_led_activelow=on
