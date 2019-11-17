String[] myType = { "Collinear", "Regular", "Start", "End", "Merge", "Split" };

void MonotonePartition(){
  
  //initialize the priorityQueue
  ArrayList<Event> pq = makePQ();
  
  //create an active edge list that stores edges from left to right
  EdgeList ActiveEdges = new EdgeList();
  
  //initialize Attention list of Events for split and merge vertices
  ArrayList<Event> Attention = new ArrayList<Event>();
  
  LinkedList<Edge> splitMerge = new LinkedList<Edge>();
  
  for(int i = 0; i < pq.size(); i++){
    
    int type = pq.get(i).type;
    Event curr = pq.get(i);
    
    if (type == 2)        // if start vertex
    {
      // add both of its edges to the edge list
      for (Edge e : curr.edges){ ActiveEdges.addEdge(e); }
    }
     
    else if (type == 3)   // else if end vertex
    {
      // rm both of its edges from the edge list
      for (Edge e: curr.edges){ ActiveEdges.removeEdge(e); }
    }
     
    else if (type == 1)   // else if reg vertex
    {
      try {
        // rm edge above vertex and add edge below it to edge list
        Point edge1_EndPoint = curr.edges.get(0).p0;
        Edge edgeToRemove, edgeToAdd;
        
        /* if the first endpoint of edge 1 is not the same as the current point
          * then the second endpoint must be used to check edge 1's y position
        */
        if (!edge1_EndPoint.equals(curr.P)){
          edge1_EndPoint = curr.edges.get(0).p1;
        }
        
        /* if the y endpoint of edge 1 higher than the current point, 
          then we will delete edge 1 and add edge 2 to the ActiveEdges, otherwise,
          we will delete edge 2 and add edge 1 to ActiveEdges
        */
        if (edge1_EndPoint.p.y > curr.P.getY()){
          edgeToRemove = curr.edges.get(0);
          edgeToAdd = curr.edges.get(1);
        } else {
          edgeToRemove = curr.edges.get(1);
          edgeToAdd = curr.edges.get(0);        
        }
        
        ActiveEdges.removeEdge(edgeToRemove);
        ActiveEdges.addEdge(edgeToAdd);
        
      } catch (Exception e)
      {
        System.out.println("Something went wrong in regular vertex processing");
      }
    }
    
    else if (type == 4) //else if merge
    {
      //remove both of its edges of merge vertex from ActiveEdges list add the event to the Attention list
      for (Edge e : curr.edges) { ActiveEdges.removeEdge(e); }
      Attention.add(curr);
      println("Done");
      
    }
    
    else if (type == 5) // else if split
    {
      //add both of its edges to the ActiveEdges list and add event to Attention list
      for (Edge e : curr.edges) { ActiveEdges.addEdge(e); }
      Attention.add(curr);
    }
    
    ActiveEdges.quickSort(curr.P.getY());
    
    for (int j = 0; j < Attention.size(); j++)
    {
      if (Attention.get(j).type == 4){
        Edge newEdge = merge_Helper(curr, Attention.get(j));
        if (newEdge != null){
          poly.bdry.add(newEdge);
          splitMerge.add(newEdge);
          Attention.remove(j);
        }
      }
      else if (Attention.get(j).type == 5){
        Edge newEdge = split_Helper(i, pq, Attention.get(j));
        if (newEdge != null){
          poly.bdry.add(newEdge);
          splitMerge.add(newEdge);
          Attention.remove(j);
        }
      }
    }
  }
  
  if(splitMerge.size() > 0);
      Partition(splitMerge);
  //return sub polygons
  
} 

