# In case of parent and child class with same prop. and methods are there. the parent class prop. and methods are overridden by child class prop. and methods.
```
class parent;
  int x;
  
  function void display();
    $display("Hi I'm in parent class");
  endfunction
  
endclass

class child extends parent;
  int y;
  
  function void display();
    
    $display("Hi I'm in child class");
  endfunction
  
endclass

module tb;
  parent p;
  child c;
  
  initial begin
    c = new();
    c.display();
  end
  
endmodule

//Output
Hi I'm in child class
```

# printing both displays with single child object...just add super.display() inside display() function of child class

```
class parent;
  int x;
  
  function void display();
    $display("Hi I'm in parent class");
  endfunction
  
endclass

class child extends parent;
  int y;
  
  function void display();
    **super.display();**
    $display("Hi I'm in child class");
  endfunction
  
endclass

module tb;
  parent p;
  child c;
  
  initial begin
    c = new();
    c.display();
  end
  
endmodule

// Output
Hi I'm in parent class
Hi I'm in child class
```
