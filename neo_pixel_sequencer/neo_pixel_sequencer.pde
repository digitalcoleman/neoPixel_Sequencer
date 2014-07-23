import controlP5.*;

ControlP5 cp5;

ArrayList <LED> leds;
PFont myFontType;
ColorPicker colorPicker;
int colorPickerTop = 10, colorPickerLeft = 10;
float MAX_BRIGHTNESS = 1.0;
float MAX_SATURATION = 1.0;
float MAX_HUE = TWO_PI;
float MAX_ALPHA = 1;
PGraphics mainWin;
int selected = -1;
int currentFrame = 0;
int SEQUENCE_LENGTH = 16;
int NUMBER_OF_LED = 16;
float slice;

void setup() {
  size(920, 1000);
  //setup color picker
  colorMode(HSB, MAX_HUE, MAX_SATURATION, MAX_BRIGHTNESS, MAX_ALPHA);
  //colorMode(HSB);
  colorPicker = new ColorPicker(colorPickerLeft, colorPickerTop);
  mainWin = createGraphics(300, 280);
  myFontType = createFont("arial", 16);
  textFont(myFontType);
  slice = PI/NUMBER_OF_LED;
  //setup neo-pixel ring gui
  rectMode(CENTER);
  leds = new ArrayList<LED>();
  for (int i = 0; i<NUMBER_OF_LED; i++) {
    float rot = 360.0/NUMBER_OF_LED*i*PI/180.0;
    float spacing = NUMBER_OF_LED*(8-NUMBER_OF_LED/15);
    leds.add(new LED(rot, new PVector(600, 260), spacing));
  }
  //setup controlP5 GUI
  cp5 = new ControlP5(this);
  new ColorMatrix(cp5, "LED_sequence")
    .setPosition(50, 580)
      .setSize(800, 420)
        .setGrid(SEQUENCE_LENGTH, NUMBER_OF_LED)
          .setGap(2, 2)
            .setInterval(200)
              .setMode(ControlP5.MULTIPLES)
                .setColorBackground(color(1, 0, .1))
                  .setBackground(color(1, 0, .3))
                    ;

  cp5.getController("LED_sequence").getCaptionLabel().alignX(CENTER);

  cp5.addSlider("Number_of_LEDs")
    .setPosition(10, 320)
      .setWidth(260)
        .setHeight(15)
          .setRange(3, 60)
            .setValue(16)
              .setSliderMode(Slider.FLEXIBLE)
                .setDecimalPrecision(1)
                  ;

  cp5.addToggle("play_pause")
    .setPosition(50, 520)
      .setSize(50, 20)
        .setValue(false)
          .setMode(ControlP5.SWITCH)
            ;

  cp5.addSlider("timeline")
    .setPosition(45, 560)
      .setWidth(815)
        .setHeight(15)
          .setRange(0, SEQUENCE_LENGTH)
            .setValue(0)
              .setNumberOfTickMarks(SEQUENCE_LENGTH+1)
                .setSliderMode(Slider.FLEXIBLE)
                  .setDecimalPrecision(0)
                    ;

  cp5.addSlider("speed")
    .setPosition(145, 520)
      .setWidth(550)
        .setHeight(15)
          .setRange(625, 75)
            .setValue(200)
              .setNumberOfTickMarks(23)
                .setSliderMode(Slider.FIX)
                  .setDecimalPrecision(1)
                    ;

  cp5.addBang("bang")
    .setPosition(790, 520)
      .setSize(20, 20)
        .setTriggerEvent(Bang.RELEASE)
          .setLabel("Clear Sequence")
            ;

  cp5.addBang("clean")
    .setPosition(200, 275)
      .setSize(20, 20)
        .setTriggerEvent(Bang.RELEASE)
          .setLabel("Clear Cell")
            ;

  cp5.addBang("saveSeq")
    .setPosition(790, 480)
      .setSize(20, 20)
        .setTriggerEvent(Bang.RELEASE)
          .setLabel("save sequence")
            ;
}

