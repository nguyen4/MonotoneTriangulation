class Event {
  Point P;
  LinkedList<Edge> edges = new LinkedList<Edge>();
  int type;
  int label;
  
  Event(Point P, Edge e1, Edge e2, int type, int label) {
    this.P = P;
    edges.add(e1);
    edges.add(e2);
    this.type = type;
    this.label = label;
  }
}
