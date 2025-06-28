## Extern functions are declared inside the class with 'extern' keyword but defined outside the class.

## Ex:
```
class packet;
  
  extern function void display1();
    
  extern function void display2();

  extern function void display3();

  
endclass
    
function void packet :: display1();
  $display("packet1");
endfunction

function void packet :: display2();
  $display("packet2");
endfunction

function void packet :: display3();
  $display("packet3");
endfunction

module tb;
  
  packet p;
  
  initial begin
    
    p = new();
    p.display1();
    p.display2();
    p.display3();

  end

  
endmodule

//Output
packet1
packet2
packet3
```
