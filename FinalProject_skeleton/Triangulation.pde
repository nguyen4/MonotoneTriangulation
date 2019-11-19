ArrayList<Edge> Triangulate() {
  
  ArrayList<Edge> diagonals = new ArrayList<Edge>();
  if (poly.isClosed()) {
    
    
    // WORKS ONly FOR CCW POLYGON!
    ArrayList<Integer> orderedPoints = new ArrayList<Integer>();
    ArrayList<Point> pointsCopy = new ArrayList<Point>();
    
    // create copy of points to simulate polygon after ear cutting
    for (int a = 0; a < points.size(); a++) {
      pointsCopy.add(new Point(points.get(a).p.x, points.get(a).p.y));  
    }
    
    int originalPosV, originalPosVPlus;
    
    Point v, vPlus;
    ArrayList<Integer> reflexChain = new ArrayList<Integer>();
    
    Triangle testVPlus; // for Case 2 and Case 3
    
    orderedPoints = poly.orderedPointsPos();
    
    // Second from top point for Case 1
    Point secondFromTopP;
    
    // Second from bottom point for Case 2
    Point secondFromBottomP;
    
    // println();
    // println("=============================================================");
    for (int i = 0; i < orderedPoints.size()-1; i++) {
     originalPosV = orderedPoints.get(i);
     //println();
     //println("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
     // println("ORIGINALPOSV: " + (originalPosV+1));
     //println();
     
     // int originalPosVPlus = orderedPoints.get(i + 1);
     if (i == 0) {
       originalPosVPlus = orderedPoints.get(orderedPoints.size()-1);
     } else {
       originalPosVPlus = orderedPoints.get(i - 1);
     }
     
     
     v = points.get(originalPosV);
     vPlus = points.get(originalPosVPlus);
     int neighbor1Pos, neighbor2Pos;
     
     
     // print reflex chain
     print("REFLEX CHAIN 1:    ");
     // println("___________________");
     
     
     
     //// access next lower point
     //int nextOriginalPos = (i + 1) % orderedPoints.size();
     if (i == 0 || i == 1) {
       reflexChain.add(originalPosV);
     }
     
     for (int j = 0; j < reflexChain.size(); j++) {
      print((reflexChain.get(j)+1) + " "); 
       
     }
     println();
     
     if (i >= 2) {
       println("i: " + i);
       // case 1 -- check if v is opposite reflex chain
       
       println("ORIGINALPOSV: " + (originalPosV+1) + "           last of reflex chain + 1: " + ((reflexChain.get(reflexChain.size()-1)) + 1));
       // (compare v with last added v in chain)
       if ((originalPosV+1)%points.size() != (reflexChain.get(reflexChain.size()-1)) && originalPosV != ((reflexChain.get(reflexChain.size()-1))+ 1)%points.size()) {
         
         while (reflexChain.size() > 1) {
           println("CASE 1");
           
           // store second from top point in vertex
           secondFromTopP = new Point(points.get(reflexChain.get(1)).p);
           
           // * create diagonal from v to second vertex from top of chain
           if ((originalPosV+1)%points.size() != (reflexChain.get(1)) && originalPosV != ((reflexChain.get(1))+ 1)%points.size()) {
             diagonals.add(new Edge(v, secondFromTopP));
             
             //// draw?
             //strokeWeight(4);
             //stroke(255, 128, 0); // orange
             //diagonals.get(diagonals.size() - 1).draw();
           }
           //println("ADDED EDGE IN CASE 1&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
           
           
           // ** remove from copyPoints
           if (reflexChain.size() > 0) {
             if (originalPosV == 0) {
               pointsCopy.set((points.size() - 1), points.get(reflexChain.get(1)));
             } else {
               pointsCopy.set((originalPosV - 1), points.get(reflexChain.get(1)));
             }
           }
           
           // * remove top of chain
           reflexChain.remove(0);       
         }
         
         // * if chain has only 1 element, add v then advance (for loop takes care of the advance v)
         reflexChain.add(originalPosV);
         
       }
       
       // case 2 and 3 
       if ((originalPosV+1)%points.size() == (reflexChain.get(reflexChain.size()-1)) ||  originalPosV == ((reflexChain.get(reflexChain.size()-1))+ 1)%points.size()) {
  
         //// need to check for STRICT CONVEXITY
         //// check if v+ is convex -------------------------------------------------------------------------------------------------------------------------------------------------------------
         
         if (originalPosVPlus == 0) {
          neighbor1Pos = points.size() - 1; 
         } else {
          neighbor1Pos = (originalPosVPlus - 1) % points.size();
         }
          
         // get current point's 2nd neighbor
         neighbor2Pos = (originalPosVPlus + 1) % points.size();
         
         
         testVPlus = new Triangle(pointsCopy.get(neighbor1Pos), vPlus, points.get(neighbor2Pos));
         // debug triangle output
         println("a: " + (pointsCopy.get(neighbor1Pos)) + "   b: " + vPlus.p.x + " / " + vPlus.p.y + "   c: " + points.get(neighbor2Pos).p.x + " / " + points.get(neighbor2Pos).p.y);
         
         
         // case 2 -- check if v is adjacent to bottom of reflex chain and v+ is strictly convex
         // if triangle is ccw in ccw polygon, it is convex
         if (testVPlus.ccw()) {
           println("CASE 2");
         
           // store second from bottom 
           secondFromBottomP = new Point(points.get(reflexChain.get(reflexChain.size()-2)).p);
           // println("second from bottom: " + secondFromBottomP.p.x + "    " + secondFromBottomP.p.y);
           
           // * draw diagonal from v to second vertex
           if ((originalPosV+1)%points.size() != (reflexChain.get(reflexChain.size()-2)) && originalPosV != ((reflexChain.get(reflexChain.size()-2))+ 1)%points.size()) {
             diagonals.add(new Edge(v, secondFromBottomP));
             
             //// draw?
             //strokeWeight(4);
             //stroke(255, 128, 0); // orange
             //diagonals.get(diagonals.size() - 1).draw();
           }
           
           //println("ADDED EDGE IN CASE 2&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
           
           // ** remove from copyPoints
           if (reflexChain.size() > 1) {
             if (originalPosV == 0) {
               pointsCopy.set((points.size() - 1), points.get(reflexChain.get(reflexChain.size()-2)));
             } else {
               pointsCopy.set((originalPosV - 1), points.get(reflexChain.get(reflexChain.size()-2)));
             }
           }
           
           // * remove bottom of chain
           reflexChain.remove(reflexChain.size()-1);
           
           // * if chain has (at least?) 1 element, add v then advance (for loop takes care of the advance v)
           reflexChain.add(originalPosV);
           
         }
         
         // case 3 -- check if v is adjacent to bottom of reflex chain and v+ is reflex or flat
         // else if if cw, it is concave
         else if (testVPlus.cw()) {
           println("CASE 3");
           // * add v to chain, advance v at end of loop
           reflexChain.add(originalPosV);
  
         } else { // it is straight line
           println("CASE STRAIGHT");
           // * add v to chain, advance v at end of loop
           reflexChain.add(originalPosV);
         }
         
       }
     }
     
    }
    
    
    // Last vertex is special case, connect to all in chain
    originalPosV = orderedPoints.get(orderedPoints.size()-1);
    v = points.get(originalPosV);
    while (reflexChain.size() > 1) {
      println("LAST CASE: ");
      if ((originalPosV+1)%points.size() == (reflexChain.get(0)) || originalPosV == ((reflexChain.get(0))+ 1)%points.size()) {
        
      } else {
        diagonals.add(new Edge(v, new Point(points.get(reflexChain.get(0)).p)));
        
        //// draw?
        //strokeWeight(4);
        //stroke(255, 128, 0); // orange
        //diagonals.get(diagonals.size() - 1).draw();
      }
      
      reflexChain.remove(0);
    }
    
    
    //for (int j = 0; j < reflexChain.size(); j++) {
    // print((reflexChain.get(j)+1) + " "); 
       
    //}
     
    //orderedPoints = poly.orderedPointsPos();
  }
  
  return diagonals;
}
