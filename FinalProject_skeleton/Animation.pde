// ANIMATION FUNCTIONs
void aniTrapezoidation(Point curr, int type, int j) {
  curr = points.get(presentOrderedPos.get(j));        
  type = pqPresentX.get(j).type;
        
  // display line at each point
  strokeWeight(3);
  stroke(0, 0, 255);
  line(0, curr.p.y, width, curr.p.y);
  
  // Vertex labels and type
  if (type == 0) { // collinear label
    
  } else if (type == 1) { // regular label
    // label
    fill(255);
    textSize(24);
    textRHC( "regular" , curr.p.x+5, curr.p.y+35 );
    
    // vertex color
    fill(255);
    strokeWeight(1);
    stroke(0);
  } else if (type == 2) { // start label
    // label
    fill(255, 0, 0);
    textSize(24);
    textRHC( "start" , curr.p.x+5, curr.p.y+35 );
    
    // vertex color
    fill(255, 0, 0);
    strokeWeight(1);
    stroke(0);
    
  } else if (type == 3) { // end label
    // label
    fill(0,191,255);
    textSize(24);
    textRHC( "end" , curr.p.x+5, curr.p.y+35 );
    
    // vertex color
    fill(0, 191, 255);
    strokeWeight(1);
    stroke(0);

  } else if (type == 4) { // merge label
    // label
    fill(0, 255, 0);
    textSize(24);
    textRHC( "merge" , curr.p.x+5, curr.p.y+35 );
    
    // vertex color
    fill(0, 255, 0);
    strokeWeight(1);
    stroke(0);
    
  } else if (type == 5) { // split label
    // label
    fill(100);
    textSize(24);
    textRHC( "split" , curr.p.x+5, curr.p.y+35 );
    
    // vertex color
    fill(100);
    strokeWeight(1);
    stroke(0);

  }
  
  curr.draw();
  
  // draw diagonals
  for (Edge e : newEdges) {
    
    if ((curr.p.x == e.p0.p.x && curr.p.y == e.p0.p.y)) {
      if (e.p0.p.y < e.p1.p.y) {
        strokeWeight(2);
        stroke(255,0,0);
        e.draw();
      }
    } else if ((curr.p.x == e.p1.p.x && curr.p.y == e.p1.p.y)) {
      if (e.p1.p.y < e.p0.p.y) {
        strokeWeight(2);
        stroke(255,0,0);
        e.draw();
      }
    }
  }
  
}
void aniMonoY(ArrayList<Float> midPointsArr) {
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
}

/************************************************* Y MONOTONE CHECK *******************************************************/
void animateXSweep(){
  
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
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/************************************************* X MONOTONE CHECK ******************************************************/
void ySweepFunction() {
    
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
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/************************************************* TRIANGULATION ******************************************************/
void triangulationProcess() {
  
    // if original polygon is already y monotone
    if (poly.isYMonotone()) {
     
      animateTriangulation1();
      
    } else if (subPolygons != null) {
      
      showAfterMonotonePartition();
      animateTriangulation2();
      
    } else {
      fill(255);
      message = "NOT ABLE TO TRIANGULATE!!!!!";
      
    }
}
void animateTriangulation1() {
    
  int i = 0, j = 0;
        
    while (i < aniLoop && j < Triangulate(poly).size()) {
      
      // diagonals
      strokeWeight(4);
      stroke(255, 128, 0); // orange
      Triangulate(poly).get(j).draw();

      
      i = i + 100;
      j++;
    }
    aniLoop = aniLoop + 1;
}

void animateTriangulation2() {
  
    int i = 0, j = 0;
        
    for (int a = 0; a < subPolygons.size(); a++) {
      while (i < aniLoop && j < Triangulate(subPolygons.get(a)).size()) {
        
        // diagonals
        strokeWeight(4);
        stroke(255,105,180); // pink
        // stroke(0,255,0);
        Triangulate(subPolygons.get(a)).get(j).draw();
        
        i = i + 200;
        j++;
      }
      aniLoop = aniLoop + 1;
      
      // ??????????
      if (j == Triangulate(subPolygons.get(a)).size()) {
        j = 0;
      }   
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/************************************************* TRAPEZOIDATION ******************************************************/
void animateTrapezoidation() {

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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/************************************************* SETUPS ******************************************************/
void reset(){
    points.clear(); 
    poly             = new Polygon();
    subPolygons      = null;
    showX            = false;
    showY            = false;
    showTrianglesAni = false;
    showTrapAni      = false;
    state            = 0;
    i                = 0;
}

void xSweepSetUp() {
  
  showX = !showX; 
  xHori = 21; yHori = height;
  x2Hori = xHori;
  showY = false; 
  showTrapAni = false; 
  showTrianglesAni = false;
  
}

void ySweepSetUp() {
  
  showY = !showY; 
  xVerti = 21; yVerti = 20;
  y2Verti = yVerti;
  showX = false; 
  showTrapAni = false; 
  showTrianglesAni = false;
  
}

void triangulationSetUp(){
  showTrianglesAni = !showTrianglesAni;
  aniLoop = 0; 
  
  if (showTrianglesAni) { 
    showY = false; 
    showX = false; 
    showTrapAni = false; 
  }
}

void trapezoidationSetUp() {
  
  monoPart();
  
  showTrapAni = !showTrapAni;
  aniLoop = 0; 
  
  if (showTrapAni) { 
    showY = false; 
    showX = false; 
    showTrianglesAni = false;
  }
  
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
