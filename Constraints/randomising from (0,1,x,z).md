```
class gen;
  
  reg a;
  rand bit[1:0] b;
  
  constraint c1 { b
 inside {[0:3]}; }
  
  function void post_randomize();
    
    case(b)
      2'b00  : a = 0;
      2'b01  : a = 1;
      2'b10  : a = 1'bx;
      2'b11  : a = 1'bz;
    endcase
    
  endfunction


endclass


module tb;
  
  gen g;
  
  initial begin
    
    g = new();
    
    repeat(10) begin
    assert(g.randomize());
    $display("randomising from (0,1,x,z) : %d",g.a);
    end

    
  end
  
endmodule

//output
randomising from (0,1,x,z) : 0
randomising from (0,1,x,z) : 0
randomising from (0,1,x,z) : x
randomising from (0,1,x,z) : z
randomising from (0,1,x,z) : 0
randomising from (0,1,x,z) : 0
randomising from (0,1,x,z) : z
randomising from (0,1,x,z) : 0
randomising from (0,1,x,z) : x
randomising from (0,1,x,z) : 1
```
