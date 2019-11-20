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
