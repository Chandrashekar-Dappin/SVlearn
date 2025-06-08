# default constructor - assigns default values of datatypes / properties
### handle = new();

# custom constructor - write 'new()' function inside class with arguments
### handle = new(args);
### it doesn't have any return type
### we cannot use 'void' keyword with 'new()' function as by default it doesn't return anything

```
class packet;
  int a;
  int b;
  
 // function void display();
 //   $display( "a = %0d | b = %0d",a,b);
 // endfunction
  
  function new(int x, int y);
    a=x;
    b=y;
    $display( "a = %0d | b = %0d",a,b);
  endfunction
  
endclass


module tb;
  packet p1, p2;
  
  initial begin
    p1 = new(10,20);
    p2 = new(100,200);
    
   // p1.display();
   // p2.display();
    
  end
  
endmodule

//Output
a = 10 | b = 20
a = 100 | b = 200
```
