/*
 * Programm by Zakharov Sergey in 2019, final touches and docs in 2021.
 * This programm will approximate any curve by sum of harmonics (vectors, rotated at integer speeds.
 * User can input his curve with his mouse. After he releases the button,
 * programm will automatically start drawing.
 */

import java.util.*;

// Multipliers (Complex number) for each harmonic 
ArrayList<Complex> weights = new ArrayList<Complex>();
// User input
ArrayList<Complex> func = new ArrayList<Complex>();
// The result curve
Vector<Complex> mFunc = new Vector<Complex>();

// Count of arrows, rotating either side (in total will be 2 * arrowCnt + 1) 
int arrowCnt = 10;

void setup() {
  fullScreen();
  frameRate(60);

  fill(255);
  background(0);
}

// Time counter
int t = -1;

// True, if programm is showing the result curve
boolean showing = false;
// True, if user pressed mouse button and is drawing
boolean drawing = false;
// True, if programm needs to draw all vectors (arrows)
boolean arrowsDrawing = false;
// True, if camera is fixed, otherwise camera will follow the last end
boolean globalCamera = true;
// Scaleing factor
float zoom = 1;

//int delay = 0;
// Initializing complex weights of all the harmonics
void buildWeights(int arrowNum) {
  weights.clear();
  for ( int i = 0; i < 2*arrowNum + 1; ++i ) {
    Complex c = new Complex();
    int n = i - arrowNum;
    for ( int tt = 0; tt < func.size(); ++tt ) {
      c.add(mult(func.get(tt), epowi(-n * TWO_PI * (float(tt) / func.size()))).div(func.size()));
    }
    //println(i);
    //println(c);
    weights.add(c);
  }
}

// calculating result sum of all vectors at moment t
void calcPoint(int t) {
  Complex a = new Complex();
  for ( int i = 0; i < weights.size(); ++i ) {
    int n = i - (weights.size()-1) / 2;
    a.add(mult(weights.get(i), epowi( (float(t)/func.size()) * n * TWO_PI )));
  }
  //a.print();
  //point(a.a, a.b);
  mFunc.set(t, a);
}

// Drawing arrow
void drawArrow(Complex from, Complex to) {
  stroke(255, 0, 0);
  line(from.a, from.b, to.a, to.b);
  stroke(255, 0, 255, 100);
  ellipseMode(RADIUS);
  noFill();
  ellipse(from.a, from.b, sub(to, from).mod(), sub(to, from).mod());
}

// Drawing all arrows at moment t
void drawArrows(int t) {
  pushStyle();
  Complex c = new Complex(weights.get(arrowCnt));
  Complex prv;
  //println(weights);
  for ( int i = 1; i <= arrowCnt; ++i ) {
    //print(c);
    prv = new Complex(c);
    c.add(mult(weights.get(i + arrowCnt), epowi((float(t)/func.size()) * i * TWO_PI)));
    drawArrow(prv, c);

    prv = new Complex(c);
    c.add(mult(weights.get(arrowCnt - i), epowi((float(t)/func.size()) * (-i) * TWO_PI)));
    drawArrow(prv, c);
  }
  popStyle();
  //print('\n');
}

// Draws all points in the list
void drawPoints(AbstractList<Complex> list) {
  for ( Complex c : list ) {
    if ( c != null )
      point(c.a, c.b);
  }
}

void globalReset() {
  showing = false;
  drawing = false;
  func.clear();
  mFunc.clear();
  globalCamera = true;
}

void keyPressed() {
  switch(key) {
    // Showing arrows
    case 'h':
      arrowsDrawing = !arrowsDrawing;
      break;
    // reset (full clear)
    case 'r':
      globalReset();
      break;
    // Camera movement
    case 'c':
      globalCamera = !globalCamera;
      break;
    // Zooming
    case 'z':
      zoom *= 1.1;
      break;
    case 'x':
      zoom /= 1.1;
      break;
  case CODED:
    switch(keyCode) {
    // Changing number of arrows
    case UP:
      arrowCnt += 1;
      buildWeights(arrowCnt);
      break;
    case DOWN:
      arrowCnt -= 1;
      if ( arrowCnt < 0 ) arrowCnt = 0;
      buildWeights(arrowCnt);
      break;
    
    // Slowing or accelerating simulation
    case LEFT:
      frameRate(max(frameRate - 10, 0));
      break;
    case RIGHT:
      frameRate(frameRate + 10);
      break;
    }
    break;
  }
}

void draw() {
  background(0);
  fill(255);
  textSize(15);
  String message = "";
  message += "Programm by Zakharov Sergey 2021\n";
  message += "'r' to reset, 'h' to show arrows, 'c' to change camera movement.\n";
  message += "Scale factor: " + round(zoom * 100) / 100.0 + "'z' and 'x' to change.\n";
  message += "Arrow count: " + arrowCnt + " UP and DOWN to change.\n";
  message += "FPS: " + round(frameRate) + " LEFT and RIGHT to change.\n";
  message += "ESC to exit\n";
  text(message, 5, 15);
  // Camera movement
  boolean transformed = false;
  if(showing && !globalCamera) {
    pushMatrix();
    scale(zoom);
    translate(-mFunc.get(t).a, -mFunc.get(t).b);
    translate(width / zoom / 2, height / zoom / 2);
    transformed = true;
  }

  // Drawing user points
  stroke(100);
  drawPoints(func);
  
  // Drawing the result
  if ( showing ) {
    ++t;
    if ( t >= mFunc.size() ) {
      t -= mFunc.size();
    }
    // Calculating actual point
    stroke(255);
    calcPoint(t);

    // Drawing the result
    stroke(255);
    drawPoints(mFunc);
    if ( arrowsDrawing )
      drawArrows(t);

    // Moving camera back
    if(transformed)
      popMatrix();
  } else {
    // User input
    if ( mousePressed ) {
      // User draws point
      stroke(100);
      func.add(new Complex(mouseX, mouseY));
      point(mouseX, mouseY);
      drawing = true;
    } else if (drawing) {
      // Users stops drawing
      drawing = false;
      showing = true;
      buildWeights(arrowCnt);
      mFunc.setSize(func.size());
    }
  }
}
