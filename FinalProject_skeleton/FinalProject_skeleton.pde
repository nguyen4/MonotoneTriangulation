
import java.util.*;

ArrayList<Point>    points     = new ArrayList<Point>();
ArrayList<Edge>     edges      = new ArrayList<Edge>();
ArrayList<Triangle> triangles  = new ArrayList<Triangle>();
Polygon             poly       = new Polygon();
String              message    = null;

boolean saveImage = false;
boolean showPotentialDiagonals = false;
boolean showDiagonals = false;

// ANIMATION
boolean showX = false, showY = false;

void setup(){
  size(800,800,P3D);
  frameRate(30);
}

// Rectangle (line) drag sweep variables
int x = 21, y = 140, a = 2, b = height - 300;



void draw(){
  background(255);
  
  translate( 0, height, 0);
  scale( 1, -1, 1 );
  
  strokeWeight(3);
  
  fill(0);
  noStroke();
  for( Point p : points ){
    p.draw();
  }
  
  noFill();
  stroke(100);
  for( Edge e : edges ){
    e.draw();
  }
  
  noStroke();
  for( Triangle t : triangles ){
    fill( 100, 100, 100 );
    if( t.ccw() ) fill( 200, 100, 100 );
    if( t.cw()  ) fill( 100, 200, 100 ); 
    t.draw();
  }
  
  stroke( 100, 100, 100 );
  if( poly.ccw() ) { 
    poly.ccw = true;
    stroke( 100, 200, 100 );
  }
  if( poly.cw()  ) {
    poly.cw = true;
    stroke( 200, 100, 100 );
  }
  poly.draw();
  
  
  if( showPotentialDiagonals ){
    strokeWeight(1);
    stroke(100,100,100);
    fill(0,0,200);
    for( Edge e : poly.getPotentialDiagonals() ){
        e.drawDotted();
    }
  }
  
  if( showDiagonals ){
    strokeWeight(4);
    stroke(100,100,200);
    for( Edge e : poly.getDiagonals() ){
        e.draw();
    }
  }
  
  fill(0);
  stroke(0);
  textSize(18);
  
  // LABELS
  textRHC( "Controls", 10, height-20 );
  textRHC( "d: Show/Hide Diagonals", 10, height-40 );
  textRHC( "p: Show/Hide Potential Diagonals", 10, height-60 );
  textRHC( "c: Clear Polygon", 10, height-80 );
  textRHC( "s: Save Image", 10, height-100 );
  textRHC( "m: Monotone Partition", 10, height-120 );
  

  textRHC( "Clockwise: " + (poly.cw()?"True":"False"), 550, 80 );
  textRHC( "Counterclockwise: " + (poly.ccw()?"True":"False"), 550, 60 );
  textRHC( "Closed Boundary: " + (poly.isClosed()?"True":"False"), 550, 40 );
  textRHC( "Simple Boundary: " + (poly.isSimple()?"True":"False"), 550, 20 );
  
  // MESSAGES
  if (message != null)
    textRHC( message, width/2, height-120 );
  
  if (showX) {
    
  }
  textRHC( "x: X-Axis Sweep", 10, 80);
  textRHC( "y: Y-Axis Sweep", 10, 60);
  
  for( int i = 0; i < points.size(); i++ ){
    textRHC( i+1, points.get(i).p.x+5, points.get(i).p.y+15 );
  }
  
  if( saveImage ) saveFrame( ); 
  saveImage = false;
  
  // ANIMATION
  if (poly.isClosed()) {
    
    // show X axis
    if (showX) {
      // Make two shapes
      rect(x, y, width, 2);
      fill(255);
      ellipse(x-(25/2), y, 25, 25);
        
      // RULER DRAG
      // y-axis line
      x = mouseX;
      y = height - mouseY;
      cursor(HAND);
      

      if ((height - mouseY) < 140) {
       textSize(32);
       fill(0, 102, 153);
       //if (poly.isConvex()) {
       //  textRHC("CONVEX", 10, 30); 
       //} else {
       //  textRHC("NOT CONVEX", 10, 30);
       //}
       if (poly.isYMonotone()) {
         textRHC("YMono", 10, 30);
       } else {
         
         textRHC("Not YMono", 10, 30);
       }
      }
      
    }
    
    // show Y axis
    if (showY) {
      // Make two shapes
      rect(x, y, 2, height);
      fill(255);
      ellipse(x, y-(25/2), 25, 25);
        
      // RULER DRAG
      // y-axis line
      x = mouseX;
      y = height - mouseY;
      cursor(HAND);
      
      if (mouseX > width - 100) {
       textSize(32);
       fill(0, 102, 153);
       //if (poly.isConvex()) {
       //  textRHC("CONVEX", 10, 30); 
       //} else {
       //  textRHC("NOT CONVEX", 10, 30);
       //}
       if (poly.isXMonotone()) {
         textRHC("XMono", 10, 30);
       } else {
         
         textRHC("Not XMono", 10, 30);
       }
      }
    }
  }
}


void keyPressed(){
  if( key == 's' ) saveImage = true;
  if( key == 'c' ){ points.clear(); poly = new Polygon(); }
  if( key == 'p' ) showPotentialDiagonals = !showPotentialDiagonals;
  if( key == 'd' ) showDiagonals = !showDiagonals;
  
  // Ruler
  if ( key == 'x' ) { showX = !showX; }
  if ( key == 'y' ) { showY = !showY; }
  
  //Monotone Partition
  if ( key == 'm' && poly.isSimple()) { MonotonePartition(); poly.draw(); message = null; }
  else { message = "PLEASE MAKE A SIMPLE POLYGON";}
}


void textRHC( int s, float x, float y ){
  textRHC( Integer.toString(s), x, y );
}


void textRHC( String s, float x, float y ){
  pushMatrix();
  translate(x,y);
  scale(1,-1,1);
  text( s, 0, 0 );
  popMatrix();
}

Point sel = null;

void mousePressed(){
  
  if (!showX && !showY) {
    
    int mouseXRHC = mouseX;
    int mouseYRHC = height-mouseY;
  
    float dT = 6;
    for( Point p : points ){
      float d = dist( p.p.x, p.p.y, mouseXRHC, mouseYRHC );
      if( d < dT ){
        dT = d;
        sel = p;
      }
    }
    
    if( sel == null ){
      sel = new Point(mouseXRHC,mouseYRHC);
      points.add( sel );
      poly.addPoint( sel );
    }
    
  }
}

void mouseDragged(){
  int mouseXRHC = mouseX;
  int mouseYRHC = height-mouseY;
  if( sel != null ){
    sel.p.x = mouseXRHC;   
    sel.p.y = mouseYRHC;   
  }
}

void mouseReleased(){
  sel = null;
}




  
