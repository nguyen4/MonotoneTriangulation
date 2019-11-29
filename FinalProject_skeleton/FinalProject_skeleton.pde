
import java.util.*;

ArrayList<Point>          points      = new ArrayList<Point>();
ArrayList<Edge>           edges       = new ArrayList<Edge>();
ArrayList<Triangle>       triangles   = new ArrayList<Triangle>();
LinkedList<Edge>          newEdges    ;

Polygon                   poly        = new Polygon();
String                    message     = null;

/////////////////////////////////////////
//DATA STRUCTURES FOR TESTING SUBPOLYGONS
int                       state       = 0;
DirectedGraph             dG          ;
ArrayList<Polygon>        subPolygons ;
Iterator<Polygon>         iter        ;
int                       i           ;
/////////////////////////////////////////


boolean saveImage = false;
boolean showPotentialDiagonals = false;
boolean showDiagonals = false;

// ANIMATION
boolean showX = false, showY = false;
boolean showTrianglesAni = false;
boolean showTrapAni = false;
boolean showSubPoly = false;
int aniLoop = 0;

// Trapezoidation animation array
ArrayList<Event> pqPresentX = new ArrayList<Event>();
ArrayList<Edge> presentTriangles = new ArrayList<Edge>();
ArrayList<Integer> presentOrderedPos = new ArrayList<Integer>();

// Triangulation animation array
// ArrayList<Float> midPointsArr = new ArrayList();

void setup(){
  size(800,800,P3D);
  frameRate(70);
}

// Rectangle (line) drag sweep variables
int xHori = 21, yHori = height-140, a = 2, b = height - 300;
int x2Hori = width;

int xVerti = 21, yVerti = 20;
int y2Verti = height;

void draw(){
  home();
}


void keyPressed(){
  if( key == 's' ) saveImage = true;
  if( key == 'c' ) reset();
  if( key == 'p' ) showPotentialDiagonals = !showPotentialDiagonals;
  if( key == 'd' ) showDiagonals = !showDiagonals;

  // Ruler
  if ( key == 'x' ) { xSweepSetUp(); } 
  if ( key == 'y' ) { ySweepSetUp(); }
  
  //Monotone Partition
  if ( key == 'm' ) { trapezoidationSetUp(); }
  if ( key == 'n' && subPolygons != null /* && i < subPolygons.size() - 1 */ ){
    // i++;
    
    showSubPoly = !showSubPoly;
  }
  
  // Triangulation
  if ( key == 't' ) { triangulationSetUp(); }
   
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
  fill(255);
}

Point sel = null;

void mousePressed(){
  
  if (!showX || !showY) {
    
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
      for (Edge e : poly.bdry){
        e.Print();
      }
      println();
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

void monoPart(){
   if (!poly.isSimple()){
     fill(255);
     message = "PLEASE MAKE A SIMPLE POLYGON";
     return;
   }
    newEdges = MonotonePartition();
    subPolygons = Partition(newEdges);
    // state = 1;
    if (subPolygons != null ){
      i = 0;
    }
    message = null; 
}

void home(){
  background(0);
  
  translate( 0, height, 0);
  scale( 1, -1, 1 );
  
  strokeWeight(3);
  
  if (state == 0){
    showHomeView();
  }
  
  if (state == 1){
    showBeforeMonotonePartition();
    // showAfterMonotonePartition();
  }
  
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
  
  fill(255);
  stroke(0);
  textSize(18);
  
  // LABELS
  textRHC( "Controls", 10, height-20 );
  // NOT NEEDED
  //textRHC( "d: Show/Hide Diagonals", 10, height-40 );
  //textRHC( "p: Show/Hide Potential Diagonals", 10, height-60 );
  
  // Notify user if function is in use by changing font color of showX label
  if (showX) { fill(255, 0, 0); } else { fill(255); }
  textRHC( "x: X-Axis Sweep", 10, height-40);
  
  // Notify user if function is in use by changing font color of showY label
  fill(255);
  if (showY) { fill(255, 0, 0); } else { fill(255); }
  textRHC( "y: Y-Axis Sweep", 10, height-60);
  
  
  textRHC( "c: Clear Polygon", 10, height-80 );
  textRHC( "s: Save Image", 10, height-100 );
  
  if (showTrapAni) { fill(255, 0, 0); } else { fill(255); }
  textRHC( "m: Monotone Partition", 10, height-120 );
  fill(255);
  if (showTrianglesAni) { fill(255, 0, 0); } else { fill(255); }
  textRHC( "t: Triangulation", 10, height-140);
  

  textRHC( "Clockwise: " + (poly.cw()?"True":"False"), 550, 80 );
  textRHC( "Counterclockwise: " + (poly.ccw()?"True":"False"), 550, 60 );
  textRHC( "Closed Boundary: " + (poly.isClosed()?"True":"False"), 550, 40 );
  textRHC( "Simple Boundary: " + (poly.isSimple()?"True":"False"), 550, 20 );
  
  
  // MESSAGES
  if (message != null)
    textRHC( message, width/2, height-120 );
  
  // Point Labels
  // if (state == 0){
    for( int i = 0; i < points.size(); i++ ){
      fill(255);
      textRHC( i+1, points.get(i).p.x+5, points.get(i).p.y+15 );
    }
  // }

  if( saveImage ) saveFrame( ); 
  saveImage = false;
  
  // *********************************************************ANIMATION************************************************************************
  if (poly.isClosed()) {
    
    pqPresentX = makePQ();
    presentOrderedPos = poly.orderedPointsPos(points);
    
    // show X axis
    if (showX) { animateXSweep(); }
    
    // show Y axis
    if (showY) { ySweepFunction(); }
 
    // Animation of triangulation of one y monotone polygon
    if (showTrianglesAni) { triangulationProcess(); }

    // Animation of trapezoidation
    if (showTrapAni) { animateTrapezoidation(); }
    
    // Show subpolygons
    if (showSubPoly) { showAfterMonotonePartition(); }
  }
}

void showHomeView(){
  fill(0);
    noStroke();
    for( Point p : points ){
      fill(255);
      p.draw();
    }
    
    // noFill();
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
  
    //green if ccw
    stroke( 100, 100, 100 );
    if( poly.ccw() ) { 
      poly.ccw = true;
      poly.cw  = false;
      stroke( 100, 200, 100 );
    }
    //red if cw
    if( poly.cw()  ) {
      poly.cw  = true;
      poly.ccw = false;
      stroke( 200, 100, 100 );
    }
    
    poly.draw();
}

void showBeforeMonotonePartition() {
  noStroke();
    for( Point p : poly.p ){
      fill(255);
      p.draw();
    }
    //
    
    noFill();
    stroke(100);
    for( Edge e : poly.bdry ){
      fill(255);
      e.draw();
    }
    
    noStroke();
    for( Triangle t : triangles ){
      fill( 100, 100, 100 );
      if( t.ccw() ) fill( 200, 100, 100 );
      if( t.cw()  ) fill( 100, 200, 100 ); 
      t.draw();
    }
}
void showAfterMonotonePartition() {
  for (int j = 0; j < subPolygons.size(); j++){
      // fill(0);
      fill(255);
      noStroke();
      for( Point p : subPolygons.get(j).p ){
        p.draw();
      }
    
      noFill();
      stroke(100);
      for( Edge e : subPolygons.get(j).bdry ){
        e.draw();
      }
    }
}
