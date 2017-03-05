#include <SPI.h>
#include <LoRa.h>


#define FLOATNUM 30

void setup() {
  Serial.begin(115200);
  while (!Serial);

  Serial.println("JJCanSat Receiver");

  if (!LoRa.begin(433800000)) {
    Serial.println("Starting LoRa failed!");
    while (1);
  }
  LoRa.setCodingRate4(5);
  LoRa.setSpreadingFactor(7);
}

void loop() {
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
    int checksum1=checksum%256;
    int checksum2=((checksum-checksum1)/256)%256;
    int receivedchecksum1=LoRa.read();
    int receivedchecksum2=LoRa.read();
    if(checksum1==receivedchecksum1&&checksum2==receivedchecksum2) {
      for (int i=0; i<FLOATNUM; i++)
      {
        Serial.print(((float *)packet)[i]);
        Serial.print(",");
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


  }
}