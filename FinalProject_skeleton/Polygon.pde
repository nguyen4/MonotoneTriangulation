

class Polygon {
  
   ArrayList<Point> p     = new ArrayList<Point>();
   ArrayList<Edge>  bdry  = new ArrayList<Edge>();
   boolean ccw            = false;
   boolean cw             = false;
     
   Polygon( ){  }
   
   
   boolean isClosed(){ return p.size()>=3; }

   boolean isSimple(){
     // TODO: Check the boundary to see if it is simple or not.
     ArrayList<Edge> bdry = getBoundary();
     
     // VIVIEN
     Point arbPoint = new Point(0.0,0.0);
     Edge currentEdge = new Edge(arbPoint, arbPoint);
     Edge otherEdge = new Edge(arbPoint, arbPoint);
     
     for (int i = 0; i < bdry.size(); i++) {
       
       currentEdge = bdry.get(i);
       // skip to i + 2 edge, since adjacent edge doesn't matter
       for (int j = i + 2; j < bdry.size(); j++) {
         otherEdge = bdry.get(j);
         
         // if first edge is compared with last
         if (j == (bdry.size()-1) && i == 0) {
          continue; 
         }
         
         if (currentEdge.intersectionTest(otherEdge)) {
          return false; 
         }
       }
     }
     return true;
   }
   
   
   boolean pointInPolygon( Point p ){
     // TODO: Check if the point p is inside of the 
     //ArrayList<Edge> bdry = getBoundary();
      
     // Make another "endpoint". Drag end of "ray" to "infinity" but make y constant
     Point infP = new Point(10000000.0, p.p.y);
     
     Edge infRay = new Edge(p, infP);
     Point intersectP = new Point(0.0,0.0);
     Edge currentEdge = new Edge(intersectP, intersectP);
     int edgeIntersect = 0;
     
     // Loop through all possible edges
     int i = 0;
     while (i < bdry.size()) {
       //FIXME println((i + 1) + "th iteration num of intersections: " + edgeIntersect);
       
       currentEdge = bdry.get(i);

       // if there are any intersections evaulate
       if (currentEdge.intersectionTest(infRay)) {
         //FIXME println("possible intersection found");
         // if there are any intersections get point to evalate edges on right of point
         intersectP = currentEdge.intersectionPoint(infRay);
         
         
         // Make sure imaginary ray does not count vertexes, if vertex found start over
         if (intersectP != null && (intersectP.p.y == bdry.get(i).p0.p.y || intersectP.p.y == bdry.get(i).p1.p.y)) {
           // increase y endpoint of ray
           infRay.p1.p.y+=50;
           // start over
           i = 0; //GAAAAAAAAAAAAH
           edgeIntersect = 0;
           continue;
         }
         edgeIntersect++;
       }
       i++;
     }
     // if number of intersections with edges is odd (after all special cases handled), point is in polygon
     if ((edgeIntersect % 2) == 1) {
       println("Point is in polygon");
       return true;
     }
     println("Point is not in polygon");
     return false;
   }
   
   
   ArrayList<Edge> getDiagonals(){
     // TODO: Determine which of the potential diagonals are actually diagonals
     ArrayList<Edge> bdry = getBoundary();
     ArrayList<Edge> diag = getPotentialDiagonals();
     ArrayList<Edge> ret  = new ArrayList<Edge>();
     
     // make arb point and edges
     Point arbPoint = new Point(0.0,0.0);
     Edge diagC = new Edge(arbPoint, arbPoint);
     Edge bdryC = new Edge(arbPoint, arbPoint);
     Point intersectP = new Point(0.0,0.0);
     
     // compare diagonal with intersection of all boundaries
     // for each diagonal check intersection with boundaries (from first point, check intersection)
     for (int i = 0; i < diag.size(); i++) {
       boolean containsBoundary = false;
       diagC = diag.get(i);
       for (int j = 0; j < bdry.size(); j++) {
         bdryC = bdry.get(j);
         
         
         // Check if boundary is adjacent to diagonal
         // and excuse intersections with vertices
         if (diagC.p0.p.x == bdryC.p0.p.x && diagC.p0.p.y == bdryC.p0.p.y ||
             diagC.p1.p.x == bdryC.p1.p.x && diagC.p1.p.y == bdryC.p1.p.y ||
             diagC.p0.p.x == bdryC.p1.p.x && diagC.p0.p.y == bdryC.p1.p.y ||
             diagC.p1.p.x == bdryC.p0.p.x && diagC.p1.p.y == bdryC.p0.p.y) {
             continue;      
         }
         
         if (diagC.intersectionTest(bdryC)) {
           
           intersectP = diagC.intersectionPoint(bdryC);
           
           if(intersectP != null) {
             containsBoundary = true; 
           }
         }
       }
       // if diagonal lies outside with no intersections
       if (!pointInPolygon(diagC.midpoint())) {
         containsBoundary = true;
       }
       if (!containsBoundary) {
         ret.add(diagC);
       }
       
     }
     return ret;
   }
   
   
   boolean ccw(){
    // TODO: Determine if the polygon is oriented in a counterclockwise fashion
    // VIVIEN
    // sum over edges (x2 - x1)(y2 + y1)
    double sumOfEdges = 0;
    for (Edge e : bdry ) {
    // println("*: ", e.p0.p.x);
    sumOfEdges += (e.p1.p.x - e.p0.p.x)*(e.p1.p.y + e.p0.p.y);
    }
    if (sumOfEdges < 0) {
     return true; 
    }
    if( !isClosed() ) return false;
    if( !isSimple() ) return false;
    return false;
   }
   
   
   boolean cw(){
    // TODO: Determine if the polygon is oriented in a clockwise fashion
    // sum over edges (x2 - x1)(y2 + y1)
    double sumOfEdges = 0;
    for (Edge e : bdry ) {
    // println("*: ", e.p0.p.x);
    sumOfEdges += (e.p1.p.x - e.p0.p.x)*(e.p1.p.y + e.p0.p.y);
    }
    if (sumOfEdges > 0) {
     return true; 
    }
    if( !isClosed() ) return false;
    if( !isSimple() ) return false;     
    return false;
   }
      
   
   
   
   ArrayList<Edge> getBoundary(){
     return bdry;
   }


