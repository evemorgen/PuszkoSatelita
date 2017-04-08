from subprocess import check_output
#import numpy as np
def grab_gps_array():
	gps_line = check_output(['/home/pi/PuszkoSatelita/code/cansat_code/gps/grab_gps_line.sh'])
	gps_array = gps_line.split(',')
	return (gps_array)
def grab_datetime_array():
	datetime_line = check_output(['/home/pi/PuszkoSatelita/code/cansat_code/gps/grab_datetime_line.sh'])
	datetime_array = datetime_line.split(',')
	return (datetime_array)
def get_gps_data():
	gps_array = grab_gps_array()
	datetime_array = grab_datetime_array()
	# uncomment to see debug line with raw data array
	#print(gps_array)
	lat_deg=float(gps_array[2])-float(gps_array[2])%100
	lat_deg=lat_deg/100
	lat_min_weird=float(gps_array[2])%100
	lat_sec=lat_min_weird%1
	lat_min=lat_min_weird-lat_sec
	lat_sec=lat_sec*60
	if gps_array[3]=="S":
		lat_deg=-lat_deg
	long_deg=float(gps_array[4])-float(gps_array[4])%100
	long_deg=long_deg/100
	long_min_weird=float(gps_array[4])%100
	long_sec=long_min_weird%1
	long_min=long_min_weird-long_sec
	long_sec=long_sec*60
	if gps_array[5]=="W":
		long_deg=-long_deg
	elev=float(gps_array[9])
	accuracy=float(gps_array[6])

	datetime=datetime_array[9]+datetime_array[1]
	#uncomment to see extracted location values
	"""
	print(lat_deg)
	print(lat_min)
	print(lat_sec)
	print(long_deg)
	print(long_min)
	print(long_sec)
	print(elev)
	"""
	return([lat_deg,lat_min,lat_sec,long_deg,long_min,long_sec,elev,accuracy
			,datetime
			])
def read_gps_data():
	array=get_gps_data()
	return(",".join(map(str, array)))
	
Contact GitHub API Training Shop Blog About
