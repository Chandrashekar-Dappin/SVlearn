## Ex:
```
class packet;
  rand bit [7:0] a;
  rand bit [7:0] b;
  
  constraint c1{ a>=50; a<=100; b>100; b<=200;}
  
endclass

module tb;
  packet p;
  
  initial begin
    p = new();
    
    repeat(5) begin
      p.randomize();   
      $display("a = %0d | b = %0d",p.a,p.b);
    end
    
  end
  
endmodule

//Output
a = 60 | b = 194
a = 62 | b = 104
a = 81 | b = 173
a = 88 | b = 150
a = 61 | b = 143
```
