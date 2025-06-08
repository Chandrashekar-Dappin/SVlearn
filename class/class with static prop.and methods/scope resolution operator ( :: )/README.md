# using scope resolution operator we can access the prop. and methods of a class without using handler
# but the condition is the prop. and methods of class should be of 'static' type

```
class packet;
  static bit [7:0] addr;
  static bit [7:0] data;
  
  static function void display();
    $display(" addr : %0d | data : %0d ",addr ,data);
  endfunction
  
endclass

module tb;
  packet p1; // handler
  
  initial begin

    packet::display();
    
    packet::addr = 10;
    packet::data = 20;
    
    packet::display();
    
  end
  
endmodule

//Output
addr : 0 | data : 0 
addr : 10 | data : 20
```
