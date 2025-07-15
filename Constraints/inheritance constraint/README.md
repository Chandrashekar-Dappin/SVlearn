## Inheritance constraints : 
## if two different constraints with different names are written inside two different classes (i.e. parent and child class) ,then it is similar to both constraints are written inside same class (i.e. either in parent / child class)

## if constraints names in child class and parent class are same ,then child class constraint overrides parent class constraints when called by child handle.

## Ex1 : Child constraint overriding parent constraint with same name

```
class parent;
  rand bit [7:0] a;
  
  constraint c1 { a>=100; a<=200; }
  
endclass


class child extends parent;
  
  constraint c1 { a>=50; a<=150; }
  
endclass

module tb;
  child c;
  
  initial begin
    c = new();
    
    repeat(10) begin
      assert(c.randomize())
        $display(" a = %0d ",c.a);
    end
    
  end
  
endmodule

// output
 a = 71 
 a = 74 
 a = 112 
 a = 126 
 a = 72 
 a = 63 
 a = 145 
 a = 73 
 a = 111 
 a = 77
```

## Ex2 : Randomised data with constraints from both classes applied
```
class parent;
  rand bit [7:0] a;
  
  constraint c1 { a>=25; a<=150; }
  
endclass


class child extends parent;
  
  constraint c2 { a>=50; a<=200; }
  
endclass

module tb;
  child c;
  
  initial begin
    c = new();
    
    repeat(10) begin
      assert(c.randomize())
        $display(" a = %0d ",c.a);
    end
    
  end
  
endmodule

//Output
 a = 61 
 a = 121 
 a = 96 
 a = 104 
 a = 73 
 a = 109 
 a = 82 
 a = 63 
 a = 112 
 a = 139
```
