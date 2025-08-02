## a static function can only access static prop. not automatic prop. if does throws error

```
class packet;
  
  static int a;
  int b;
  
  static function void display();
    $display("a =%0d , b= %0d",a,b);
  endfunction
  
  
endclass



module tb;
  
  initial begin
    
    packet p1 = new();
    
    p1.a = 100;
    p1.b = 200;
    p1.display();
    
  end
  
endmodule

//output
  Illegal access of non-static member 'b' from static method 
```

## An automatic function can access both static and automatic prop.
```
class packet;
  
  static int a;
  int b;
  
  function void display();
    $display("a =%0d , b= %0d",a,b);
  endfunction
  
  
endclass



module tb;
  
  initial begin
    
    packet p1 = new();
    
    p1.a = 100;
    p1.b = 200;
    p1.display();
    
  end
  
endmodule

//output
a=100, b=200
```

