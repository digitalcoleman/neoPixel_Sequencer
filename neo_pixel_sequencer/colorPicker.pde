
class ColorPicker {

  int 
  ColorPickerX, //color picker horizontal position
  ColorPickerY, //color picker vertical position
  LineY; //hue line vertical position
  float
  CrossX, //saturation+brightness cross horizontal position
  CrossY, //saturation+brightness cross horizontal position
  ColorSelectorX = 100, //color selector button horizontal position <------------------------------------------- CHANGE
  ColorSelectorY = 100; //color selector button vertical position   <------------------------------------------- CHANGE

  boolean 
  isDraggingCross = false, //check if mouse is dragging the cross
  isDraggingLine = false, //check if mouse is dragging the line
  ShowColorPicker = true; //toggle color picker visibility (even = not visible, odd = visible) 

  color 
  activeColor = color(PI, 0.5, 0.5), //contain the selected color  
  interfaceColor = color(2*PI, 1.0, 1.0); //change as you want               <------------------------------------------- CHANGE

  ColorPicker(int pickx, int picky) {
    ColorPickerX = pickx;
    ColorPickerY = picky;
    LineY = ColorPickerY + int(hue(activeColor)); //set initial Line position
    CrossX = ColorPickerX + saturation(activeColor)*255; //set initial Line position
    CrossY = ColorPickerY + brightness(activeColor)*255; //set initial Line position
  }

 void update() {
    checkMouse();
    activeColor = color( (LineY - ColorPickerY)/40.58 , (CrossX - ColorPickerX)/255.0 , (255 - ( CrossY - ColorPickerY ))/255.0 ); //set current active color
  }

 void display() {
   drawColorSelector(); 
   drawColorPicker();
    drawLine();
    drawCross();
    drawActiveColor();
    drawValues();
    //drawOK();
  }

void drawColorSelector() 

{
  
  stroke( interfaceColor );
  strokeWeight( 1 );
  fill( 0 );
  rect( ColorSelectorX , ColorSelectorY , 20 , 20 ); //draw color selector border at its x y position
  stroke( 0 );
  fill( activeColor );
  rect( ColorSelectorX + 1 , ColorSelectorY + 1 , 18 , 18 ); //draw the color selector fill 1px inside the border
  
}

 void drawOK() 

  {

    if ( mouseX > ColorPickerX + 285 && mouseX < ColorPickerX + 305 && mouseY > ColorPickerY + 240 && mouseY < ColorPickerY + 260 ) //check if the cross is on the darker color
      fill(0); //optimize visibility on ligher colors
    else
      fill(100); //optimize visibility on darker colors

    text( "OK", ColorPickerX + 285, ColorPickerY + 250 );
  }


 void drawValues() 

  {

    fill( 2*PI );
    //fill( 0 );
    textSize( 10 );

    text( "H: " + int( ( LineY - ColorPickerY ) * 1.417647 ) + "°", ColorPickerX + 285, ColorPickerY +15);
    text( "S: " + int( ( CrossX - ColorPickerX ) * 0.39215 + 0.5 ) + "%", ColorPickerX + 286, ColorPickerY + 30 );
    text( "B: " + int( 100 - ( ( CrossY - ColorPickerY ) * 0.39215 ) ) + "%", ColorPickerX + 285, ColorPickerY + 45 );

    text( "R: " + int( red( activeColor )*40.85 ), ColorPickerX + 285, ColorPickerY + 70 );
    text( "G: " + int( green( activeColor )*255 ), ColorPickerX + 285, ColorPickerY + 85 );
    text( "B: " + int( blue( activeColor )*255 ), ColorPickerX + 285, ColorPickerY + 100 );

    text( hex( activeColor, 6 ), ColorPickerX + 285, ColorPickerY + 125 );
  }

 void drawCross() 

  {

    if ( brightness( activeColor ) < 0.35 )
      stroke( 2*PI );
    else
      stroke( 0 );

    line( CrossX - 5, CrossY, CrossX + 5, CrossY );
    line( CrossX, CrossY - 5, CrossX, CrossY + 5 );
  }


 void drawLine() 

  {

    stroke(0);
    line( ColorPickerX + 259, LineY, ColorPickerX + 276, LineY );
  }


 void drawColorPicker() 

  {

    stroke( interfaceColor );
    for ( int j = 0; j < 255; j++ ) //draw a row of pixel with the same brightness but progressive saturation

    {

      for ( int i = 0; i < 255; i++ ) //draw a column of pixel with the same saturation but progressive brightness

        set( ColorPickerX + j, ColorPickerY + i, color((LineY - ColorPickerY)/40.58, j/255.0, (255 - i)/255.0 ) );
    }


    for ( int j = 0; j < 255; j++ )

    {

      for ( int i = 0; i < 20; i++ )

        set( ColorPickerX + 258 + i, ColorPickerY + j, color( j/40.58, 1.0, 1.0 ) );
    }
  }

 void drawActiveColor() 

  {

    fill( activeColor );
    stroke( 0 );
    strokeWeight( 1 );
    rect( ColorPickerX + 258, ColorPickerY+280, 40, 40 );
  }


 void checkMouse() 

  {

    if ( mousePressed ) 

    {

      if (mouseX>ColorPickerX+258&&mouseX<ColorPickerX+277&&mouseY>ColorPickerY-1&&mouseY<ColorPickerY+255&&!isDraggingCross)

      {

        LineY=mouseY;
        isDraggingLine = true;
      }

      if (mouseX>ColorPickerX-1&&mouseX<ColorPickerX+255&&mouseY>ColorPickerY-1&&mouseY<ColorPickerY+255&&!isDraggingLine)

      {

        CrossX=mouseX;
        CrossY=mouseY;
        isDraggingCross = true;
      }
    }

  else

  {
    
    isDraggingCross = false;
    isDraggingLine = false;

  }
  }
}

