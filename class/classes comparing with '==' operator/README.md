## '==' It compares the object handles, not the contents of the objects.
## So a == b checks if both handles point to the exact same object in memory, not if the objects have the same field values.

## Ex:
```
class packet;
  
  int data;
  
endclass

module tb;
  
  packet p1, p2, p3;
  
  initial begin
    
    p1 = new();
    p2 = new();
    p3 = p1;
    
    p1.data = 100;
    p2.data = 100;
    
    $display("p1 == p2 : %0d", p1 == p2);   // 0 -> as p1 & p2 are pointing to 2 different objects in  memory 
    $display("p1 == p3 : %0d", p1 == p3);   // 1 -> as p1 & p3 are pointing to same object in  memory 
    $display("p1.data == p2.data : %0d", p1.data == p2.data);   // 1 -> as p1.data & p2.data are comparing for object values 
    
  end
  
endmodule

//Output
p1 == p2 : 0
p1 == p3 : 1
p1.data == p2.data : 1
```