ArrayList<Polygon> Partition(LinkedList<Edge> diagList){
  
  if (diagList.size() == 0) { return null; }
  
  ArrayList<Polygon>  subPolygons = new ArrayList<Polygon>();
  ArrayList<Point>    newCycle;
  Point               curr;
  
  /*
    create a directed graph
  */
  dG = new DirectedGraph(poly.p, diagList);
  state = 1;
  
  ArrayList<Point> stack = new ArrayList<Point>();
  
  //this may create duplicates in the stack
  for (Edge e : diagList){
    stack.add(e.p0);
    stack.add(e.p1);
  }
  
  while ( stack.size() != 0 ){
    
    if ( !dG.exists( stack.get(0) ) ){
      
      stack.remove(0);
    
    } else {
    
      newCycle = new ArrayList<Point>();
      LinkedList<Point> neighbors = dG.getNeighbors( stack.get(0) );
      newCycle.add( neighbors.get(0) );
      newCycle.add( neighbors.get(1) );
      curr = newCycle.get( newCycle.size()-1 );
      
      while( !curr.equals( newCycle.get( 0 ) ) ){
        
        neighbors = dG.getNeighbors( curr );
        
        if (neighbors.size() > 2){
          Point p = getCcwNeighbor( newCycle.get( newCycle.size() - 2 ), neighbors );
          newCycle.add( p );
        }
        else if (neighbors.size() == 2){
          newCycle.add( neighbors.get( 1 ) );
        }
        else {
          println("error in retrieving neighbors");
        }
        
        curr = newCycle.get( newCycle.size() - 1 );
        
      }
      
      Polygon subPoly = new Polygon();
      
      for (int i = 0; i < newCycle.size(); i++){
        if (i == newCycle.size() - 1){
          dG.BEGONYATHOT( newCycle.get(i-1), newCycle.get(i) );
        }
        else {
          subPoly.addPoint(newCycle.get(i));
          dG.BEGONYATHOT( newCycle.get(i), newCycle.get(i+1) );
          
        }
      }
      
      subPolygons.add(subPoly);
      
    }
  }
  //Start of Algorithm
  /*
    Initialize stack of points from diagList
  */
  
  //Algorithm
  /*
    * If top of stack exists in the polygon
        start a new arrayList AL of points
        add that point and its neighbor to AL
        curr = AL.end
        
    *  While curr and first in AL are not the same
         find neighbors of curr
         
         if neighbors.size > 1
           add neighbor with the smallest ccw angle to AL
         else if neighbores.size == 1
           add neighbor to AL
         else 
           error
         
         curr = next in AL
    
    *  for each point p in AL
         if (end of AL)
           delete edge in DG
         else
           add point to new polygon 
           delete p + 1 in AL from DG
           
         if p in DG is empty, remove from DG
         
       add new polygon to list of polygon
      
  
  */
  
  
  /*
    Find the sub polygons
  */
  return null;
}

Point getCcwNeighbor(Point a, LinkedList<Point> neighbors){
  Point b = neighbors.get(0);
  Point c;
  
  float[] angles = new float[neighbors.size() - 1]; 
  
  for (int i = 1; i < neighbors.size(); i++){
     c = neighbors.get(i);
     Triangle t = new Triangle(a, b, c);
     //find angle
     PVector v1 = PVector.sub( a.p, b.p );
     PVector v2 = PVector.sub( c.p, b.p );
     float angle = PVector.angleBetween(v1, v2);
     
     if (t.ccw()){
       angles[i-1] = angle;
     }
     else if (t.cw()){
       angles[i-1] = 360 - angle;
     }
     else {
       angles[i-1] = 0;
     } 
  }
  
  int minIndex = 0;
  
  for (int i = 1; i < angles.length; i++){
    if (angles[minIndex] > angles[i]){
      minIndex = i;
    }
  }
  
  return neighbors.get(minIndex + 1);
}
   
Edge merge_Helper(Event current, Event merge) {
  
  //make an edge between current and merge point
  Edge newEdge = new Edge(current.P, merge.P);
  if (current.equals(merge))
    return null;
  if (isDiagonal(newEdge)){
    return newEdge;
  }
  return null;
}

Edge split_Helper(int i, ArrayList<Event> pq, Event split) {
  
  Edge newEdge;
  for (int j = i - 1; j >= 0; j--)
  {
    newEdge = new Edge(pq.get(j).P, split.P);
    if (!poly.edgeExists(newEdge)) {
      if (isDiagonal(newEdge)) {
        return newEdge;
      }
    }
  }

  return null;
}

boolean isDiagonal(Edge diag){
  
  ArrayList<Edge> bdry = poly.getBoundary();
     
    //check if edge does not interesect a bdry
    for (int j = 0; j < bdry.size(); j++){
      //if it intersects the boundary
      
      //if the endpoints of the boundary and ray matches, skip
      if(  (diag.p0.p.x == bdry.get(j).p0.p.x && diag.p0.p.y == bdry.get(j).p0.p.y)||
           (diag.p0.p.x == bdry.get(j).p1.p.x && diag.p0.p.y == bdry.get(j).p1.p.y)||
           (diag.p1.p.x == bdry.get(j).p0.p.x && diag.p1.p.y == bdry.get(j).p0.p.y)||
           (diag.p1.p.x == bdry.get(j).p1.p.x && diag.p1.p.y == bdry.get(j).p1.p.y))
        {
          continue;
        }
      
      if(diag.intersectionTest(bdry.get(j))){
        
        Point intersection = diag.intersectionPoint(bdry.get(j));
        
        if (intersection != null) {
          return false;
        }
      }
    }
    
    //check if the edge is in polygon
    if (poly.pointInPolygon(diag.midpoint())) { return true; }
      
  return false;
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
      println("c.p.y: ", c.p.y);
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
