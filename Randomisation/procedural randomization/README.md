## procedural randomization: it works only for standalone variables, not class members.

## Ex1:
```
class packet;
  bit [7:0] a,b;
  
endclass


module tb;
  
  packet p;
  
  initial begin
    
    p = new()
    
    randomize(a,b);
    
    $display("a = %0d b = %0d",p.a,p.b);
    
  end
  
endmodule

a = 116 b = 110
```

## Ex2:Still use class + extract
## If you really want to use a class and still use randomize(a, b);, you need to assign the values manually:
```
module tb;

  packet p;
  rand bit [7:0] a, b;

  initial begin
    p = new();

    if (randomize(a, b)) begin
      p.a = a;
      p.b = b;
      $display("a = %0d, b = %0d", p.a, p.b);
    end
    else
      $display("Randomization failed");
  end

endmodule

```
