# 'static' keyword should be mentioned before properties and methods
# memory is allocated at the time of declaration only so no need to use 'new()'
# all handlers share single memory so changes made to one handler will be reflected in another handler

```
class packet;
  static int addr;
  static int data;
  
  static function void display();
    $display(" addr : %0d | data : %0d ",addr ,data);
  endfunction
  
endclass

module tb;
  packet p1, p2; // handler
  
  initial begin
    
    p1.display(); // displays default values of addr and data of p1
    p2.display(); // displays default values of addr and data of p2
    
    p1.addr = 10;
    p1.data = 20;
    
    p1.display(); // displays updated values of addr and data of p1
    p2.display(); // p1 values are reflected p2
    
    p2.addr = 100;
    p2.data = 200;
    
    p2.display(); // displays updated values of addr and data of p2
    p1.display(); // p2 values reflected in p1
    
  end
  
endmodule

// Output
 addr : 0 | data : 0  --p1
 addr : 0 | data : 0  --p2
 addr : 10 | data : 20  --p1
 addr : 10 | data : 20  --p2
 addr : 100 | data : 200 --p2
 addr : 100 | data : 200 --p1
```
