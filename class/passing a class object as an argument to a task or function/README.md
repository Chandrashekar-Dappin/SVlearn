## We can pass the class object as an argument to the task or function. but it is 
## 1. pass by reference (as we are passing the handle)
## 2. object value can be modified using task/function (changes made inside these reflect outside)

## Ex:
```
class packet;
  
  int a;
  
  function new(int a);
    this.a = a;
  endfunction
  
  function void display();
    $display("a = %0d" ,a);
  endfunction
  
endclass


module tb;
  
  packet p;
  
  task print(packet pkt);
    //pkt.a = 500;   // modifying the object value relects as it is pass by reference
    pkt.display();
  endtask
  
  initial begin
    p = new(100);
    print(p);
    
  end
  
endmodule
    

///Output
a = 100
```
