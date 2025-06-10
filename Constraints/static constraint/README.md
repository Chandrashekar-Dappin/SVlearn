> static constraint : writing 'static' keyword before constraint , then this constraint is shared with all objects of class.

> Ex :
 ```
class packet;
  rand bit [7:0] a;
  
  static constraint c1 { a>=10; a<=20; }
  
endclass

module tb;
  
  packet p1, p2;
  
  initial begin
    p1 = new();
    p2 = new();
    
    assert(p1.randomize())
      $display("p1 : a = %0d ",p1.a);
    
    assert(p2.randomize())
      $display("p2 before p1.constraint_mode(0): a = %0d ",p2.a);
    
    p1.constraint_mode(0);
    
    assert(p2.randomize())
      $display("p2 after p1.constraint_mode(0) : a = %0d ",p2.a);
    
  end
  
endmodule

// Output
p1 : a = 12 
p2 before p1.constraint_mode(0): a = 10 
p2 after p1.constraint_mode(0) : a = 148
```



