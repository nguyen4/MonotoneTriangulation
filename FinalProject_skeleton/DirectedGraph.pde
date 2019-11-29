public class DirectedGraph {
    
    ArrayList<LinkedList<Point>> adjList;
    
    DirectedGraph (Polygon poly, ArrayList<Point> p, LinkedList<Edge> diag) 
    {
        adjList = new ArrayList<LinkedList<Point>>();
        
        if (poly.ccw){ initCcwGraph (p); }
        if (poly.cw) { initCwGraph  (p); }
        addDiagToGraph(diag);
        
    }
    
    void initCcwGraph (ArrayList<Point> p) 
    {
      for (int i = 0; i < p.size(); i++){
        LinkedList<Point> newList = new LinkedList<Point>();
        newList.add(p.get(i));
        newList.add(p.get((i + 1) % p.size()));
        adjList.add(newList);
      }
    }
    
    void initCwGraph (ArrayList<Point> p) 
    {
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
    
    void addDiagToGraph (LinkedList<Edge> diag) 
    {
      Point a, b;
      a = diag.get(i).p0;
      b = diag.get(i).p1;
      
      for (int j = 0; j < adjList.size(); j++){
        if (a.equals( adjList.get(j).get(0))){
          adjList.get(j).add(b);
        }
        else if (b.equals( adjList.get(j).get(0)) ){
          adjList.get(j).add(a);
        }
      }
    }
    
    LinkedList getNeighbors(Point p)
    {
     
      for (int i = 0; i < adjList.size(); i++){
       if (p.equals(adjList.get(i).get(0))){
         return adjList.get(i);
       }
       
     }
     
     return null;
   }
   
   boolean exists(Point p)
   {
     
     for (int i = 0; i < adjList.size(); i++){
       if (p.equals(adjList.get(i).get(0))){ return true; }
     }
     return false;
     
   }
   
   void BEGONYATHOT(Point start, Point end)
   {
     
     for (int i = 0; i < adjList.size(); i++){
       if (start.equals( adjList.get(i).get(0) )){
         adjList.get(i).remove(end);
       }
       if (adjList.get(i).size() <= 1){
         adjList.remove(i);
       }
     }
   }
    
   void draw()
   {
    
     for (int i = 0; i < adjList.size(); i++){
       adjList.get(i).get(0).draw();
       for (Point p : adjList.get(i)){
         Edge e = new Edge(adjList.get(i).get(0), p);
         e.draw();
       }
     }
   }
   
   public void print() 
   {
       for (int i = 0; i < adjList.size(); i++)
       {
           if (adjList != null)
           {
               println(adjList.get(i).toString());
           }
       }
   }
}


//class DirectedGraph {

//  ArrayList<LinkedList<Point>> adjList;
  
//  DirectedGraph(ArrayList<Point> p, LinkedList<Edge> diag){
    
//    adjList = new ArrayList<LinkedList<Point>>();
    
//    // initialize graph with the points of the Polygon first
//    if (poly.ccw()){ //decrement array
//      for (int i = 0; i < p.size(); i++){
//        LinkedList<Point> newList = new LinkedList<Point>();
//        newList.add(p.get(i));
//        newList.add(p.get((i + 1) % p.size()));
//        adjList.add(newList);
//      }
//    }
//    if (poly.cw()) { //increment array 
//     for (int i = 0; i < p.size(); i++){
//        LinkedList<Point> newList = new LinkedList<Point>();
//        newList.add(p.get(i));
//        if (i == 0)
//          newList.add(p.get(p.size() - 1));
//        else {
//          newList.add(p.get(i - 1));
//        }
//        adjList.add(newList);
//      }
//    }
    
//    // add the points of diagonals created from split and merge vertices;
    
//    for (int i = 0; i < diag.size(); i++){
//      Point a, b;
//      a = diag.get(i).p0;
//      b = diag.get(i).p1;
//      for (int j = 0; j < adjList.size(); j++){
//        if (a.equals( adjList.get(j).get(0))){
//          adjList.get(j).add(b);
//        }
//        else if (b.equals( adjList.get(j).get(0)) ){
//          adjList.get(j).add(a);
//        }
//      }
//    }
//  }
  
//  void draw(){
    
//     for (int i = 0; i < adjList.size(); i++){
//       adjList.get(i).get(0).draw();
//       for (Point p : adjList.get(i)){
//         Edge e = new Edge(adjList.get(i).get(0), p);
//         e.draw();
//       }
//     }
//   }
   
//   boolean exists(Point p){
     
//     for (int i = 0; i < adjList.size(); i++){
//       if (p.equals(adjList.get(i).get(0))){ return true; }
//     }
//     return false;
     
//   }
   
//   LinkedList getNeighbors(Point p){
//     for (int i = 0; i < adjList.size(); i++){
//       if (p.equals(adjList.get(i).get(0))){
//         return adjList.get(i);
//       }
//     }
     
//     return null;
//   }
   
//   void BEGONYATHOT(Point start, Point end){
     
//     for (int i = 0; i < adjList.size(); i++){
//       if (start.equals( adjList.get(i).get(0) )){
//         adjList.get(i).remove(end);
//       }
//       if (adjList.get(i).size() <= 1){
//         adjList.remove(i);
//       }
//     }
//   }
   
//   void printDirectedGraph() {
     
//     for (int i = 0; i < adjList.size(); i++){
//       if (adjList != null){
//         // print((i+1));
//       }
//       for (int j = 1; j < adjList.get(i).size(); j++){
//         if (adjList.get(i) != null){
//           // print("->" + (j+1));
//         }
//       }
//       // println();
//     }
//   }
//}
