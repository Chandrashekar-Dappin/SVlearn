## Unique constraints ensures that all the variables mentioned in the list must be different.

## Ex:
```
class packet ;
  
  rand bit [1:0] a,b;
  
  constraint c1 { unique{a,b};}
  
endclass


module tb;
  
  initial begin
    
    packet p = new();
    
    repeat(10)begin
      assert(p.randomize())
        $display("a = %0d b = %0d",p.a,p.b);
      
    end
    
  end
  
endmodule

//output
a = 3 b = 0
a = 1 b = 2
a = 1 b = 2
a = 0 b = 3
a = 2 b = 0
a = 1 b = 0
a = 2 b = 0
a = 1 b = 3
a = 0 b = 3
a = 0 b = 3
```
