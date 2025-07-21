## Dynamic casting
```
class parent;
  
  virtual function void display();
    $display("parent");
  endfunction
  
endclass


class child extends parent;
  
  function void display();
    $display("child");
  endfunction
  
endclass



module tb;
  
  parent p;
  child c;
  
  initial begin
    c = new();
    p = c;     // upcasting.. assigning child to parent.. safe and legal
    
    if($cast(c,p))     // downcasting.... cannot assign directly...needs dynamic casting 
      $display("down casting successful");
    else
      $display("down casting fialed");
    
    p.display();
   
  end
  
endmodule

```

## Output
```
down casting successful
child

```
