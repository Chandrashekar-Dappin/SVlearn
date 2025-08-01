# handle assignment - the content of one handle is copied into another handle
### syntax : target handle = source handle;  ex: h2 = h1;
### both handlers point to the same memory
### changes made to one handle will reflect in another handle

```
class A;
  int a;
endclass

class B;
  int b;
  A h_a1;
  
  function new();   //
    h_a1 = new();    // mandatory
  endfunction       //
  
endclass


module tb;
  B h_b1, h_b2;
  
  initial begin
    h_b1 = new(); // creates object for class B and class A
    
    h_b1.h_a1.a = 10;
    h_b1.b = 20;
    
    h_b2 = h_b1;
    
    $display("h_b1 : a = %0d | b = %0d", h_b1.h_a1.a,h_b1.b);
    $display("h_b2 : a = %0d | b = %0d", h_b2.h_a1.a,h_b2.b);

    h_b2.h_a1.a = 100;
    h_b2.b = 200;
    
    $display("h_b2 : a = %0d | b = %0d", h_b2.h_a1.a,h_b2.b);
    $display("h_b1 : a = %0d | b = %0d", h_b1.h_a1.a,h_b1.b);
  end
  
endmodule

// Output
h_b1 : a = 10 | b = 20
h_b2 : a = 10 | b = 20
h_b1 : a = 100 | b = 200
h_b2 : a = 100 | b = 200
```
