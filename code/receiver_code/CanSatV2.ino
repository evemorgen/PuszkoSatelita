#include <LPS331.h>
#include <SPI.h>
#include <SD.h>
#include <Wire.h>
#include <LoRa.h>

#define FLOATNUM 30

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

void parseAndSend(String in){
  
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
  LoRa.setCodingRate4(5);
  LoRa.setSpreadingFactor(7);

}

void loop() {
  
  int packetSize = LoRa.parsePacket();
  
  if(packetSize){
    String receivedData = "";
    char packet [packetSize-2];
    long checksum=1;
    // read packet
    for (int i=0; i<packetSize-2; i++) {
      packet[i]=(char)LoRa.read();
      checksum*=(long long)packet[i];
      checksum%=1234577;
    }
    int checksum1=checksum%256;
    int checksum2=((checksum-checksum1)/256)%256;
    int receivedchecksum1=LoRa.read();
    int receivedchecksum2=LoRa.read();
    if(checksum1==receivedchecksum1&&checksum2==receivedchecksum2) {
      for (int i=0; i<FLOATNUM; i++)
      {
        receivedData += ((float *)packet)[i];
        receivedData += ",";
      }
      Serial.println(LoRa.packetRssi());
    }
    else
    {Serial.print("Transmission error, received malformed data! ");
    Serial.print(millis());
    Serial.print(" ");
    Serial.print(receivedchecksum1);
    Serial.print(" ");
    Serial.print(checksum1);
    Serial.print(" ");
    Serial.print(receivedchecksum2);
    Serial.print(" ");
    Serial.print(checksum2);
    for (int i=0; i<packetSize-2; i++) {
        Serial.print(packet[i]);
        }
    Serial.println("");
    }

    String dataSave = receivedData + "\nRSSI: ";
    dataSave += LoRa.packetRssi();
    
    saveData(dataSave, 1);

    parseAndSend(receivedData);
  }

  if(lastSaveSensor - millis() > saveSensorTime){
    lastSaveSensor = millis();
    saveAndSendSensor();
  }
  
}
