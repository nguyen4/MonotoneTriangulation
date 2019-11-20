
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
boolean showTriangles = false;
boolean showTrianglesAni = false;
int aniLoop = 0, aniLoop2 = 0;

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
    if (showX) {showY = false;} 
  }
  if ( key == 'y' ) { 
    showY = !showY; 
    xVerti = 21; yVerti = 20;
    y2Verti = yVerti;
    if (showY) {showX = false;}
  }
  
  //Monotone Partition
  if ( key == 'm' ) { monoPart(); }
  if ( key == 'n' && subPolygons != null && i < subPolygons.size() - 1 ){
    i++;
  }
  
  // Triangulation
  if ( key == 't' ) { showTriangles = !showTriangles; aniLoop = 0; aniLoop2 = 0;}
   
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
  background(255);
  
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
  
  //// show triangulation
  //if( showTriangles ){
  // strokeWeight(4);
  // stroke(255, 128, 0); // orange
  // for ( Edge t : Triangulate()) {
     
  //   t.draw();
  // }
  //}
  
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
//<<<<<<< HEAD
  
  // MESSAGES
  if (message != null)
    textRHC( message, width/2, height-120 );
  
//  if (showX) {
    
//  }
////=======

  if (showX) { fill(255, 0, 0); } else { noFill(); }
////>>>>>>> local
  textRHC( "x: X-Axis Sweep", 10, 80);
  
//<<<<<<< HEAD
  if (state == 0){
    for( int i = 0; i < points.size(); i++ ){
      textRHC( i+1, points.get(i).p.x+5, points.get(i).p.y+15 );
    }
  }
////=======
  fill(0,0,0);
  if (showY) { fill(255, 0, 0); } 
  textRHC( "y: Y-Axis Sweep", 10, 60);
