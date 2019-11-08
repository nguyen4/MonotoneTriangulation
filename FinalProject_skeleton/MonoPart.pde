String[] myType = { "Collinear", "Regular", "Start", "End", "Merge", "Split" };

void makePQ() {
  
  // Event Class Arraylist
  ArrayList<Event> pQueue = new ArrayList<Event>();
  
  ArrayList<Integer> orderedPoints = new ArrayList<Integer>();
  orderedPoints = poly.orderedPointsPos();
  
  
  // Declare 4 variables to add to Event constructor
  Point currPoint;
  
  int type;
  
 
  for (int i = 0; i < orderedPoints.size(); i++) {
   int originalPos = orderedPoints.get(i);
   currPoint = points.get(originalPos);
   ArrayList<Edge> edges = new ArrayList<Edge>();

   for (int j = 0; j < poly.bdry.size(); j++) {
    
    Point p0 = poly.bdry.get(j).p0;
    Point p1 = poly.bdry.get(j).p1;
    
    if (currPoint.p.x == p0.p.x && currPoint.p.y == p0.p.y || 
        currPoint.p.x == p1.p.x && currPoint.p.y == p1.p.y) {
        
        edges.add(poly.bdry.get(j));
    }
   }
   // Call findVertexType() (of vertex) method
   type = findVertexType(currPoint, edges.get(0), edges.get(1));
   
   //println("Before");
   Event e = new Event(currPoint, edges.get(0), edges.get(1), type, originalPos);
   //println("event created");
   pQueue.add(e);
   
  }
  
  // TEST PRINT RUN
  for (int i = 0; i < pQueue.size(); i++) {
   Event e = pQueue.get(i);
   println(e.label+1 + ": " + "Point: " + e.P.toString() + "       " + myType[e.type]);
  }
  println();
  
}
int findVertexType(Point c, Edge e1, Edge e2) {
    
  Point e1ePoint, e2ePoint;
  
  
  // check for intersection with edge 1 
  if (c.p.x == e1.p0.p.x && c.p.y == e1.p0.p.y) {
    e1ePoint = e1.p1;
  } else {
    e1ePoint = e1.p0;
  }
  
  // and edge 2
  if (c.p.x == e2.p0.p.x && c.p.y == e2.p0.p.y) {
    e2ePoint = e2.p1;
  } else {
    e2ePoint = e2.p0;
  }
  
  // check if different signs
  if (c.p.y > e1ePoint.p.y && c.p.y < e2ePoint.p.y || c.p.y < e1ePoint.p.y && c.p.y > e2ePoint.p.y) {
    return 1;
  }
  
  Triangle test;
  ArrayList<Point> points = new ArrayList<Point>();
  if ()
  
  // FUN PART
  // table vertex
  // 1 - reg
  // 2 - start
  // 3 - end 
  // 4 - merge
  // 5 - split
  
  // POLYGON IS CCW
  if (poly.ccw) {
    
    // + + (checking difference between merge and end)
    if (c.p.y < e1ePoint.p.y && c.p.y < e2ePoint.p.y) {
      // check which endpoint is on the left
      if (e1ePoint.p.x < e2ePoint.p.x) { // e1e, point c, e2e
       test = new Triangle(e1ePoint, c, e2ePoint);
       if (test.ccw()) {
         return 3;
       } else {
         return 4;
       }
      } else { // e2e, point c, e1e
       test = new Triangle(e2ePoint, c, e1ePoint);
       if (test.ccw()) {
         return 3;
       } else {
         return 4;
       }
      }
      // collinear???
      
      // - - (checking difference between start and split
    } else if (c.p.y > e1ePoint.p.y && c.p.y > e2ePoint.p.y){
      // check which endpoint is on the left
      if (e1ePoint.p.x < e2ePoint.p.x) { // e1e, point c, e2e
       test = new Triangle(e1ePoint, c, e2ePoint);
       if (test.ccw()) {
         return 2;
       } else {
         return 5;
       }
      } else { // e2e, point c, e1e
       test = new Triangle(e2ePoint, c, e1ePoint);
       if (test.ccw()) {
         return 2;
       } else {
         return 5;
       }
      }    
    }
    
    // POLYGON IS CW
  } else {
    // + + (checking difference between merge and end)
    if (c.p.y < e1ePoint.p.y && c.p.y < e2ePoint.p.y) {
      // check which endpoint is on the left
      if (e1ePoint.p.x < e2ePoint.p.x) { // e1e, point c, e2e
       test = new Triangle(e1ePoint, c, e2ePoint);
       if (test.cw()) {
         return 3;
       } else {
         return 4;
       }
      } else { // e2e, point c, e1e
       test = new Triangle(e2ePoint, c, e1ePoint);
       if (test.cw()) {
         return 3;
       } else {
         return 4;
       }
      }
      // collinear???
      
    // - - (checking difference between start and split
    } else if (c.p.y > e1ePoint.p.y && c.p.y > e2ePoint.p.y){
      
      // check which endpoint is on the left
      if (e1ePoint.p.x < e2ePoint.p.x) { // e1e, point c, e2e
       test = new Triangle(e1ePoint, c, e2ePoint);
       if (test.cw()) {
         return 2;
       } else {
         return 5;
       }
      } else { // e2e, point c, e1e
       test = new Triangle(e2ePoint, c, e1ePoint);
       if (test.cw()) {
         return 2;
       } else {
         return 5;
       }
      }    
    }
  }
  return 0;
}
