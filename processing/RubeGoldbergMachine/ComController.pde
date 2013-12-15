import processing.serial.*;


class ComController
{
  //vars
  RubeGoldbergMachine main;
  Serial serialPort;
  String msg;
  String lastMsg = "/n";
  char incomingByte;
  char lastByte = 'z';
  
  
  //constructor
  ComController(RubeGoldbergMachine main)
  {
    this.main = main;
    int i, portIndex = 5;
    String portName = Serial.list()[portIndex];

    // print all serial ports for debugging
    main.println("Available serial ports: ");
    for(i = 0; i<Serial.list().length; i++){
      if(i == portIndex){
        // postfix the used serial with an arrow
        main.println(Serial.list()[i] + " <-");
      }else{
        main.println(Serial.list()[i]);
      }
    }

    // try to establish a connection, if it fails set serialPort to null and continue
    try{
      serialPort = new Serial(main, portName, 9600);
    } catch(Exception E){
      main.println("Couldn't establish serial connection");
      serialPort = null;
    }    
  }

  //functions
  void read()
  {
    // if we don't have an active connection; quit
    if(serialPort == null){
      // main.println("Serial port not initialized, cannot read");
      return;
    }

    if ( this.serialPort.available() > 0) 
    {  
      //this.msg = this.serialPort.readString(); //Until('\n');
      this.incomingByte = this.serialPort.readChar(); //Until('\n');
    } 
    
    if (this.incomingByte != this.lastByte)
    {
      main.onByteReceived(this.incomingByte); //Run the event on main sketch
      this.lastByte = this.incomingByte;
    }
  }
  
  void sendMessage(char msg)
  {
    // if we don't have an active connection; quit
    if(serialPort == null){
      // main.println("Serial port not initialized, cannot write \""+msg+"\"");
      return;
    }

    serialPort.write(msg);
  }
}

