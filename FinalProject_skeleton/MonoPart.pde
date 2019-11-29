String[] myType = { "Collinear", "Regular", "Start", "End", "Merge", "Split" };

LinkedList<Edge> MonotonePartition(){
  
  ArrayList<Event> pq            = makePQ(); //initialize the priorityQueue
  ArrayList<Event> Attention     = new ArrayList<Event>(); //initialize Attention list of Events for split and merge vertices
  ArrayList<Polygon> subPolygons;
  EdgeList ActiveEdges           = new EdgeList(); //create an active edge list that stores edges from left to right
  LinkedList<Edge> splitMerge    = new LinkedList<Edge>();
  
  println("Starting Monotone Partition");
  for(int i = 0; i < pq.size(); i++){
    
    int type = pq.get(i).type;
    Event curr = pq.get(i);
  
    println("Iteration: " + i + " Current pq element: " + (curr.label + 1));
    
    if (type == 2)        // if start vertex
    {
      println("Start: adding both edges");
      // add both of its edges to the edge list
      for (Edge e : curr.edges){ ActiveEdges.addEdge(e); }
    }
     
    else if (type == 3)   // else if end vertex
    {
      println("End: Removing both edges");
      // rm both of its edges from the edge list
      for (Edge e: curr.edges){ ActiveEdges.removeEdge(e); }
    }
     
    else if (type == 1)   // else if reg vertex
    {
      println("Regular: removing top, adding bottom edge");
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
      println("Merge: removing both edges");
      //remove both of its edges of merge vertex from ActiveEdges list add the event to the Attention list
      for (Edge e : curr.edges) { ActiveEdges.removeEdge(e); }
      Attention.add(curr);
    }
    
    else if (type == 5) // else if split
    {
      println("Split: adding both edges");
      //add both of its edges to the ActiveEdges list and add event to Attention list
      for (Edge e : curr.edges) { ActiveEdges.addEdge(e); }
      Attention.add(curr);
    }
    
    ActiveEdges.quickSort(curr.P.getY());
    int j = 0;
    while ( j < Attention.size())
    {
      println("ATTENTION LIST: ");
      for (Event e: Attention){
        e.Print();
      }
      if (Attention.get(j).type == 4){
        println("Handling merge");
        Edge newEdge = merge_Helper(curr, Attention.get(j));
        if (newEdge != null){
          //poly.bdry.add(newEdge);
          splitMerge.add(newEdge);
          Attention.remove(j);
          println("found a new diag for merge");
          continue;
          
        }
      }
      else if (Attention.get(j).type == 5){
        println("Handling split");
        Edge newEdge = split_Helper(i, pq, Attention.get(j));
        if (newEdge != null){
          //poly.bdry.add(newEdge);
          splitMerge.add(newEdge);
          Attention.remove(j);
          println("found a new diag for split");
          continue;
        }
      }
      j++;
    }
  }
  
  
    println("Polygon is now Y-Monotone");
    
    return splitMerge;
  
} 
void removeDuplicates(LinkedList<Edge> list)
{
    for (int i = 0; i < list.size(); i++){
      for (int j = i + 1; j < list.size(); j++){
        if (list.get(i).sameEdge(list.get(j))){
          list.remove(j);
        }
      }
  }
}

ArrayList<Point> makeStack(LinkedList<Edge> list) 
{
  ArrayList<Point> stack = new ArrayList<Point>();
  
  for (Edge e : list){
      stack.add(e.p0);
      stack.add(e.p1);
    }
  
  return stack;
}

ArrayList<Polygon> Partition(LinkedList<Edge> diagList){
  
  if (diagList.size() == 0) { return null; }
  
  ArrayList<Polygon>  subPolygons = new ArrayList<Polygon>();
  ArrayList<Point>    stack       = new ArrayList<Point>();
  ArrayList<Point>    newCycle;
  
  removeDuplicates(diagList);
  
  dG = new DirectedGraph(poly, poly.p, diagList);
  println("Directed graph initialized");
  state = 1;
  dG.print();
  
  stack = makeStack(diagList);
  
  while ( stack.size() != 0 ){
    
    println("Size of Directed Graph: " + dG.adjList.size());
    if ( !dG.exists( stack.get(0) ) )
    {  
      stack.remove(0);
    } 
    else 
    {  
      Polygon subPoly = new Polygon();
      newCycle = findCycle(dG, stack.get(0) );
      
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
      println("created " + subPolygons.size() + " polygons");
    }
  }

  println("Number of sub polygons: " + subPolygons.size());
  return subPolygons;
}

