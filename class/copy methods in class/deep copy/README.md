# deep copy : separate memory is created for properties and objects
### ex : h2 = h1.copy();    ('copy()' is mandatory)
### a copy function is written in each class mandatorily

### copy method: for property - copy.prop = this.prop;
### copy method: for object - copy.object = object.copy();

```
class A;
  int a;
  
  function A copy();
    copy = new();
    copy.a = this.a;
    return copy;
  endfunction
  
endclass

class B;
  int b;
  A h_a1;
  
  function new();   //
    h_a1 = new();    // mandatory
  endfunction       //
  
  function B copy();
    copy = new();
    copy.b = this.b;
    copy.h_a1 = h_a1.copy();
    return copy;
  endfunction
   
  
endclass


module tb;
  B h_b1, h_b2;
  
  initial begin
    h_b1 = new(); // creates object for class B and class A
    
    h_b1.h_a1.a = 10;
    h_b1.b = 20;
    
    h_b2 = h_b1.copy();
    
    $display("h_b1 : a = %0d | b = %0d", h_b1.h_a1.a,h_b1.b);
    $display("h_b2 : a = %0d | b = %0d", h_b2.h_a1.a,h_b2.b);

    h_b1.h_a1.a = 100;
    h_b1.b = 200;
    
    $display("h_b1 : a = %0d | b = %0d", h_b1.h_a1.a,h_b1.b);
    $display("h_b2 : a = %0d | b = %0d", h_b2.h_a1.a,h_b2.b);
    
  end
  
endmodule

// Output
h_b1 : a = 10 | b = 20
h_b2 : a = 10 | b = 20
h_b1 : a = 100 | b = 200
h_b2 : a = 10 | b = 20
```
