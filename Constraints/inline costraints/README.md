## Inline constraints are written along with randomize() function using'with' keyword.

## Ex:
```
class packet;
  rand bit [7:0] a;
  rand bit [7:0] b;
  
  function void display();
    $display("a = %0d | b = %0d",a,b);
  endfunction
  
endclass

module tb;
  packet p;
  
  initial begin
    p = new();
    
    repeat(5) begin
      p.randomize() with { p.a>=50; p.a<=100; 
                          p.b>100; p.b<=200;};  //in-line constraint (;) must after {}
       $display("a = %0d | b = %0d",p.a,p.b);
    end
    
  end
  
endmodule

//output
a = 60 | b = 194
a = 62 | b = 104
a = 81 | b = 173
a = 88 | b = 150
a = 61 | b = 143
```