ArrayList<Point> findCycle(DirectedGraph dG, Point firstPoint) {
      
      Point              curr;
      Point              prev;
      ArrayList<Point>   newCycle = new ArrayList<Point>();
      LinkedList<Point>  neighbors = dG.getNeighbors( firstPoint );
       
      prev = neighbors.get(0);
      curr = neighbors.get(1);
      newCycle.add( prev );    //gets current vertex
      newCycle.add( curr );
      
      println("Looking for a cycle");
      //finds a cycle in the graph
      while( !curr.equals( newCycle.get( 0 ) ) )
      { 
        println("Checking the neighbors");
        neighbors = dG.getNeighbors( curr );
        
        if (neighbors.size() > 2){
          Point p = getCcwNeighbor( newCycle.get( 0 ), neighbors );
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
      
    return newCycle;
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
    if (angles[minIndex] == 0){
      continue;
    }
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
    println("going up 1");
    println("Position in pq: " + j);
    newEdge = new Edge(  split.P, pq.get(j).P );
    println("made an edge between " + (split.label + 1) + " and " + (pq.get(j).label + 1));
    if (!poly.edgeExists( newEdge )) {
      println("Edge doesnt exist in polygon");
      if (isDiagonal(newEdge)) {
        return newEdge;
      }
      println("Edge already exists in polygon");
    }
  }
  println("No possible edge for this split");
  return null;
}

boolean isDiagonal(Edge diag){
  
  ArrayList<Edge> bdry = poly.getBoundary();
     
    //check if edge does not interesect a bdry
    for (int j = 0; j < bdry.size(); j++){
      
      //if the endpoints of the boundary and ray matches, skip
      if(  (diag.p0.p.x == bdry.get(j).p0.p.x && diag.p0.p.y == bdry.get(j).p0.p.y)||
           (diag.p0.p.x == bdry.get(j).p1.p.x && diag.p0.p.y == bdry.get(j).p1.p.y)||
           (diag.p1.p.x == bdry.get(j).p0.p.x && diag.p1.p.y == bdry.get(j).p0.p.y)||
           (diag.p1.p.x == bdry.get(j).p1.p.x && diag.p1.p.y == bdry.get(j).p1.p.y))
        {
          continue;
        }
      
      if(diag.intersectionTest( bdry.get(j) )){
      
        Point intersection = diag.intersectionPoint(bdry.get(j));
        
        if (intersection != null) {
          println("intersection occured");
          return false;
        }
      }
    }
    
    print("Checking to see if edge is in polygon");
    //check if the edge is in polygon
    if (poly.pointInPolygon(diag.midpoint())) { println("Point is in Polygon"); return true; }
      
  return false;
}

ArrayList<Event> makePQ() {
  
  ArrayList<Event> pQueue = new ArrayList<Event>();
  ArrayList<Integer> orderedPoints = new ArrayList<Integer>();
  int type;
  Point currPoint;
  
  orderedPoints = poly.orderedPointsPos(poly.p);
  
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
   type = findVertexType(originalPos);
   
   //CREATE NEW EVENT AND ADD TO QUEUE
   Event e = new Event(currPoint, edges.get(0), edges.get(1), type, originalPos);
   pQueue.add(e);
   
  }
  
  return pQueue;
  
}

int findVertexType(int originalPos) {    
  
  int neighbor1Pos;
  
  // get current point's 1st neighbor
  if (originalPos == 0) {
   neighbor1Pos = points.size() - 1; 
  } else {
   neighbor1Pos = (originalPos - 1) % points.size();
  }
  
  // get current point's 2nd neighbor
  int neighbor2Pos = (originalPos + 1) % points.size();
  
  Point c = points.get(originalPos), endPoint1 = points.get(neighbor1Pos), endPoint2 = points.get(neighbor2Pos);
  
  // check if it is a regular vertex
  if (c.p.y > endPoint1.p.y && c.p.y < endPoint2.p.y || c.p.y < endPoint1.p.y && c.p.y > endPoint2.p.y) {
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
  
  // WHEN POLYGON IS CCW
  if (poly.ccw) {
    
    // + + (checking difference between merge and end)
    if (c.p.y < endPoint1.p.y && c.p.y < endPoint2.p.y) {
      test = new Triangle(endPoint1, c, endPoint2);
      if (test.ccw()) {
         return 3;
      } else {
         return 4;
      }
      
      // - - (checking difference between start and split
    } else if (c.p.y > endPoint1.p.y && c.p.y > endPoint2.p.y){
      // check which endpoint is on the left
      test = new Triangle(endPoint1, c, endPoint2);
      if (test.ccw()) {
       return 2;
      } else {
       return 5;
      }
    }
    
    // WHEN POLYGON IS CW
  } else {
    // + + (checking difference between merge and end)
    if (c.p.y < endPoint1.p.y && c.p.y < endPoint2.p.y) {
      println("Found merge/end");
      // check which endpoint is on the left
      test = new Triangle(endPoint1, c, endPoint2);
      if (test.cw()) { return 3; } 
      else           { return 4; }
      // collinear???
      
    // - - (checking difference between start and split
    } else if (c.p.y > endPoint1.p.y && c.p.y > endPoint2.p.y){
      // check which endpoint is on the left
      test = new Triangle(endPoint1, c, endPoint2);
      if (test.cw()) {
        return 2;
      } else {
        return 5;
      }    
    }
  }
  return 0;
}
