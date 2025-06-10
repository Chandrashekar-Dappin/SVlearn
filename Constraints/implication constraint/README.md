## Implication operator : 

## Ex :
```
class packet;
  rand bit [7:0] data,addr;

  constraint c1 { addr>100 -> data < 100; }
  constraint c2 { addr<100 -> data > 100; }
  
endclass

module tb;
  
  packet p1;
  
  initial begin
    p1 = new();
    
    repeat(10) begin
      assert(p1.randomize())
      $display("p1 : addr = %0d | data = %0d ",p1.addr,p1.data);
    end

  end
  
endmodule

// Output
p1 : addr = 11 | data = 209 
p1 : addr = 238 | data = 74 
p1 : addr = 32 | data = 224 
p1 : addr = 180 | data = 12 
p1 : addr = 0 | data = 110 
p1 : addr = 139 | data = 89 
p1 : addr = 116 | data = 56 
p1 : addr = 118 | data = 74 
p1 : addr = 248 | data = 29 
p1 : addr = 11 | data = 240
```