////  for( int i = 0; i < points.size(); i++ ){
////    textRHC( i+1, points.get(i).p.x+5, points.get(i).p.y+15 );
//////>>>>>>> local
////  }
  if( saveImage ) saveFrame( ); 
  saveImage = false;
  
  // ANIMATION
  if (poly.isClosed()) {
    
    // show X axis
    if (showX) {
      ArrayList<Event> pqPresentX = makePQ();
      ArrayList<Float> midPointsArr = new ArrayList();
      // Make two shapes
      rect(xHori, yHori, width, 2);
      
      Event focus;
      int neighbor1Pos, originalPos, neighbor2Pos;
      Edge test;
      float midPointY = -1;
      
      
      for (int i = 0; i < pqPresentX.size(); i++) {
       focus = pqPresentX.get(i);
       if (focus.type == 4 || focus.type == 5) {
        originalPos = focus.label;
        if (originalPos == 0) {
         neighbor1Pos = points.size() - 1; 
        } else {
         neighbor1Pos = (originalPos - 1) % points.size();
        }
  
        // get current point's 2nd neighbor
        neighbor2Pos = (originalPos + 1) % points.size();
        
        if ((points.get(neighbor1Pos).p.y < points.get(neighbor2Pos).p.y && focus.type == 4) || ((points.get(neighbor1Pos).p.y > points.get(neighbor2Pos).p.y && focus.type == 5))) {
          test = new Edge(points.get(originalPos), points.get(neighbor1Pos));
          midPointY = test.midpoint().p.y;
          midPointsArr.add(midPointY);
          //break;
        } else if ((points.get(neighbor1Pos).p.y > points.get(neighbor2Pos).p.y && focus.type == 4) || (points.get(neighbor1Pos).p.y < points.get(neighbor2Pos).p.y && focus.type == 5)) {
          test = new Edge(points.get(originalPos), points.get(neighbor2Pos));
          midPointY = test.midpoint().p.y;
          midPointsArr.add(midPointY);
          //break;
        } else { // collinear, pick 1st edge
          test = new Edge(points.get(originalPos), points.get(neighbor1Pos));
          midPointY = test.midpoint().p.y;
          midPointsArr.add(midPointY);
          // break;
        }
       }  
      }
      
      ArrayList<Edge> presentMidEdges = new ArrayList();
      for (int i = 0; i < midPointsArr.size(); i++) {
        
        if (yHori < midPointsArr.get(i)) {
         Point p0 = new Point(0, midPointsArr.get(i));
         Point p1 = new Point(width, midPointsArr.get(i));
         presentMidEdges.add(new Edge(p0, p1));
         
         
         for (Edge p : presentMidEdges) {
           stroke(255, 0, 0);
           p.draw();
         }
        } else {
          
        }
      }
      fill(255);
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
    if (showTriangles) {
      
      //ArrayList<Edge> presentTriangles = new ArrayList<Edge>();
      //ArrayList<Integer> presentOrderedPos = new ArrayList<Integer>();
      //presentOrderedPos = poly.orderedPointsPos();
      
      //ArrayList<Point> presentOrderedP = new ArrayList<Point>();
      
      //for (int i = 0; i < points.size(); i++) {
      //  presentOrderedP.add(new Point(points.get(presentOrderedPos.get(i)).p));
      //}
      
      //presentTriangles = Triangulate();
      int i = 0, j = 0, ii = 0, jj = 0;
      
      while (i < aniLoop && j < Triangulate().size()) {
        
        // ** current v and v+ HIGHLIGHTED
        
        // reflex chain
      
        // ** current reflex chain HIGHLIGHTED
        
        
        // diagonals
        strokeWeight(4);
        stroke(255, 128, 0); // orange
        Triangulate().get(j).draw();

        
        i = i + 100;
        j++;
      }
      aniLoop = aniLoop + 1;
      
      ////while (ii < aniLoop2 && jj < presentOrderedP.size()) {
        
      ////  fill(0, 255, 0);
      ////  strokeWeight(1);
      ////  stroke(0);
      ////  presentOrderedP.get(jj).draw();
        
      ////  ii += 300;
      ////  jj++;
        
      ////}
      
      ////aniLoop2 = aniLoop2 + 1;
      
      
      ////strokeWeight(4);
      ////stroke(255, 128, 0); // orange
      ////for ( Edge t : Triangulate()) {
         
      ////  t.draw();
      ////}
    }
    
  }
}


//<<<<<<< HEAD
void showHomeView(){
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
      p.draw();
    }

////=======

//void keyPressed(){
//  if( key == 's' ) saveImage = true;
//  if( key == 'c' ){ points.clear(); poly = new Polygon(); }
//  if( key == 'p' ) showPotentialDiagonals = !showPotentialDiagonals;
//  if( key == 'd' ) showDiagonals = !showDiagonals;
  
//  // Ruler
//  if ( key == 'x' ) { 
//    showX = !showX; 
//    xHori = 21; yHori = height;
//    x2Hori = xHori;
//    if (showX) {showY = false;} 
//  }
//  if ( key == 'y' ) { 
//    showY = !showY; 
//    xVerti = 21; yVerti = 20;
//    y2Verti = yVerti;
//    if (showY) {showX = false;}
//  }
  
//  //Monotone Partiton
//  if ( key == 'm' ) { MonotonePartition(); poly.draw(); }
  
//  // Triangulation
//  if ( key == 't' ) { showTriangles = !showTriangles; aniLoop = 0; aniLoop2 = 0;}
//}



//void textRHC( int s, float x, float y ){
//  textRHC( Integer.toString(s), x, y );
//}


//void textRHC( String s, float x, float y ){
//  pushMatrix();
//  translate(x,y);
//  scale(1,-1,1);
//  text( s, 0, 0 );
//  popMatrix();
//}

//Point sel = null;

//void mousePressed(){
  
//  if (!showX || !showY) {
//>>>>>>> local
    
    noFill();
    stroke(100);
    for( Edge e : poly.bdry ){
      e.draw();
    }
    
    noFill();
    stroke(100);
    for( Edge e : newEdges ){
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
      fill(0);
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
