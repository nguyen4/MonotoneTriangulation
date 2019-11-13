class DirectedGraph {
  int maxPossiblePolygons; 
  int numVertices;
  ArrayList<LinkedList<Point>> adjList;
  
  DirectedGraph(ArrayList<Point> p, LinkedList<Edge> diag){
    
    adjList = new ArrayList<LinkedList<Point>>();
    
    // initialize graph with the points of the Polygon first
    if (poly.ccw()){ //decrement array
      for (int i = 0; i < p.size(); i++){
        LinkedList<Point> newList = new LinkedList<Point>();
        newList.add(p.get(i));
        newList.add(p.get((i + 1) % p.size()));
        adjList.add(newList);
      }
    }
    if (poly.cw()) { //increment array 
     for (int i = 0; i < p.size(); i++){
        LinkedList<Point> newList = new LinkedList<Point>();
        newList.add(p.get(i));
        if (i == 0)
          newList.add(p.get(p.size() - 1));
        else {
          newList.add(p.get(i - 1));
        }
        adjList.add(newList);
      }
    }
    
    // add the points of diagonals created from split and merge vertices;
    
    for (int i = 0; i < diag.size(); i++){
      Point a, b;
      a = diag.get(i).p0;
      b = diag.get(i).p1;
      for (int j = 0; j < adjList.size(); j++){
        if (a.equals(adjList.get(j).get(0))){
          adjList.get(j).add(b);
        }
        else if (b.equals(adjList.get(j).get(0))){
          adjList.get(j).add(a);
        }
      }
    }
  }
  
  void draw(){
    
     //println( bdry.size() );
     for (int i = 0; i < adjList.size(); i++){
       adjList.get(i).get(0).draw();
       for (Point p : adjList.get(i)){
         Edge e = new Edge(adjList.get(i).get(0), p);
         e.draw();
       }
     }
   }
}
