# Inheritance : child handle is allowed to access the properties and methods of parent class


```
class parent;
  int x;
  
  function void pdisplay();
    $display("I'm in parent");
  endfunction
  
endclass


class child extends parent;
  int y;
  
  // function new();
  //   super.new();      by default the new function is called in inheritance so its optional
  // endfunction
  
  function void cdisplay();
    $display("I'm in child");
  endfunction
  
endclass

module tb;
  parent p;
  child c;
  
  initial begin
    p = new();
    c = new();
    
    c.pdisplay();
    c.cdisplay();
    
  end
  
endmodule
    
    
 // Output
I'm in parent
I'm in child

```

# printing both statements by calling by directly creating single object

```
