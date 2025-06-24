```
//pack1.sv
package mypack1;

function int add(int x,y);
  add = x+y;
endfunction


endpackage

//pack2.sv
package mypack2;

function int add(int x,y,z);
  add = x+y+z;
endfunction

endpackage


`include "pack1.sv"
`include "pack2.sv"

module adder;
   int a, b;

  import mypack1::*;
  import mypack2::*;

 

  initial begin
    a = mypack1::add(10, 20);      // using fully qualified name (safe)
    b = mypack2::add(10, 20, 30);  // using fully qualified name (safe)

    $display("a = %0d | b = %0d", a, b);
  end

endmodule

a = 30 | b = 60
```
