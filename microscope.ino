/*
* Group 2 - Light microscopy automation task using Arduino
* Arduino Uno R3
* Amanda, Guchan, Mahiro, Yujia
*/

int led = 9;        // led's port on arduino board
int camera = 3;     // camera's port on arduino board 
int window = 1000;  // exposure time
int period = 10000; // time between observations

void setup() 
{
    pinMode(led, OUTPUT);    // set led's port as an output
    pinMode(camera, OUTPUT); // set camera's port as an output
}

void snapshot()
{
  // enables image refresh
  digitalWrite(camera, HIGH);  
  digitalWrite(camera, LOW);  
}

void loop() 
{      
      analogWrite(led, 255);      //turn on led
      snapshot();
      delay(window);
      analogWrite(led, 0);        //turn off led
      delay(period-window);
}