   ArrayList<Edge> getPotentialDiagonals(){
     ArrayList<Edge> ret = new ArrayList<Edge>();
     int N = p.size();
     for(int i = 0; i < N; i++ ){
       int M = (i==0)?(N-1):(N);
       for(int j = i+2; j < M; j++ ){
         ret.add( new Edge( p.get(i), p.get(j) ) );
       }
     }
     return ret;
   }
   

   void draw(){
     //println( bdry.size() );
     for( Edge e : bdry ){
       e.draw();
     }
   }
   
   
   void addPoint( Point _p ){ 
     p.add( _p );
     if( p.size() == 2 ){
       bdry.add( new Edge( p.get(0), p.get(1) ) );
       bdry.add( new Edge( p.get(1), p.get(0) ) );
     }
     if( p.size() > 2 ){
       bdry.set( bdry.size()-1, new Edge( p.get(p.size()-2), p.get(p.size()-1) ) );
       bdry.add( new Edge( p.get(p.size()-1), p.get(0) ) );
     }
   }
   
   boolean isConvex(){
     // IS POLYGON CONVEX OR NOT
     //// pick bottom most point and rightmost point for animation
     //float minY = 800, maxX = -1;
     //int minYPos = 0, maxXPos = 0;
     //for (int i = 0; i < points.size(); i++) {
     //  // max X
     //  if (points.get(i).p.x > maxX) {
     //    maxX = points.get(i).p.x;
     //    maxXPos = i;
     //  }
       
     //  // minY
     //  if (points.get(i).p.y < minY) {
     //    minY = points.get(i).p.y;
     //    minYPos = i;
     //  }
     //}
     
     Point arbPoint = new Point(0.0,0.0);
     Triangle test = new Triangle(arbPoint, arbPoint, arbPoint);
     // mark boolean
     boolean gotNeg = false;
     boolean gotPos = false;
     
     // actual algorithm? (i, j , k)
     int j, k;
     for (int i = 0; i < points.size(); i++) {
       j = (i + 1) % points.size(); // second point
       k = (j + 1) % points.size(); // third point
       
       // Update all points
       test.p0 = points.get(i);
       test.p1 = points.get(j);
       test.p2 = points.get(k);
       if (test.ccw()) {
         gotPos = true;
       } else if (test.cw()) {
         gotNeg = true;        
       }
       
       if (gotPos && gotNeg) return false;
     }
     return true;
   }
   boolean isYMonotone() {
     
     int bothNeg = 0;
     int bothPos = 0;
     
     // actual algorithm? (i, j , k)
     int j, k;
     for (int i = 0; i < points.size(); i++) {
       j = (i + 1) % points.size(); // second point
       k = (j + 1) % points.size(); // third point
       
       if (points.get(j).p.y < points.get(i).p.y && points.get(j).p.y < points.get(k).p.y) {
         // println("i Pos: " +  i + "   " + "j Pos: " +  j + "   " + "k Pos: " +  k);
         bothNeg++;
       } else if (points.get(j).p.y > points.get(i).p.y && points.get(j).p.y > points.get(k).p.y) {
         // println("i Neg: " +  i + "   " + "j Neg: " +  j + "   " + "k Neg: " +  k);
         bothPos++; 
       }
     }
     //println("bothNeg: ", bothNeg);
     //println("bothPos: ", bothPos);
     if (bothNeg >= 2 || bothPos >=2) {
       return false;
     }
     return true; 
   }
   