void draw() {
  background(.5, 0, .2);
  //deal with color picker
  colorPicker.display();
  colorPicker.update();
  //check to see if someone has clicked on an arc, and also display them all
  for (int i = 0; i<NUMBER_OF_LED; i++) {
    LED myLed = leds.get(i);
    if (myLed.update()) {
      selected = i;
    }
    myLed.display();
    if (i == selected) {
      myLed.select = true;
    } else {
      myLed.select = false;
    }
  }
  //set color of arc and cell in sequencer
  if (selected != -1) {
    LED myLed = leds.get(selected);
    myLed.ledColor = colorPicker.activeColor;
    cp5.get(ColorMatrix.class, "LED_sequence").setCellColor(currentFrame, selected, colorPicker.activeColor);
    cp5.get(ColorMatrix.class, "LED_sequence").set(currentFrame, selected, true);
  }
  stroke(color(0,0,1.0));
  float offset = NUMBER_OF_LED*(8-NUMBER_OF_LED/15.0);
  line(620+offset, 250, 640+offset, 250);
  line(630+offset, 250, 630+offset, 270);
  line(630+offset, 270, 625+offset, 260);
  line(630+offset, 270, 635+offset, 260);
  fill(color(0,0,1.0));
  text("LED #1", 644+offset, 255);
}

//ControlP5 listeners

void LED_sequence(int theX, int theY) {
  LED myLed = leds.get(theY);
  myLed.ledColor = cp5.get(ColorMatrix.class, "LED_sequence").getCellColor(theX, theY);
}

void play_pause(boolean play_pause) {
  if (play_pause) {
    cp5.get(ColorMatrix.class, "LED_sequence").play();
  } else {
    cp5.get(ColorMatrix.class, "LED_sequence").pause();
  }
}

void timeline(int frame) {
  selected = -1;
  currentFrame = frame;
  cp5.get(ColorMatrix.class, "LED_sequence").trigger(frame);
  cp5.get(ColorMatrix.class, "LED_sequence").updatecnt(frame);
}

void speed(int frame) {
  cp5.get(ColorMatrix.class, "LED_sequence").setInterval(frame);
}

void bang() {
  selected = -1;
  cp5.get(ColorMatrix.class, "LED_sequence").clear();
}

void clean() {
  if (selected != -1) {
    LED myLed = leds.get(selected);
    myLed.ledColor = 0;
    cp5.get(ColorMatrix.class, "LED_sequence").setCellColor(currentFrame, selected, 0);
    selected = -1;
  }
}

//format and save the txt file
void saveSeq() {
  String[] frames = new String[SEQUENCE_LENGTH];
  for (int x = 0; x<SEQUENCE_LENGTH; x++) {
    String frame = "{";
    for (int y = 0; y<NUMBER_OF_LED; y++) {
      int ledColor = cp5.get(ColorMatrix.class, "LED_sequence").getCellColor(x, y);
      String tempHue = hex(int(hue(ledColor)*(255.0/TWO_PI)), 2);
      String tempSat = hex(int(saturation(ledColor)*255.0), 2);
      String tempBright = hex(int(brightness(ledColor)*255.0), 2);
      frame += "{0x"+tempHue+ ", 0x"+tempSat+ ", 0x"+tempBright+ "},";
    }
    frame = frame.substring( 0, frame.length()-1 );
    frames[x] = frame + "},";
  }
  frames[SEQUENCE_LENGTH-1] = frames[SEQUENCE_LENGTH-1].substring( 0, frames[SEQUENCE_LENGTH-1].length()-1 );
  saveStrings("ledSequence.txt", frames);
}

void Number_of_LEDs(int newled) {
  if (newled > 2 && NUMBER_OF_LED!=newled) {
    float spacing = newled*(8-newled/15.0);
    if(NUMBER_OF_LED < newled) {
      for (int i = NUMBER_OF_LED; i<newled; i++) {
        float rot = 360.0/newled*i*PI/180.0;
        leds.add(new LED(rot, new PVector(600, 260), spacing));
      }
      for (int i = 0; i<newled; i++) {
        LED myLed = leds.get(i);
        float rot = 360.0/newled*i*PI/180.0;
        myLed.space = spacing;
        myLed.rotation = rot;
      }

    }else{
      for (int i = 0; i<NUMBER_OF_LED; i++) {
        float rot = 360.0/newled*i*PI/180.0;
        LED myLed = leds.get(i);
        myLed.space = spacing;
        myLed.rotation = rot;
      }
      for (int i = NUMBER_OF_LED-1; i>newled; i--) {
        leds.remove(i);
      }
    }
    NUMBER_OF_LED = newled;
    slice = PI/NUMBER_OF_LED;
    cp5.get(ColorMatrix.class, "LED_sequence").setGrid(SEQUENCE_LENGTH, NUMBER_OF_LED);
  }
}

