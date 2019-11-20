
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
  if( key == 'c' ){ points.clear(); poly = new Polygon(); state = 0; i = 0;}
  if( key == 'p' ) showPotentialDiagonals = !showPotentialDiagonals;
  if( key == 'd' ) showDiagonals = !showDiagonals;
  
  //// Ruler
  //if ( key == 'x' ) { showX = !showX; }
  //if ( key == 'y' ) { showY = !showY; }
  
  // Ruler
  if ( key == 'x' ) { 
    showX = !showX; 
    xHori = 21; yHori = height;
    x2Hori = xHori;
    if (showX) {showY = false; showTrapAni = false; showTrianglesAni = false; } 
  }
  if ( key == 'y' ) { 
    showY = !showY; 
    xVerti = 21; yVerti = 20;
    y2Verti = yVerti;
    if (showY) {showX = false; showTrapAni = false; showTrianglesAni = false; }
  }
  
  //Monotone Partition
  if ( key == 'm' ) { monoPart(); showTrapAni = !showTrapAni; aniLoop = 0; if (showTrapAni) { showY = false; showX = false; showTrianglesAni = false;  }}
  if ( key == 'n' && subPolygons != null && i < subPolygons.size() - 1 ){
    i++;
  }
  
  // Triangulation
  if ( key == 't' ) { showTrianglesAni = !showTrianglesAni; aniLoop = 0; if (showTrianglesAni) { showY = false; showX = false; showTrapAni = false; }}
   
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
    state = 1;
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
  //if (state == 0){
    for( int i = 0; i < points.size(); i++ ){
      fill(255);
      textRHC( i+1, points.get(i).p.x+5, points.get(i).p.y+15 );
    }
  //}

  if( saveImage ) saveFrame( ); 
  saveImage = false;
  
  // *********************************************************ANIMATION************************************************************************
  if (poly.isClosed()) {
    
    pqPresentX = makePQ();
    presentOrderedPos = poly.orderedPointsPos();
    
    // show X axis
    if (showX) {
      ArrayList<Float> midPointsArr = new ArrayList();
      
      // Make two shapes
      // line sweep
      fill(255);
      stroke(0,0,255);
      rect(xHori, yHori, width, 2);
      
      // Animation triangulation function
      aniMonoY(midPointsArr);
      
      
      // ellipse attached to line sweep
      fill(255);
      stroke(0,0,255);
      ellipse(xHori-(25/2), yHori, 25, 25);
        
      yHori--;
      if (yHori < 0) {
        yHori = height; 
      }
      
      textSize(32);
      fill(0, 102, 153);
      
      if (poly.isYMonotone()) {
       textRHC("YMono", 10, 30);
      } else {
       
       textRHC("Not YMono", 10, 30);
      } 
    }
    
    // show Y axis
    if (showY) {
      // Make two shapes
      fill(255);
      stroke(0,0,255);
      rect(xVerti, yVerti, 2, height);
      fill(255);
      ellipse(xVerti, yVerti-(25/2), 25, 25);
        
      // RULER DRAG
      // y-axis line
      xVerti = mouseX;
      yVerti = height - mouseY;
      cursor(HAND);

      textSize(32);
      fill(0, 102, 153);
      if (poly.isXMonotone()) {
        textRHC("XMono", 10, 30);
      } else {
         
        textRHC("Not XMono", 10, 30);
      }

    }
    
    
     // Animation of triangulation of one y monotone polygon
     // ordered points (for v and v+?)
    if (showTrianglesAni) {
  
      ArrayList<Point> presentOrderedP = new ArrayList<Point>();
      
      for (int i = 0; i < points.size(); i++) {
        presentOrderedP.add(new Point(points.get(presentOrderedPos.get(i)).p));
      }
      
      //presentTriangles = Triangulate();
      int i = 0, j = 0, ii = 0, jj = 0;
      
      while (i < aniLoop && j < Triangulate().size()) {
        
        // diagonals
        strokeWeight(4);
        stroke(255, 128, 0); // orange
        Triangulate().get(j).draw();

        
        i = i + 100;
        j++;
      }
      aniLoop = aniLoop + 1;
    }
    
    
    // Animation of trapezoidation
    if (showTrapAni) {
      Point curr = new Point(0.0,0.0);
      int type = 0;
      
      int i = 0, j = 0;
      while (i < aniLoop && j < points.size()) {
        
        aniTrapezoidation(curr, type, j);
        
        i = i + 100;
        j++;
      }
      aniLoop = aniLoop + 1;
    }
    
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
    
    //noFill();
    //stroke(100);
    //for( Edge e : newEdges ){
    //  fill(255);
    //  e.draw();
    //}
    
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
