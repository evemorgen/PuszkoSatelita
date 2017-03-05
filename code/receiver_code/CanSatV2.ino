#include <LPS331.h>
#include <SPI.h>
#include <SD.h>
#include <Wire.h>
#include <LoRa.h>

int selectSD = 10;
int selcetSensor = 9;

File usedFile;
LPS331 sensor;

String sdError = "{ \"Message type\":\"ERROR\", \"ERROR_TYPE\":\"SDCARD_ERROR\"}";
String sensorError = "{ \"Message type\":\"ERROR\", \"ERROR_TYPE\":\"SENSOR_ERROR\"}";
String radioError = "{ \"Message type\":\"ERROR\", \"ERROR_TYPE\":\"RADIO_ERROR\"}";

int fileNumberS = 0;
int fileNumberR = 0;

int saveSensorTime = 10000;
unsigned long lastSaveSensor = millis();

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

void saveData(String inData, byte type){
  String fileName = "";
  if(type == 0){
    fileName = "S/";
    fileName += fileNumberS;
  }else{
    fileName = "R/";
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

void saveAndSendSensor(){
  float pressure = sensor.readPressureMillibars();
  float altitude = sensor.pressureToAltitudeMeters(pressure);
  float temperature = sensor.readTemperatureC();
  
  String data = "P=";
  data += pressure;
  data += ";A=";
  data += altitude;
  data += ";T=";
  data += temperature;
  data += ";";

  saveData(data, 0);
  
}

void setup() {
  
  Serial.begin(9600);
  if (!SD.begin(selectSD)){
    Serial.print(sdError);
  }
  
  countFiles();

  Wire.begin();
  if (!sensor.init()){
    Serial.println(sensorError);
  }
  sensor.enableDefault();

  if (!LoRa.begin(433800000)) {
    Serial.println(radioError);
    return;
  }

}

void loop() {
  
  if(LoRa.parsePacket()){

    String receivedData = "";
     
    while (LoRa.available()) {
      receivedData += (char)LoRa.read();
    }

    String dataSave = receivedData + "\nRSSI: ";
    dataSave += LoRa.packetRssi();
    
    saveData(dataSve, 1);

    parseAndSend(receivedData);
  }

  if(lastSaveSensor - millis() > saveSensorTime){
    lastSaveSensor = millis();
    saveAndSendSensor();
  }
  
}
