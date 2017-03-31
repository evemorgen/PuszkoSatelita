#include <SoftwareSerial.h>
 
SoftwareSerial mySerial(2, 3);

unsigned long startTime = 0;


void setup(){
   Serial.begin(9600);
   mySerial.begin(9600);
   pinMode(4, INPUT);
   while(digitalRead(4) == LOW);
   startTime = millis();
}
int milisecond = 0;
int second = 0;
int minute = 0;
int hour = 0;
void denis(){
  if (mySerial.available() > 0){
    Serial.print(mySerial.readString());
    Serial.println("/");
    Serial.println(showTime());
  }
}
void calculateTime(){
    hour = 0;
    minute = 0;
    second = 0;
      milisecond = millis() - startTime;
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
String showTime(){
  String out = "";
  out += minute;
  out += ":";
  out += second;
  out += ";";
  out += milisecond;
  return out;
}

void loop(){
    calculateTime();
    denis();
}
