/* JEZDZCY JARZYNOWEJ - CAN SAT 2016/17
 * GROUND STATION RECEIVER 
 * CONNECTIONS:
 * A4 - barometer SCA
 * A5 - barometrer SCL
 * 2 - radio TX
 * 3 - radio RX
 * 10 - micrSD CS
 * 11 - microSD MOSI
 * 12 - microSD MISO
 * 13 - microSd SCLK
 */
#include <LPS331.h>
#include <SPI.h>
#include <SD.h>
#include <Wire.h>
#include <SoftwareSerial.h>

SoftwareSerial radioSerial(2, 3);

int startTime;
const int serialDelay = 1000;
const String autoSaveTime = "60";

class TheTime{
  public:
    int inHour;
    int inMinute;
    int inSecond;
    int inMilisecond;
    
    int hour;
    int minute;
    int second;
    unsigned long milisecond;
    
    void calculate(){
      while(milisecond >= 1000){
        second++;
        milisecond -= 1000;
      }
      while(second >= 60){
        minute++;
        second -= 60;
      }
      while(minute >= 60){
        hour++;
        second -= 60;
      }
    }

    void clearTimes(){
      hour = inHour;
      minute = inMinute;
      second = inSecond;
      milisecond = inMilisecond;
    }
  
    void calculateTime(){
      clearTimes();
      milisecond = inMilisecond + millis() - startTime;
      calculate();
    }
};

const int chipSelect = 10;
File usedFile;

LPS331 sensor;

TheTime theTime;

String sdError = "SDERROR";
String getTime = "GETTIME";
String sensorError = "SENSORERROR";
String getSaveTime = "GETSAVETIME";
String timeError = "TIMEERROR";

void tryGetTime(){
  String in = "0:0:0;0";
  Serial.print(getTime);
  while(Serial.available() == 0 && startTime < serialDelay){
    startTime = millis();
  }
  if(Serial.available() > 0){
    in = Serial.readString();
  }  
  startTime = millis();
  
  String inTemp = "";
  int inNum = 0;
  while(true){
    if(in[inNum] == ':'){
      inNum++;
      break;   
    }
    inTemp += in[inNum];
    inNum++;
    if(inNum > in.length()){
      Serial.print(timeError);
      return;
    }
  }
  theTime.inHour = inTemp.toInt();
  inTemp = "";
  
  while(true){
    if(in[inNum] == ':'){
      inNum++;
      break;   
    }
    inTemp += in[inNum];
    inNum++;
    if(inNum > in.length()){
      Serial.print(timeError);
      return;
    }
  }
  theTime.inMinute = inTemp.toInt();
  inTemp = "";
  
  while(true){
    if(in[inNum] == ';'){
      inNum++;
      break;   
    }
    inTemp += in[inNum];
    inNum++;
    if(inNum > in.length()){
      Serial.print(timeError);
      break;
    }
  }
  theTime.inSecond = inTemp.toInt();
  inTemp = "";
  
  while(true){
    if(inNum >= in.length()-1){
      inNum++;
      break;   
    }
    inTemp += in[inNum];
    inNum++;
  }
  theTime.inMilisecond = inTemp.toInt();

  theTime.hour = theTime.inHour;
  theTime.minute = theTime.inMinute;
  theTime.second = theTime.inSecond;
  theTime.milisecond = theTime.inMilisecond;
}

int fileNumberS = 0;
int fileNumberR = 0;

void saveData(String inData, byte type){
  String fileName = "";
  if(type == 0){
    fileName = "S";
    fileName += fileNumberS;
  }else{
    fileName = "R";
    fileName += fileNumberR;
  }
  fileName += ".txt";
  usedFile = SD.open(fileName, FILE_WRITE);
  if(usedFile){
    if(!usedFile.print(inData)){
      Serial.println(sdError);
    }
  }
  
  usedFile.close();
}

String showTime(){
  String out = "Time: ";
  out += theTime.hour;
  out += ":";
  out += theTime.minute;
  out += ":";
  out += theTime.second;
  out += ";";
  out += theTime.milisecond;
  return out;
}

class SensorData{
  public:
    float pressure;
    float altitude;
    float temperature;
};

SensorData sensorData;
int saveSensorTime;

String showSensor(){
  String out = "Pressure: ";
  out += sensorData.pressure;
  out += ", Altitude: ";
  out += sensorData.altitude;
  out += ", Temperature: ";
  out += sensorData.temperature;
  return out;
}

void getSensorData(){
  sensorData.pressure = sensor.readPressureMillibars();
  sensorData.altitude = sensor.pressureToAltitudeMeters(sensorData.pressure);
  sensorData.temperature = sensor.readTemperatureC();
}

void getSaveSensorTime(){
  Serial.print(getSaveTime);
  int waitForData = 0;
  String in = autoSaveTime;
  while(Serial.available() == 0 && waitForData < serialDelay){
    waitForData = millis() - startTime;
  }
  if(Serial.available() > 0){
    in = Serial.readString();
  }
  saveSensorTime = in.toInt();
}

void countFiles(){
  int number = 1;
  while(true){
    String fileName = "S/";
    fileName += number;
    fileName += ".txt";
    if(!SD.exists(fileName)){
      break;
    }
    number++;
  }
  fileNumberS = number;
  number = 1;
  while(true){
    String fileName = "R/";
    fileName += number;
    fileName += ".txt";
    if(!SD.exists(fileName)){
      break;
    }
    number++;
  }
  fileNumberR = number;
}

void receiveData(){
  if (radioSerial.available())
    Serial.write(radioSerial.read());
}

void setup(){
  
  Serial.begin(9600);
/*
  if (!SD.begin(10)){
    Serial.print(sdError);
    return;
  }
  countFiles();
*/
  radioSerial.begin(9600);
  
  tryGetTime();
  
  Wire.begin();
  if (!sensor.init()){
    Serial.println(sensorError);
  }
  sensor.enableDefault();

  getSaveSensorTime();
}

void loop() {
  theTime.calculateTime();
  Serial.println(showTime());
  
  getSensorData();
  Serial.println(showSensor());

  //saveData("Denis", 0);

  delay(1000);

  receiveData();
   
}
