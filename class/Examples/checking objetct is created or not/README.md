# Checks whether the memory is created or not

```
class packet;
  bit [7:0] addr;
  bit [7:0] data;
  
  function void display();
    $display(" addr : %0d | data : %0d ",addr ,data);
  endfunction
  
endclass

module tb;
  packet p1; // handler
  
  initial begin
    
    // p1 = new(); if not mentioned if-block executes
    
    if(p1 == null)
      $display("memory is not created");
    
    else begin
      $display("memory is created");
      p1.display();
    end
 
  end
  
endmodule

```
