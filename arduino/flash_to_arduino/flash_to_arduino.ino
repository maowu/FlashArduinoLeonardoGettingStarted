#define ledPin 13

#define EOL_DELIMITER "\n"

int v = 0;

void setup()
{  
  pinMode(ledPin, OUTPUT);
  Serial.begin(9600);
  
  while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }
}


void loop() {
  int sensorReading = analogRead(A0);
  Serial.print(sensorReading);
  Serial.print(EOL_DELIMITER);    //add NEWLINE wit the end of sensor value
  
  if ( Serial.available()) {
    char ch = Serial.read();      //reicieve charater from computer
    switch(ch) {
        case '0'...'9':
          v = v * 10 + ch - '0';
          break;
        case 'A':
          analogWrite(ledPin, v);
          v = 0;
          break;
        case 'H':
          digitalWrite(ledPin,HIGH);   //set LED ON
          break;
        case 'L':
          digitalWrite(ledPin,LOW);    //set LED OFF
          break;
    }
  }
  
  delay(1);
}

