class Ultrasonic { 
  int mashtab;
  float x, y, x1, y1;                       // variable to store x and y co-ordinates for vertices   
  int x0; //х координата центра
  int y0;// y координата центра
  int w ;                    // set an arbitary width value
  int degree ;                 // servo position in degrees
  int value ;                  // value from sensor
  int motion = 0;                 // value to store which way the servo is panning
  int[] newValue = new int[181];  // create an array to store each new sensor value for each servo position
  int[] oldValue = new int[181];  // create an array to store the previous values.
  int radarDist = 0;    
  int distanse;

  Ultrasonic(int x2, int y2, int w2) {
    x0=x2;
    y0=y2;
    w=w2;
  }



  /* draw the screen */
  void radar(int degree, int value) {
    distanse=value;
    switch(mashtab) {
    case 30:
      if (value<180) {
        value=int(value*1.67);
      }
      break;
    case 10:
      if (value<60) {
        value=value*5;
      }
      break;
    }
    oldValue[degree] = newValue[degree]; // store the values in the arrays.
    newValue[degree] = value;  

    fill(0);                              // set the following shapes to be black
    noStroke();                           // set the following shapes to have no outline
    rectMode(CENTER); 
    // set the following rectangle to be drawn around its center
    if (flagControl==1) {
      if (degree >= 179) {                  // if at the far right then set motion = 1/ true we're about to go right to left
        motion = 1;                         // this changes the animation to run right to left
      }
      if (degree <= 1) {                    // if servo at 0 degrees then we're about to go left to right
        motion = 0;                         // this sets the animation to run left to right
      }
    } else {
      if (degree >= 120) {                  // if at the far right then set motion = 1/ true we're about to go right to left
        motion = 1;                         // this changes the animation to run right to left
      }
      if (degree <= 60) {                    // if servo at 0 degrees then we're about to go left to right
        motion = 0;                         // this sets the animation to run left to right
      }
    }
    // диаграмма направленности
    pushMatrix();
    translate(x0, y0);
    strokeWeight(7);   // set the thickness of the lines
    if (flagControl==1) {
      if (motion == 0) {                    // if going left to right
        for (int i = 0; i <= 15; i++) {     // draw 20 lines with fading colour each 1 degree further round than the last
          stroke(0, (10*i), 0);             // set the stroke colour (Red, Green, Blue) base it on the the value of i
          if (degree+i<180) {
            line(0, 0, cos(radians(degree+(180+i)))*w, sin(radians(degree+(180+i)))*w); // line(start x, start y, end x, end y)
          }
        }
      } else {                              // if going right to left
        for (int i = 0; i <= 15; i++) {     // draw 20 lines with fading colour
          stroke(0, (10*i), 0);
          if (degree-i>0) {
            line(0, 0, cos(radians(degree+(180-i)))*w, sin(radians(degree+(180-i)))*w);
          }
        }
      }
    } else {
      if (motion == 0) {                    // if going left to right
        for (int i = 0; i <= 8; i++) {     // draw 20 lines with fading colour each 1 degree further round than the last
          stroke(0, (10*i), 0);             // set the stroke colour (Red, Green, Blue) base it on the the value of i
          if (degree+i<120) {
            line(0, 0, cos(radians(degree+(180+i)))*w, sin(radians(degree+(180+i)))*w); // line(start x, start y, end x, end y)
          }
        }
      } else {                              // if going right to left
        for (int i = 0; i <= 8; i++) {     // draw 20 lines with fading colour
          stroke(0, (10*i), 0);
          if (degree-i>60) {
            line(0, 0, cos(radians(degree+(180-i)))*w, sin(radians(degree+(180-i)))*w);
          }
        }
      }
    }

    popMatrix();

    /* Setup the shapes made from the sensor values */
    noStroke();                           // no outline
    /* первые замеры */
    fill(0, 50, 0);                         // set the fill colour of the shape (Red, Green, Blue)
    pushMatrix();
    translate(x0, y0);
    beginShape();                         // start drawing shape
    for (int i = 0; i < 180; i++) {     // for each degree in the array
      x = cos(radians((180+i)))*((oldValue[i])); // create x coordinate
      y = sin(radians((180+i)))*((oldValue[i])); // create y coordinate
      vertex(x, y);                     // plot vertices
    }
    endShape();                           // end shape
    /* вторые замеры */
    fill(0, 110, 0);
    beginShape();
    for (int i = 0; i < 180; i++) {
      x = cos(radians((180+i)))*(newValue[i]);
      y = sin(radians((180+i)))*(newValue[i]);
      vertex(x, y);
    }
    endShape();
    /* суммирование */
    fill(0, 170, 0);
    beginShape();
    for (int i = 0; i < 180; i++) {
      x = cos(radians((180+i)))*((newValue[i]+oldValue[i])/2); // create average
      y = sin(radians((180+i)))*((newValue[i]+oldValue[i])/2);
      vertex(x, y);
    }
    endShape();
    popMatrix();

    /* Разметка дальности.. */
    pushMatrix();
    translate(x0, y0);
    for (int i = 0; i <=6; i++) {
      noFill();
      strokeWeight(1);
      stroke(0, 255-(30*i), 0);
      arc(0, 0, (100*i), (100*i), PI, TWO_PI, CHORD); 
      fill(0, 100, 0);
      noStroke();
      text(Integer.toString(mashtab*i), 0+25, 10-radarDist, 50, 50);
      radarDist+=50;
    }
    radarDist = 0;
    /* Градусная разметка. */
    for (int i = 0; i <= 6; i++) {
      strokeWeight(1);
      stroke(0, 55, 0);
      line(0, 0, cos(radians(180+(30*i)))*w, sin(radians(180+(30*i)))*w);
      fill(0, 55, 0);
      noStroke();
      if (90-(30*i) >=0) {
        text(Integer.toString(90-(30*i)), cos(radians(180+(30*i)))*(w+10), sin(radians(180+(30*i)))*(w+10), 25, 50);
      } else {
        text(Integer.toString((30*i-90)), cos(radians(180+(30*i)))*(w+40), sin(radians(180+(30*i)))*(w), 60, 40);
      }
    }

    /* Write information text and values. */
    noStroke();
    fill(0);
    fill(0, 100, 0);
    text("Угол: "+Integer.toString(degree), -250, 30, 100, 50);         // use Integet.toString to convert numeric to string as text() only outputs strings
    text("Дистанция: "+Integer.toString(distanse), 200, 30, 200, 50);         // text(string, x, y, width, height)
    text("Масштаб", -260, -318);
    text("Режим", 275, -318);
    popMatrix();
  }
}
