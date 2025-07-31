## function static : here the variables declared inside function are static ..this means share same memory

```
class packet;
    function static void func();
    int x = 0;        
    x++;
      $display(x);
  endfunction

endclass 


module tb;
  packet p;
  initial begin
    p=new();
    p.func();
    p.func();
    p.func();
    p.func();
  
  end
endmodule

//output
          1
          2
          3
          4
```

## static function : written to make function explicitely static as they are by default dynamic in classes..
## the varialbes inside this functions are dynamic in nature.
## this function is shared with all the instances of the class

```
class packet;
    static function void func();
    int x = 0;        
    x++;
      $display(x);
  endfunction

endclass 


module tb;
  packet p,p2;
  initial begin
    p=new();
    p.func();
    p.func();
    p2.func();
    p2.func();
  
  end
endmodule

//output
          1
          1
          1
          1
```
