ArrayList<Edge> Triangulate(Polygon poly) {
  
  // Triangulations 
  ArrayList<Edge> diagonals = new ArrayList<Edge>();
  
  if (poly.isClosed()) {
    // WORKS ONLY FOR CCW POLYGON!
    
    // Ordered V's (top to bottom)
    ArrayList<Integer> orderedPoints = new ArrayList<Integer>();
    orderedPoints = poly.orderedPointsPos(poly.p);
    
    // create copy of points to simulate polygon after ear cutting
    ArrayList<Point> pointsCopy = new ArrayList<Point>();
    for (int a = 0; a < poly.p.size(); a++) {
      pointsCopy.add(new Point(poly.p.get(a).p.x, poly.p.get(a).p.y));  
    }
    
    // Index and point of V and V+
    int originalPosV, originalPosVPlus;    
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
         
         while (reflexChain.size() > 1) {
           
           // store second from top point in vertex
           secondFromTopP = new Point(poly.p.get(reflexChain.get(1)).p);
           
           // * create diagonal from v to second vertex from top of chain
           if ((originalPosV+1)%poly.p.size() != (reflexChain.get(1)) && originalPosV != ((reflexChain.get(1))+ 1)%poly.p.size()) {
             diagonals.add(new Edge(v, secondFromTopP));
             
           }

           // ** adjust copyPoints (simulate ear clipping)
           if (reflexChain.size() > 0) {
             if (originalPosV == 0) {
               pointsCopy.set((poly.p.size() - 1), poly.p.get(reflexChain.get(1)));
             } else {
               pointsCopy.set((originalPosV - 1), poly.p.get(reflexChain.get(1)));
             }
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
         
         if (originalPosVPlus == 0) {
          neighbor1Pos = poly.p.size() - 1; 
         } else {
          neighbor1Pos = (originalPosVPlus - 1) % poly.p.size();
         }
          
         // get current point's 2nd neighbor
         neighbor2Pos = (originalPosVPlus + 1) % poly.p.size();
         
         testVPlus = new Triangle(pointsCopy.get(neighbor1Pos), vPlus, poly.p.get(neighbor2Pos)); 
         
         // case 2 -- check if v is adjacent to bottom of reflex chain and v+ is strictly convex
         // if triangle is ccw in ccw polygon, it is convex
         if (testVPlus.ccw()) {
         
           // store second from bottom 
           secondFromBottomP = new Point(poly.p.get(reflexChain.get(reflexChain.size()-2)).p);
           
           // * draw diagonal from v to second vertex
           if ((originalPosV+1)%poly.p.size() != (reflexChain.get(reflexChain.size()-2)) && originalPosV != ((reflexChain.get(reflexChain.size()-2))+ 1)%poly.p.size()) {
             diagonals.add(new Edge(v, secondFromBottomP));
              
           }
           
           
           // ** adjust copyPoints (simulate ear clipping)
           if (reflexChain.size() > 1) {
             if (originalPosV == 0) {
               pointsCopy.set((poly.p.size() - 1), poly.p.get(reflexChain.get(reflexChain.size()-2)));
             } else {
               pointsCopy.set((originalPosV - 1), poly.p.get(reflexChain.get(reflexChain.size()-2)));
             }
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
      // Avoid connecting to adjacent edges
      if ((originalPosV+1)%poly.p.size() == (reflexChain.get(0)) || originalPosV == ((reflexChain.get(0))+ 1)%poly.p.size()) {
        
      } else {
        diagonals.add(new Edge(v, new Point(poly.p.get(reflexChain.get(0)).p)));
      }
      
      // remove top in chain
      reflexChain.remove(0);
    }
  }
  
  return diagonals;
}
