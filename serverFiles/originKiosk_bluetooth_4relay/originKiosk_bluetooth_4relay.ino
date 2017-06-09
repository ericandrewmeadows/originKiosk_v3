//#include <SoftwareSerial.h>
#include <NeoSWSerial.h>
#include <AltSoftSerial.h>
#include <OneWire.h> 
#include <DallasTemperature.h>

// Freezer
#define freezerRelay 7

// Temperature Sensor
#define freezerTempBus 12
OneWire oneWire(freezerTempBus); 
DallasTemperature sensors(&oneWire);
float highTemp = 27.5;  // 27
float lowTemp = 26.5; // 25
static float freezerTemp = 0;

// Lock - lockRelay HIGH -> LOCKED, LOW -> UNLOCKED
#define lockRelay 6

// btSerial
#define BT_rx 9 // -- Transmit
#define BT_tx 8 // -- Receive
AltSoftSerial btSerial;
String bt_rxString;
char inputChar;

// Credit Card
#define CC_rx 11 // Receive
#define CC_tx 10 // Transmit
static bool stringStart = false;
static int charsMissed = 0;
String ccInfo = "";
String ccInfo_old = "";

//SoftwareSerial ccSerial(CC_rx, CC_tx);
NeoSWSerial ccSerial(CC_rx, CC_tx);


void setup() 
{ 
    // btSerial
    pinMode(BT_rx, INPUT); 
    pinMode(BT_tx, OUTPUT);
    pinMode(lockRelay, OUTPUT);
    pinMode(freezerRelay, OUTPUT); 
    
    btSerial.begin(9600);
    Serial.print("Invoked iPad Serial");
    delay(500);

    // Lock
    digitalWrite(lockRelay, HIGH);

    // Temperature
    sensors.begin();

    // Credit Card
    pinMode(CC_rx, INPUT);
    pinMode(CC_tx, OUTPUT);
    ccSerial.begin(9600);
    Serial.begin(9600);                 // the terminal baud rate
    delay(500);

    ccSerial.attachInterrupt( getCC_info );
} 

static const unsigned long REFRESH_INTERVAL = 200; // ms   <-  200 millis intervals
//static const unsigned long FREEZER_INTERVAL = 30000; // ms <-   30 second intervals
unsigned long FREEZER_INTERVAL = 30000; // ms <-   30 second intervals
static const unsigned long KEEPALIVE_INTERVAL = 300000; // ms <- 5 minute intervals
unsigned long lastRefreshTime = 0;
unsigned long lastFreezerRefreshTime = 0;
unsigned long lastKeepAliveRefreshTime = 0;

void loop() 
{
    unsigned long currentMillis = millis();
//     Temperature Sensing <-- Works
    if ((unsigned long)(currentMillis - lastFreezerRefreshTime) >= FREEZER_INTERVAL)
    {
      sensors.requestTemperatures();
      freezerTemp = sensors.getTempFByIndex(0);
      regulateTemp();
      lastFreezerRefreshTime = millis();
    }
    
    if ((unsigned long)(currentMillis - lastKeepAliveRefreshTime) >= KEEPALIVE_INTERVAL)
    {
      keepAlive();
      lastKeepAliveRefreshTime = millis();
    }
    
//    // Credit Card Reader <-- Works
    if (stringStart == true) {// && ((ccInfo_old.length()) == (ccInfo.length()))) {
//      charsMissed += 1;
      if (millis() - lastRefreshTime >= REFRESH_INTERVAL)
      {
        stringStart = false;
        ccInfo.remove(ccInfo.length()-2);
        ccInfo += "</CCINFO>";
        Serial.println(ccInfo);
        btSerial.print(ccInfo);
        delay(200);
        ccInfo = "";
      }
    }
                                              // Bluetooth
    if(btSerial.available())  // If the btSerial sent any characters
    {
      // Send any characters the btSerial prints to the serial monitor
      inputChar = (char)btSerial.read();
      Serial.print(inputChar);
      if (inputChar != '\n') {
        bt_rxString += inputChar;
//        btSerial.end();
//        btSerial.begin(9600);
      }
      else {
        checkString();
        bt_rxString = "";
        btSerial.end();
        btSerial.begin(9600);
        Serial.end();
        Serial.begin(9600);
//        delay(100);
//        btSerial.begin(9600);
      }
    }
    if(Serial.available())  // If stuff was typed in the serial monitor
    {
      // Send any characters the Serial monitor prints to the btSerial
//      btSerial.print((char)Serial.read());
    }
}

void getCC_info( uint8_t c )
{
  if (stringStart == false) {
    lastRefreshTime = millis();
    ccInfo = "<CCINFO>";
  }
  stringStart = true;
  ccInfo += (char)c;
}

void regulateTemp()
{
  // Arthena
  String temperatureOutput = "<FREEZER>Temp: " + String(freezerTemp) + ", State: ";
  
  if (freezerTemp >= highTemp) {
    digitalWrite(freezerRelay, HIGH);
    temperatureOutput += "On";
  }
  else if (freezerTemp < lowTemp) {
    digitalWrite(freezerRelay, LOW);
    temperatureOutput += "Off";
  }
  else {
    temperatureOutput += "SS";
  }
  temperatureOutput += "</FREEZER>";
  
  btSerial.print(temperatureOutput);
  delay(200);
  Serial.println(temperatureOutput);
}

void checkString()
{
  String lockOutput = "<LOCK>State: ";
  if (bt_rxString == "UNLOCK") {
    digitalWrite(lockRelay, LOW);
    lockOutput += "Unlocked";
    lockOutput += "</LOCK>";
    btSerial.print(lockOutput);
    delay(200);
    Serial.println(lockOutput);
  }
  else if (bt_rxString == "LOCK") {
    digitalWrite(lockRelay, HIGH);
    lockOutput += "Locked";
    lockOutput += "</LOCK>";
    btSerial.print(lockOutput);
    delay(200);
    Serial.println(lockOutput);
  }
  else if (bt_rxString.length() > 16) {
    if (bt_rxString.substring(0,16) == "FreezerSettings:") {
      bt_rxString = bt_rxString.substring(16);
      Serial.println("=== <FREEZERSETTINGS> ===");
      
      // Freezer Time Interval
      int delimiter = bt_rxString.indexOf(",");
      FREEZER_INTERVAL = 1000*bt_rxString.substring(0,delimiter).toInt();
      Serial.println(FREEZER_INTERVAL);
      bt_rxString = bt_rxString.substring(delimiter+1);

      // Low Temp
      delimiter = bt_rxString.indexOf(",");
      lowTemp = bt_rxString.substring(0,delimiter).toFloat();
      Serial.println(lowTemp);
      bt_rxString = bt_rxString.substring(delimiter+1);

      // High Temp
      highTemp = bt_rxString.toFloat();
      Serial.println(highTemp);
      Serial.println("=== </FREEZERSETTINGS> ==");
    }
    //(bt_rxString.substring(0,16))
  }
  
}

void keepAlive()
{
  String keepAliveString = "<KEEPALIVE>true</KEEPALIVE>";
  btSerial.print(keepAliveString);
  delay(200);
  Serial.println(keepAliveString);
}

// Epona
//void checkString( uint8_t c )
//{
//  Serial.print( char(c) );
//}

