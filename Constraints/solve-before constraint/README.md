## solve-before : instructing simulator to solve one variable before another variable, leading to different solutions than normal case.

## Ex1:
```
class packet;
  rand bit[4:0] a;
  rand bit[4:0] b;
  
  constraint c1 { (a+b)<20 ; solve a before b; }


endclass

module tb;
  packet p;

  initial begin
    p = new();
    
    repeat(3) begin 
      p.randomize();
      $display("a = %0d | b = %0d", p.a, p.b);
    end
    
  end
endmodule

//Output
a = 6 | b = 10
a = 3 | b = 13
a = 0 | b = 1
```
