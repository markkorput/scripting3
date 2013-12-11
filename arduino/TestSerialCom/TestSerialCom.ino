
int ledPin = 13;
int triggerPin = 8;

char val;

void setup()
{
  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);
  pinMode(triggerPin, INPUT);
  // Need to set the pin to high, because the sensor puts in to low
  digitalWrite(triggerPin, HIGH);
  // startAnimation();
}

void loop()
{ 
  if(digitalRead(triggerPin) == LOW){
    startAnimation();
    delay(100);
  }

  if (Serial.available()) 
  { // If data is available to read,
     val = Serial.read(); // read it and store it in val
  }
  if (val == '1') 
  { // If 1 was received
     dropBall();
  } else {
     digitalWrite(ledPin, LOW); // otherwise turn it off
  }
  delay(10); // Wait 10 milliseconds for next reading
}

void startAnimation()
{
  Serial.write('1'); //("StartAnimation");
}

void dropBall()
{
  digitalWrite(ledPin, HIGH); // turn the LED on
  // Serial.println("DropBall");
}
