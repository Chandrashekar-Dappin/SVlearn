```
class packet;
  
  static int count;
  
  function new();
    count++;
  endfunction
  
endclass
  
  
  module tb;
    
    packet p;
    
    initial begin
      
      repeat(10)
        p=new();
      
      $display("No. of objects = %0d ",p.count);
      
    end
    
  endmodule
```
