#define ledPin 13

#define EOL_DELIMITER "\n"

int v = 0;

void setup()
{
  Serial.print("INITIALIZING");
  Serial.print(EOL_DELIMITER);
  
  pinMode(ledPin, OUTPUT);
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }

  delay(1000);

  Serial.print("READY");
  Serial.print(EOL_DELIMITER);
}


void loop() {
  int sensorReading = analogRead(A0);
  Serial.print(sensorReading);
  Serial.print(EOL_DELIMITER);    // 
  
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
          //Serial.print("ON");
          break;
        case 'L':
          digitalWrite(ledPin,LOW);    //set LED OFF
          break;
    }
  }
  
  delay(50);
}

