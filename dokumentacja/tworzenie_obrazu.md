Przygotowanie obrazu raspbiana
=
1. Za podstawe do naszego systemu będzie służyć Raspbian Jessie wersja z 17-01-11 z jądrem wersji 4.4. Będzie to opis kroków jakie podjęliśmy aby nasza puszka była bardziej wydajna.

2. Pierwszym krokiem jest usunięcie środowiska graficznego używając następującego polecenia:

		sudo apt-get remove x11-* --purge
		sudo apt-get autoremove --purge
W ten sposób czyścimy wszystkie rzeczy związane z GUI i pozwalamy systemowi pozbyć się niepotrzebnych paczek.

3. Następnie wyłączamy port HDMI dodając następującą linię do pliku /etc/rc.local:
		
		echo "/usr/bin/tvservice -o" | sudo tee -a  "/etc/rc.local"

4. Potem wyłączamy żarówki LED na płytce:

		echo none | sudo tee "/sys/class/leds/led0/trigger"
		echo 1 | sudo tee "/sys/class/leds/led0/brightness"
Dwa ostatnie kroki mają na celu zmniejszenie poboru prądu. Żeby zmiany związane z żarówkami były trwałe dodajemy dwie linie do pliku /boot/config.txt:
	

		echo "dtparam=act_led_trigger=none" | tee -a "/boot/config.txt"
		echo "dtparam=act_led_activelow=on" | tee -a "/boot/config.txt"

