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

//Output
throws error

// correct usage
module tb;
  
  bit [2:0] a,b;
  
  initial begin
    
    repeat(10) begin
    randomize(a,b);
    $display("a = %0d b = %0d",a,b);
    end
    
  end
  
endmodule

//output
a = 4 b = 6
a = 6 b = 6
a = 4 b = 7
a = 5 b = 5
a = 3 b = 5
a = 4 b = 5
a = 7 b = 4
a = 4 b = 3
a = 5 b = 5
a = 4 b = 6
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
