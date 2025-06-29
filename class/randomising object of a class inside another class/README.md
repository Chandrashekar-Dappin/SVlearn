# Rules for randomising object of a class inside another class.
## write a class with a property using'rand' keyword..which needs to be randomized.
## write another class with  a handle of first class with 'rand' keyword...as the object of that handle needs to be randomised.
## write a custom constructor to create an object for that handle inside class.

## Ex:
```
class inner;
  
  rand bit[4:0] a;
  
endclass


class outer;
  
  rand inner i;
  
  function new();
    i = new();  //create memory for inner class
  endfunction
  
endclass


module tb;
  
  outer o;
  
  initial begin
    
    o = new();
    
    if(o.randomize())
      $display("randomized a = %0d",o.i.a);
    
    else
      $display("randomization failed");
    
  end
  
endmodule

//Output
randomized a = 25
```

