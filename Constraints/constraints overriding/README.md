# Constriants can be overridden by 2 ways.
## 1.Using same name to constraints in both parent class and child class
```
class parent;
  
  rand bit[4:0] a;
  
  constraint c1 { a>10 && a<20;}
  
endclass


class child extends parent;
  
  constraint c1 { a>20 && a<30;}

endclass


module tb;
  
  child c;
  
  initial begin
    
    c = new();
    
    repeat(10) begin
      c.randomize();
      $display("a = %0d",c.a);
    end
  
  end
  
endmodule

//Output
a = 22
a = 23
a = 26 
a = 27
a = 22
a = 22
a = 29
a = 23
a = 26
a = 23
```

## 2.Using constraint_mode():
```
class parent;
  
  rand bit[4:0] a;
  
  constraint c1 { a>10 && a<20;}
  
endclass


class child extends parent;
  
  constraint c2 { a>20 && a<30;}

endclass


module tb;
  
  child c;
  
  initial begin
    
    c = new();
    
    c.c2.constraint_mode(0);  // disables c2 constraint so it is overridden by c1 constraint
    
    repeat(10) begin
      c.randomize();
      $display("a = %0d",c.a);
    end
  
    
  end
  
endmodule

//Output
a = 18
a = 13
a = 16
a = 12
a = 13
a = 13
a = 11
a = 11
a = 12
a = 18
```
