#include <SoftwareSerial.h>
 
SoftwareSerial mySerial(2, 3);

unsigned long startTime = 0;

void setup(){
   mySerial.begin(9600);
   pinMode(4, INPUT);
   while(digitalRead(4) == LOW);
   startTime = millis();
}
unsigned long milisecond;
int second;
int minute;
int hour;

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
  out += ":";
  out += milisecond;
  while(out.length() < 10){
    out += "x";
  }
  return out;
}

void loop(){
    calculateTime();
    mySerial.print(showTime());
    if(minute >= 2){
      startTime = millis();
    }
    delay(5000);
}
