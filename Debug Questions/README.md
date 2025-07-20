## 1. debug the code
```
class packet;
  
  static int ID = 0;
  int aid =  0;
  
  function new();
    ID++;
    aid++;
    $display("ID = %0d  aid = %0d",ID,aid);
  endfunction
  
  
endclass



class generator;
  
  task start();
    
    packet p = new();
    $display("%0d",p);     // prints address of that object memory
  endtask
  
endclass


module test;
  
  generator gen[4];
  
  initial begin
    
    foreach(gen[i]) begin
      
      gen[i] = new();
      $display(gen[i]);
      
    end
    
    gen[0].start;
    gen[1].start;
    repeat(10)
      gen[2].start;
    gen[3].start;
    
  end
  
endmodule


//Output
'{}
'{}
'{}
'{}
ID = 1  aid = 1
23078858752384
ID = 2  aid = 1
23078858752464
ID = 3  aid = 1
23078858752544
ID = 4  aid = 1
23078858752624
ID = 5  aid = 1
23078858752704
ID = 6  aid = 1
23078858752784
ID = 7  aid = 1
23078858752864
ID = 8  aid = 1
23078858752944
ID = 9  aid = 1
23078858753024
ID = 10  aid = 1
23078858753104
ID = 11  aid = 1
23078858753184
ID = 12  aid = 1
23078858753264
ID = 13  aid = 1
23078858753344
```
