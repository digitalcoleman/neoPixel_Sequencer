#include <Adafruit_NeoPixel.h>
#include <avr/pgmspace.h>

#define PIN 0
#define LED_QUANTITY 16

Adafruit_NeoPixel strip = Adafruit_NeoPixel(LED_QUANTITY, PIN, NEO_GRB + NEO_KHZ800);

//store the led values for fading
struct led{
  byte hue;
  byte sat;
  byte light;
};

//load the sequence into PROGMEM because otherwise it overloads RAM
const byte ledSeq [16][LED_QUANTITY][3] PROGMEM = {
//paste contents of the txt file here. !!important!! remove the final comma!
};


float fadefraction = .95; //adjust the fade out speed. typically .9-.99
int interval = 50; //the speed of the animation, lower is faster

//store colors for conversion from HSB
byte col[3] = {0,0,0};
//count loops
int counter = 0;
//current frame of the sequence
int frame = 0;

led myLeds[LED_QUANTITY];

void setup() {
  strip.begin();
  strip.show(); // Initialize all pixels to 'off'
}

void loop() {
//step thru the sequence
  if(frame < 16) {
    if(counter%interval==0) {
      for(int x = 0; x<LED_QUANTITY;x++) {
        byte light = pgm_read_byte(&(ledSeq[frame][x][2])); //check the lightness value
        if(light != 0x00) { //do not override with any black so that the fading can work
          setPixelFade(x, pgm_read_byte(&(ledSeq[frame][x][0])), pgm_read_byte(&(ledSeq[frame][x][1])), light);
        }
      }
      frame++;
    }   
  }else{
    frame=0;
  }
  //update the fading - you can increase the "5" for slower fading
  if(counter%5==0)updateLeds();
  strip.show();
  counter++;
  delay(1);
}


void updateLeds() {
  for(int i = 0; i < LED_QUANTITY; i++) {
    updateFade(i);
    HSV_to_RGB(myLeds[i].hue, myLeds[i].sat, myLeds[i].light);
    strip.setPixelColor(i, col[0], col[1], col[2]);
  } 
}

void setPixelFade(int m, byte hues, byte saturation, byte lightness) {
  myLeds[m].light = lightness;
  myLeds[m].hue = hues;
  myLeds[m].sat = saturation;
}

void updateFade(int g) {
    if(myLeds[g].light < 2) { //if the lightness is really low, set it to 0 to shut it all the way off
      myLeds[g].light = 0;
    }
    else {
      myLeds[g].light *= fadefraction;
    }
} 

//code to convert HSB to RGB
void HSV_to_RGB(float h, float s, float v)
{
  int i;
  byte r, g, b;
  float f,p,q,t;
  
  s /= 255;
  v /= 255;
  
  if(s == 0) {
    // Achromatic (grey)
    r = g = b = v*255;
    col[0] = r;
    col[1] = g;
    col[2] = b;
    return;
  }
 
  h /= 60; // sector 0 to 5
  i = h;
  f = h - i; // factorial part of h
  p = v * (1 - s);
  q = v * (1 - s * f);
  t = v * (1 - s * (1 - f));
  switch(i) {
    case 0:
      r = 255*v;
      g = 255*t;
      b = 255*p;
      break;
    case 1:
      r = 255*q;
      g = 255*v;
      b = 255*p;
      break;
    case 2:
      r = 255*p;
      g = 255*v;
      b = 255*t;
      break;
    case 3:
      r = 255*p;
      g = 255*q;
      b = 255*v;
      break;
    case 4:
      r = 255*t;
      g = 255*p;
      b = 255*v;
      break;
    default:
      r = 255*v;
      g = 255*p;
      b = 255*q;
    }
    col[0] = r;
    col[1] = g;
    col[2] = b;
    return;
}
