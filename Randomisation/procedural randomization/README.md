## procedural randomization:it is used for randomizing the properties of class without declaring them as rand or randc

## Ex1:
```
class packet;
  bit [7:0] a,b;
  
endclass


module tb;
  
  packet p;
  
  initial begin
    
    p = new();
    
    repeat(10) begin
      randomize(p.a,p.b);
      $display("a = %0d b = %0d",p.a,p.b);
    end
    
  end
  
endmodule


//Output
a = 116 b = 110
a = 46 b = 22
a = 4 b = 231
a = 229 b = 141
a = 203 b = 37
a = 196 b = 13
a = 175 b = 212
a = 44 b = 251
a = 93 b = 101
a = 172 b = 190
```
