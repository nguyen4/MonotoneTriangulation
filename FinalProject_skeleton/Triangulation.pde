ArrayList<Edge> Triangulate(Polygon poly) {
  
  // Triangulations 
  ArrayList<Edge> diagonals = new ArrayList<Edge>();
  
  if (poly.isClosed()) {
    // WORKS ONLY FOR CCW POLYGON!
    // Ordered V's (top to bottom)
    ArrayList<Integer> orderedPoints = new ArrayList<Integer>();
    orderedPoints = poly.orderedPointsPos(poly.p);
    
    // Index and point of V and V+
    int originalPosV, originalPosVPlus;
    boolean earCuttingOccured = false;
    int lastPoint = -1;
    
    Point v, vPlus;
    
    // Reflex Chain
    ArrayList<Integer> reflexChain = new ArrayList<Integer>();
    
    // Keep track of reflex / convex V+
    Triangle testVPlus; // for Case 2 and Case 3

    // Second from top of reflex chain for Case 1
    Point secondFromTopP;
    
    // Second from bottom of reflex chain for Case 2
    Point secondFromBottomP;
    
    for (int i = 0; i < orderedPoints.size()-1; i++) {
     // Store V
     originalPosV = orderedPoints.get(i);
     v = poly.p.get(originalPosV); 
     
     // Store V+ (appropriately)
     if (i == 0) {
       originalPosVPlus = orderedPoints.get(orderedPoints.size()-1);
     } else {
       originalPosVPlus = orderedPoints.get(i - 1);
     }
     
     // Store V+ after getting appropriate index
     vPlus = poly.p.get(originalPosVPlus);
     int neighbor1Pos, neighbor2Pos;
    
     // Insert first 2 V's
     if (i == 0 || i == 1) {
       reflexChain.add(originalPosV);
     }
     
     // Focus on rest of V's
     if (i >= 2) {
       // case 1 -- check if v is opposite reflex chain
       // (compare v with last added v in chain)
       if ((originalPosV+1)%poly.p.size() != (reflexChain.get(reflexChain.size()-1)) && originalPosV != ((reflexChain.get(reflexChain.size()-1))+ 1)%poly.p.size()) {
         println("CASE 1");
         while (reflexChain.size() > 1) {
           
           // store second from top point in vertex
           secondFromTopP = new Point(poly.p.get(reflexChain.get(1)).p);
           
           // * create diagonal from v to second vertex from top of chain
           if ((originalPosV+1)%poly.p.size() != (reflexChain.get(1)) && originalPosV != ((reflexChain.get(1))+ 1)%poly.p.size()) {
             diagonals.add(new Edge(v, secondFromTopP));
             // ----------------------------------------
             earCuttingOccured = true;
             lastPoint = reflexChain.get(reflexChain.size()-2);
           }
           
           // * remove top of chain
           reflexChain.remove(0);       
         }
         
         // * if chain has only 1 element, add v then advance (for loop takes care of the advance v)
         reflexChain.add(originalPosV);
         
       }
       
       // case 2 and 3 
       if ((originalPosV+1)%poly.p.size() == (reflexChain.get(reflexChain.size()-1)) ||  originalPosV == ((reflexChain.get(reflexChain.size()-1))+ 1)%poly.p.size()) {
  
         //// need to check for STRICT CONVEXITY
         //// check if v+ is convex -------------------------------------------------------------------------------------------------------------------------------------------------------------
         
         // Get first neighbor
         if (originalPosVPlus == 0) {
          neighbor1Pos = poly.p.size() - 1; 
         } else {
          neighbor1Pos = (originalPosVPlus - 1) % poly.p.size();
         }
         // get current point's 2nd neighbor
         neighbor2Pos = (originalPosVPlus + 1) % poly.p.size();
         
         
         if (earCuttingOccured) {
           testVPlus = new Triangle(poly.p.get(lastPoint), vPlus, poly.p.get(neighbor2Pos)); 
           // println(lastPoint + "       " + originalPosVPlus + "           " + neighbor2Pos);
         } else {
           testVPlus = new Triangle(poly.p.get(neighbor1Pos), vPlus, poly.p.get(neighbor2Pos)); 
           // println(neighbor1Pos + "    *   " + originalPosVPlus + "      *     " + neighbor2Pos);
         }
         
         // case 2 -- check if v is adjacent to bottom of reflex chain and v+ is strictly convex
         // if triangle is ccw in ccw polygon, it is convex
         if (testVPlus.ccw()) {
           println("CASE 2");
           // store second from bottom 
           secondFromBottomP = new Point(poly.p.get(reflexChain.get(reflexChain.size()-2)).p);
           
           // * draw diagonal from v to second vertex
           if ((originalPosV+1)%poly.p.size() != (reflexChain.get(reflexChain.size()-2)) && originalPosV != ((reflexChain.get(reflexChain.size()-2))+ 1)%poly.p.size()) {
             diagonals.add(new Edge(v, secondFromBottomP));
             // ----------------------------------------2
             earCuttingOccured = true;
             lastPoint = reflexChain.get(reflexChain.size()-2);
           }
           
           
           // * remove bottom of chain
           reflexChain.remove(reflexChain.size()-1);
           
           // * add v then advance (for loop takes care of the advance v)
           reflexChain.add(originalPosV);
           
         }
         
         // case 3 -- check if v is adjacent to bottom of reflex chain and v+ is reflex or flat
         // else if if cw, it is concave
         else if (testVPlus.cw()) {
           // * add v to chain, advance v at end of loop
           reflexChain.add(originalPosV);
  
         } else { // it is straight line
           // * add v to chain, advance v at end of loop
           reflexChain.add(originalPosV);
         }
       }
     }
    }
    
    
    // Last vertex is special case, connect to all in chain
    originalPosV = orderedPoints.get(orderedPoints.size()-1);
    v = poly.p.get(originalPosV);
    
    // Connect all points until chain has 1 left
    while (reflexChain.size() > 1) {
      boolean containsBdry = false;
      // Avoid connecting to adjacent edges
      if ((originalPosV+1)%poly.p.size() == (reflexChain.get(0)) || originalPosV == ((reflexChain.get(0))+ 1)%poly.p.size()) {
        
      } else {
        // -- SPECIAL CASE
        // check if imaginary diagonal intersects with any of the boundarys
        // get all boundarys of polygon
        ArrayList<Edge> bdry = poly.getBoundary();
        // imaginary diag
        Edge diagI = new Edge(v, new Point(poly.p.get(reflexChain.get(0)).p));
        Edge bdryC = new Edge(new Point(0.0,0.0), new Point(0.0,0.0));
        Point intersectP = new Point(0.0,0.0);
        
        for (int i = 0; i < bdry.size(); i++) {
          
          bdryC = bdry.get(i);
         
         
         // Check if boundary is adjacent to diagonal
         // and excuse intersections with vertices
         if (diagI.p0.p.x == bdryC.p0.p.x && diagI.p0.p.y == bdryC.p0.p.y ||
             diagI.p1.p.x == bdryC.p1.p.x && diagI.p1.p.y == bdryC.p1.p.y ||
             diagI.p0.p.x == bdryC.p1.p.x && diagI.p0.p.y == bdryC.p1.p.y ||
             diagI.p1.p.x == bdryC.p0.p.x && diagI.p1.p.y == bdryC.p0.p.y) {
             continue;      
         }
         
         // Intersection test
         if (diagI.intersectionTest(bdryC)) {
           
           intersectP = diagI.intersectionPoint(bdryC);
           
           if(intersectP != null) {
             containsBdry = true; 
           }
         }
        }
        
       // if diagonal lies outside with no intersections
       if (!poly.pointInPolygon(diagI.midpoint())) {
         containsBdry = true;
       }
        if (!containsBdry)
        {
          diagonals.add(new Edge(v, new Point(poly.p.get(reflexChain.get(0)).p)));
        }
        
      }
      // remove top in chain
      reflexChain.remove(0);
    }
  }
  
  return diagonals;
}
