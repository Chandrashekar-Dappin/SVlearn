# Nesting of classes  - the handle of one class is declared inside another class
# 'new()' function must be written inside the class where you're declaring the handle of another class
# so whenever the object is created for this class ,it also creates the object for the nested class

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
  B h_b1;
  
  initial begin
    h_b1 = new(); // creates object for class B and class A
    
    h_b1.h_a1.a = 10;
    h_b1.b = 20;
    
    $display("a = %0d | b = %0d", h_b1.h_a1.a,h_b1.b);
    
  end
  
endmodule

// Output
a = 10 | b =20
```
