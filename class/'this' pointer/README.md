# 'this' pointer - it refers to the prop.and methods of same class
# used to distinguish class prop. and function arguments when they are having same variable

```
class packet;
  int a;
  int b;
  
 // function void display();
 //   $display( "a = %0d | b = %0d",a,b);
 // endfunction
  
  function new(int a, int b);
    this.a=a;   // this.a is variable of class which is declared above
    this.b=b;
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
