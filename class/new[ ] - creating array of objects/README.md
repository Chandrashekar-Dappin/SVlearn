## new[] : it is used to dynamically allocate and initialize an array of class objects.
## new[N]	Creates an array of null handles.
## Manual new()	Required for each element.

## Ex:
```
class packet;
  
  static int ID;
  
  function new();
    ID++;
  endfunction
  
  function void display();
    $display(" memory created for p[%0d]",ID-1);
  endfunction
  
endclass


module tb;
  
  packet p[];
  
  initial begin
    
    p = new[5];     // only creates array of packet handles..object not created yet
    
    foreach(p[i]) begin
      p[i] = new();   // creates object for each handle
      p[i].display();
    end
    
  end
  
endmodule

//Output
 memory created for p[0]
 memory created for p[1]
 memory created for p[2]
 memory created for p[3]
 memory created for p[4]
```
