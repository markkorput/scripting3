// the pin number which gets signals from the sensor
// indicating the ball is falling
int triggerPin = 8;

// the pin number through which we send signals to
// the mechanism that blocks the falling ball
int blockerPin = 13;

void setup()
{
  // setup serial connection through which the arduino
  // communicates with the computer
  Serial.begin(9600);

  // we'll be receiving from the triggerPin and
  // sending through the blockerPin
  pinMode(triggerPin, INPUT);
  pinMode(blockerPin, OUTPUT);

  // Need to set the pin to high, so we notice when the sensor puts it to low
  digitalWrite(triggerPin, HIGH);
}

void loop()
{ 
  char val;

  // if the sensor is triggered by the ball...
  if(digitalRead(triggerPin) == LOW){
    // perfrom start animation routine
    startAnimation();
    // avoid performing multiple start animation routines in a row
    // delaying for a while (after which the signal on the triggerPin should be HIGH again)
    delay(100);
  }

  // If a the '1' character was received through the serial connection, drop the ball.
  // Otherwise (by default) block the ball.
  if (Serial.available() && Serial.read() == '1') { 
    dropBall();
  } else {
    blockBall();
  }

  delay(10); // Wait 10 milliseconds for next reading
}

void startAnimation()
{
  // this will notify the computer that the ball is dropping
  Serial.write('1'); //("StartAnimation");
}

void dropBall()
{
  // this will cause the blocking mechanism to UNblock
  digitalWrite(blockerPin, HIGH);
}

void blockBall(){
  // this will cause the blocking mechanism to block
  digitalWrite(blockerPin, LOW);
}
