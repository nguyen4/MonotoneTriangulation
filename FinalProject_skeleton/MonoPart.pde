String[] myType = { "Collinear", "Regular", "Start", "End", "Merge", "Split" };

void MonotonePartition(){
  
  //initialize the priorityQueue
  ArrayList<Event> pq = makePQ();
  
  //create an active edge list that stores edges from left to right
  ArrayList<Edge> ActiveEdges = new ArrayList<Edge>();
  
  //initialize Attention list of Events for split and merge vertices
  ArrayList<Event> Attention = new ArrayList<Event>();
  
  /*while queue not empty
    * check current vertex
    
    * if start
      * add both of its edges to the edge list
    
    * else if end
      * rm both of its edges from the edge list
      
    * else if reg
      * rm edge above vertex and add edge below it to edge list
      
    * else if merge
      * add to Attention list
      
    * else if split
      * add to Attention list
    
    if (Attention is not empty) 
      if merge
        call merge_helper to handle the merge/split vertices issues here
        
      if split
        call split_helper to handle the merge/split vertices issues here
    
  */
} 
      

void merge_Helper(Event current, Event merge) {
  /*
  make an edge between current and merge point
  if edge(or diagonal) is legit and inside polygon
    add that edge to Poly.bdry
    return
  */
  
}

void split_Helper(ArrayList<Event> pq, Event split) {
  /*
  for each event in pq backwards from the element of split
    make an edge between split and that point from event in pq
    if edge is legit and inside polygon
      if edge does not already exists in Poly.bdry
        add to Poly.bdry
        return
  */
}

ArrayList<Event> makePQ() {
  
  ArrayList<Event> pQueue = new ArrayList<Event>();
  ArrayList<Integer> orderedPoints = new ArrayList<Integer>();
  int type;
  Point currPoint;
  
  orderedPoints = poly.orderedPointsPos();
  
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
   
   //FIND TYPE OF VERTEX
   type = findVertexType(orderedPoints, originalPos);
   
   //CREATE NEW EVENT AND ADD TO QUEUE
   Event e = new Event(currPoint, edges.get(0), edges.get(1), type, originalPos);
   pQueue.add(e);
   
  }
  
  // TEST PRINT RUN
  for (int i = 0; i < pQueue.size(); i++) {
   Event e = pQueue.get(i);
   println(e.label+1 + ": " + "Point: " + e.P.toString() + "       " + myType[e.type]);
  }
  println();
  
  return pQueue;
  
}

int findVertexType(ArrayList<Integer> orderedPoints, int originalPos) {    
  
  int neighbor1Pos;
  
  // get current point's 1st neighbor
  // HAVING PROBLEMS CAN YOU FIGURE OUT HOW TO 
  if (originalPos == 0) {
   neighbor1Pos = points.size() - 1; 
  } else {
   neighbor1Pos = (originalPos - 1) % points.size();
  }
  
  // get current point's 2nd neighbor
  int neighbor2Pos = (originalPos + 1) % points.size();
  
  Point c = points.get(originalPos), e1ePoint = points.get(neighbor1Pos), e2ePoint = points.get(neighbor2Pos);
  
  // check if different signs
  if (c.p.y > e1ePoint.p.y && c.p.y < e2ePoint.p.y || c.p.y < e1ePoint.p.y && c.p.y > e2ePoint.p.y) {
    return 1;
  }
  
  Triangle test;
  
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
      // e1e, point c, e2e
      test = new Triangle(e1ePoint, c, e2ePoint);
      if (test.ccw()) {
       return 3;
      } else {
       return 4;
      }
      // collinear???
      
      // - - (checking difference between start and split
    } else if (c.p.y > e1ePoint.p.y && c.p.y > e2ePoint.p.y){
      // check which endpoint is on the left
      // e1e, point c, e2e
      test = new Triangle(e1ePoint, c, e2ePoint);
      if (test.ccw()) {
       return 2;
      } else {
       return 5;
      }
    }
    
    // POLYGON IS CW
  } else {
    // + + (checking difference between merge and end)
    if (c.p.y < e1ePoint.p.y && c.p.y < e2ePoint.p.y) {
      // check which endpoint is on the left
      // e1e, point c, e2e
       test = new Triangle(e1ePoint, c, e2ePoint);
       if (test.cw()) {
         return 3;
       } else {
         return 4;
       }
      
      // collinear???
      
    // - - (checking difference between start and split
    } else if (c.p.y > e1ePoint.p.y && c.p.y > e2ePoint.p.y){
      
      // check which endpoint is on the left
      // e1e, point c, e2e
      test = new Triangle(e1ePoint, c, e2ePoint);
      if (test.cw()) {
        return 2;
      } else {
        return 5;
      }    
    }
  }
  return 0;
}
