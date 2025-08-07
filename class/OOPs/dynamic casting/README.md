## Dynamic casting (used for down casting in polymorphism i.e assigning parent handle to child handle
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

## 
## Output
```
down casting successful
child

```

## Ex 2:
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
  
  parent p1,p2;
  child c1,c2;
  
  initial begin
    
    c1 = new();
    p1 = c1;         //upcasting 
    $cast(c2,p1);    //downcasting
    
    p1.display();
    c2.display();
  end
  
endmodule
```

## Output
```
child
child
```
