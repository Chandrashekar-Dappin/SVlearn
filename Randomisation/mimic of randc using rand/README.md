
```
class packet;
  
  rand bit [2:0] a;
  bit [2:0] queue[$];
  
  constraint c1 {foreach(queue[i])
    a != queue[i];
             }
  
//  constraint c2 { unique{a,queue};}

//   constraint c3 { {!(a inside {queue})};
//                 }
  
  
  function void post_randomize();
    
    queue.push_back(a);
    
    if(queue.size == 8)
      queue.delete();
    
  endfunction
  
endclass


module tb;
  
  initial begin
    
    packet p = new();
    
    repeat(20) begin
    assert(p.randomize());
    $display("a = %0d",p.a);
    end
    
  end
  
  
endmodule

//Output
a = 5
a = 0
a = 3
a = 6
a = 4
a = 1
a = 7
a = 2
a = 2
a = 7
a = 3
a = 0
a = 5
a = 6
a = 1
a = 4
a = 2
a = 7
a = 5
a = 1
```
