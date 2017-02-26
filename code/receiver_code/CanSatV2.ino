#include <LPS331.h>
#include <SPI.h>
#include <SD.h>
#include <Wire.h>
#include <LoRa.h>

int selectSD = 10;
int slecetSensor = 9;

File usedFile;
LPS331 sensor;

String sdError = "SDERROR";
String sensorError = "SENSORERROR";
String radioError = "RADIOERROR";

char keys[7];

int fileNumberS = 0;
int fileNumberR = 0;

unsigned long lastSaveSensor = 0;

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

void saveSensor(){
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

  //JSON PARSER - ALBO NIE
}

int charToInt(char in){
  switch(in){
    case 0: return 0;
    case 1: return 1;
    case 2: return 2;
    case 3: return 3;
    case 4: return 4;
    case 5: return 5;
    case 6: return 6;
    case 7: return 7;
    case 8: return 8;
    case 9: return 9;
    default: return 0;
  }
}

float stringToFloat(String in){
  float out;
  int w = 1;
  
  for(int i = 0; i < in.length(); i++){
    if(in[i] == '.'){
      break;
    }
    if(in[i] != '0' && in[i] != '1' && in[i] != '2' && in[i] != '3' && in[i] != '4' && in[i] != '5' && in[i] != '6' && in[i] != '7' && in[i] != '8' && in[i] != '9'){
      return 0;
    }
    w++;
  }

  for(int i = w+1; i < in.length(); i++){
    if(in[i] != '0' && in[i] != '1' && in[i] != '2' && in[i] != '3' && in[i] != '4' && in[i] != '5' && in[i] != '6' && in[i] != '7' && in[i] != '8' && in[i] != '9'){
      return 0;
    }
  }

  for(int i = 0; i < in.length(); i++){
    if(in[i] != '.'){
        out += (float)charToInt(in[i])*pow(10, w-1);
    }
    w--;
  }

  return out;
}

float findValue(char key, String data){
    String sfloat = "";
    for(int i = 0; i < data.length(); i++){
      if(data[i] == key){
        for(int k = i; k < data.length(); k++){
          if(data[k] == ','){
            return stringToFloat(sfloat);
          }
          sfloat += data[k];
        }
        return 0;
      }
    }
    return 0;
    
}

void parseAndSend(String data){
  String out = "{";
  for(int i = 0; i < keys.size(); i++){
    if(i != 0){
      out += ",";
    }
    out += "\"";
    out += keys[i];
    out += "\":";
    out += findValue(keys[i], data);
  }
  out += "}";
  Serial.print(out);
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

    receivedData += "RSSI";
    receivedData += LoRa.packetRssi();
    
    saveData(receivedData, 1);

    parseAndSend(receivedData);
  }
  
  saveSensor();
}