   boolean isXMonotone() {
     
     int bothNeg = 0;
     int bothPos = 0;
     
     // actual algorithm? (i, j , k)
     int j, k;
     for (int i = 0; i < points.size(); i++) {
       j = (i + 1) % points.size(); // second point
       k = (j + 1) % points.size(); // third point
       
       if (points.get(j).p.x < points.get(i).p.x && points.get(j).p.x < points.get(k).p.x) {
         bothNeg++;
       } else if (points.get(j).p.x > points.get(i).p.x && points.get(j).p.x > points.get(k).p.x) {
         bothPos++; 
       }
     }
     if (bothNeg >= 2 || bothPos >=2) {
       return false;
     }
     return true; 
   }
   ArrayList<Integer> orderedPointsPos() {
     Point key1 = new Point(0.0,0.0);
     
     // Ordered points
     ArrayList<Point> orderedPoints = new ArrayList<Point>();
     // Ordered point position (in relation to original point list)
     ArrayList<Integer> orderedPointPos = new ArrayList<Integer>();
     
     
     for (int i = 0; i < points.size(); i++) {
      orderedPoints.add(new Point(points.get(i).p.x, points.get(i).p.y)); 
      orderedPointPos.add(i);
     }

     for (int i = 1; i < orderedPoints.size(); ++i) {
      key1.p = orderedPoints.get(i).p;
      int j = i - 1;
      while (j >=0 && orderedPoints.get(j).p.y < key1.p.y) {
       orderedPoints.get(j + 1).p = orderedPoints.get(j).p;
       Collections.swap(orderedPointPos, j+1, j);
       
       j = j - 1;
      }
      orderedPoints.get(j+1).p = key1.p;
      
     }
     
     for (int i = 0; i < orderedPoints.size(); i++) {
      //println(i + ": * " + points.get(i).p.y); 
      //println(i + ":   " + orderedPoints.get(i).p.y);
      println(i + ": & " + (orderedPointPos.get(i)+1));
     }
     return orderedPointPos;
   } 
   
boolean edgeExists(Edge e){
     
    for (int i = 0; i < bdry.size(); i++){
      /*
      if (e.p0.getX() == bdry.get(i).p0.getX() && e.p0.getY() == bdry.get(i).p0.getY() &&
          e.p1.getX() == bdry.get(i).p1.getX() && e.p1.getY() == bdry.get(i).p1.getY() ||
          e.p0.getX() == bdry.get(i).p1.getX() && e.p0.getY() == bdry.get(i).p1.getY() &&
          e.p1.getX() == bdry.get(i).p0.getX() && e.p1.getY() == bdry.get(i).p0.getY())
          {
            return true;
          }
          */
      if (e.p0.equals( bdry.get(i).p0 ) && e.p1.equals( bdry.get(i).p1 ) ||
          e.p1.equals( bdry.get(i).p0 ) && e.p0.equals( bdry.get(i).p1 ) ) {
          return true;
          }
    }
    
    return false;
  }
}
