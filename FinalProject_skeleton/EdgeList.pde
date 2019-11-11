class EdgeList {
  ArrayList<Edge> list = new ArrayList<Edge>();
  
  void removeEdge(Edge e){
    
    for (int i = 0; i < list.size(); i++)
    {
      if (e.equals(list.get(i)))
      {
        list.remove(i);
        //println("Removed an edge ");
        return;
      }
    }
  }
  
  void addEdge(Edge e){
    list.add(e);
  }
  
  void quickSort(float y){
    Sort(y, 0, list.size()-1);
    
  }
  void Sort(float y, int left, int right){
    
    if (left >= right)
      return;
      
    float pivot = list.get( (left + right) / 2).sweep_x_pos(y);
    
    int index = partition(y, left, right, pivot);
    
    Sort(y, left, index-1);
    Sort(y, index, right);
  }
  
  int partition(float y, int left, int right, float pivot) {
        
        while (left <= right){
            while (list.get(left).sweep_x_pos(y) < pivot) {
                left++;
            }
            
            while (list.get(right).sweep_x_pos(y) > pivot){
                right--;
            }
            
            if (left <= right) {
                Collections.swap(list, left, right);
                left++;
                right--;
            }
        }
        return left;
    } 
}
