## Multiple Inheritance : here the child class is having multiple parent class. In such case we use interface class.
## Here we use 'implements' keyword instead of 'extends' for extending the classes.
## Interface class doesn't allow to write any properties ,it allows only methods.
## Inside interface class only pure virtual methods are allowed.

## Syntax:
```
interface class A;
----------
----------
----------
endclass

interface class B;
----------
----------
----------
endclass


class C implements A,B;
-----------
-----------
-----------
endclass
```

## Ex:
```
interface class print;
  
  pure virtual function void display();
    
endclass
    
    
interface class calculator;
  
  pure virtual function int add(int a,b);
    
endclass
    
    
class child implements print, calculator;
  
  virtual function void display();
    $display(" hi");
  endfunction
  
  
  virtual function int add(int a,b);
    return a+b;
  endfunction
  
endclass
    
    
    
module tb;
  
  child c;
  
  int a=10, b=20, cc;
  initial begin
     
    c = new();
    
    c.display();
    
    cc=c.add(a,b);
    
    $display(cc);
    
  end
  
endmodule

//output
hi
30
```
