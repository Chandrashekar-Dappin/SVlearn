## Parameterised class : A parameterized class is a class that takes one or more parameters, allowing you to write generic, reusable, and configurable code.


## Ex:
```
class packet #(parameter N = 8 , type dtype = bit) ;
  
  dtype [N-1:0] addr;
  dtype [N-1:0] data;
  
endclass

module tb;
  
  packet p1;
  packet #(16) p2;
  packet #(10,logic) p3;
  
  initial begin
    p1 = new();
    p2 = new();
    p3 = new();
    
    $display( "addr = %b | data = %b ", p1.addr,p1.data); 
    $display( "addr = %b | data = %b ", p2.addr,p2.data); 
    $display( "addr = %b | data = %b ", p3.addr,p3.data); 
    
  end
  
endmodule

//Output
addr = 00000000 | data = 00000000 
addr = 0000000000000000 | data = 0000000000000000
addr = xxxxxxxxxx | data = xxxxxxxxxx
```
