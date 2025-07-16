## Scope randomization : we can randomize the variables without declaring them as rand / randc using following syntax.
## std :: randomize( variables);

## NOTE : only inline constraints can be written with scope randomization 

## scope randomization can be written for class members as well as module members.

## Ex : scope randomization for class members
```
class packet;
  bit [7:0] a,b;
  
endclass


module tb;
  
  packet p;
  
  initial begin
    
    p = new();
    
    repeat(10) begin
      std::randomize(p.a,p.b);
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

## Ex2 : scope randomization for module members with inline constraints
```
module tb;
  
  bit[7:0] a,b;
  
  initial begin
    
    repeat(10) begin
      std::randomize(a,b) with {a<=50; b<=100;};
      $display("a = %0d b = %0d",a,b);
    end
    
  end
  
endmodule

//Output
a = 46 b = 33
a = 32 b = 48
a = 43 b = 25
a = 40 b = 55
a = 40 b = 8
a = 23 b = 76
a = 29 b = 9
a = 48 b = 9
a = 31 b = 49
a = 29 b = 44
```
