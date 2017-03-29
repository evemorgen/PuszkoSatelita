#include <SPI.h>
#include <LoRa.h>
#include <SD.h>

#define FLOATNUM 30

long fileNumberS = 0;
long fileNumberR = 0;
int folderNumber = 1;
File usedFile;

void saveData(String inData, byte type){
  String fileName = "CANSAT"+(String)folderNumber;
  if(type == 0){
    fileName += "/S/";
    fileName += fileNumberS;
    fileNumberS++;
  }else{
    fileName += "/R/";
    fileName += fileNumberR;
    fileNumberR++;
  }
  fileName += ".txt";
  usedFile = SD.open(fileName, FILE_WRITE);
  if(usedFile){
    if(!usedFile.print(inData)){
      Serial.println();
      Serial.println("ERROOOR");
    }
  }
  
  usedFile.close();
}

void countFiles(){
  //szukamy folderu
  while(true){
    String fileName = "CanSat";
    fileName += (String)folderNumber;
    fileName += "/README.txt";
    Serial.print(fileName);
    if(!SD.exists(fileName)){
      break;
    }
    folderNumber++;
  }
  String mainFolder = "CanSat"+(String)folderNumber;
  String folders[] = {mainFolder, mainFolder+"/R", mainFolder+"/S"};
  for(int i = 0; i <= 2; i++){
    SD.mkdir(folders[i]);
  }
  usedFile = SD.open(mainFolder+"/README.txt", FILE_WRITE);
  String readme = "JJ CanSat Team";
  usedFile.print(readme);
  usedFile.close();
  
}

void setup() {
  Serial.begin(115200);
  while (!Serial);

  Serial.println("JJCanSat Receiver");
LoRa.setPins(8,4,3);
  if (!LoRa.begin(433800000)) {
    Serial.println("Starting LoRa failed!");
    while (1);
  }
  LoRa.setCodingRate4(5);
  LoRa.setSpreadingFactor(7);
  
  if (!SD.begin(9)){
    Serial.print("SD error");
  }
  countFiles();
  Serial.println("JJCanSat Receiver");
  
}
unsigned long lastSenosr = 0;
void getSenosr(){
  String sensorData = "{\"MESSAGE TYPE\":\"SENSOR_DATA\",\"pressure\":";
  sensorData += 3;//(String) sensor.readPressureMillibars();
  sensorData += ",\"temperature\":";
  sensorData += 2;//sensor.readTemperatureC();
  sensorData += ",\"altitude\":";
  sensorData += 1;//sensor.pressureToAltitudeMeters(sensor.readPressureMillibars());
  sensorData += "}";
  Serial.println("Denis");
  Serial.println(sensorData);
  saveData(sensorData, 0);
}
void loop() {
  if(millis()-lastSensor > 5000){
    getSensor();
    lastSensor = millis();
  }
  // try to parse packet
  int packetSize = LoRa.parsePacket();
  if (packetSize) {
    char packet [packetSize-2];
    long checksum=1;
    // read packet
    for (int i=0; i<packetSize-2; i++) {
      packet[i]=(char)LoRa.read();
      checksum*=(long long)packet[i];
      checksum%=1234577;
    }
    //save on the SD
    String receivedData = "";
    for (int i=0; i<FLOATNUM; i++){
      receivedData += ((float *)packet)[i];
      receivedData += ",";
    }
    saveData(receivedData, 1);
    int checksum1=checksum%256;
    int checksum2=((checksum-checksum1)/256)%256;
    int receivedchecksum1=LoRa.read();
    int receivedchecksum2=LoRa.read();
    if(checksum1==receivedchecksum1&&checksum2==receivedchecksum2) {
      Serial.print("{\"MESSAGE TYPE\":\"STANDARD_DATA\"");
      for (int i=0; i<FLOATNUM; i++)
      {
        Serial.print(",\"key");
        Serial.print(i);
        Serial.print("\":");
        Serial.print(((float *)packet)[i]);
      }
      Serial.print(",\"RSSI\":");
      Serial.print(LoRa.packetRssi());
      Serial.print("}");
      Serial.println();
    }
  }

}
