## 'inside' operator : whenever we want the constraints in particulzr range , we use inside constraints.

## Ex1 : a within range (5-10), (15-20), 37, 45, (100-120)
```
class packet;
  rand bit [7:0] a;
  
  constraint c1{a inside {[5:10],[15:20],37,45,[100:120]}; }
  
endclass

module tb;
  packet p;
  
  initial begin
    p = new();
    
    repeat(5) begin
      p.randomize();
      $display("a = %0d ",p.a);
    end
    
  end
  
endmodule

//Output
a = 6 
a = 105 
a = 8 
a = 116 
a = 6
```

## Ex2 : without inside operator
```
class packet;
  rand bit [7:0] a;
  
  constraint c1 { (a>=5 && a<=10) || (a>=15 && a<=20) || a == 37 || a == 45 || (a>=100 && a<=120) ; }
  
endclass

module tb;
  packet p;
  
  initial begin
    p = new();
    
    repeat(15) begin
      p.randomize();
      $display("a = %0d ",p.a);
    end
    
  end
  
endmodule

//Output
a = 6 
a = 105 
a = 8 
a = 116 
a = 6 
a = 102 
a = 119 
a = 104 
a = 112 
a = 16 
a = 101 
a = 15
```

## Ex3 : we can pass array values inside constraints

```
class packet;
  int array[6] = '{0,5,10,12,15,20};
  rand int addr;
  
  
  constraint c1 { addr inside {array}; }
  
endclass

module tb;
  packet p;
  
  initial begin
    p = new();
    
    repeat(15) begin
      p.randomize();
      $display("addr = %0d ",p.addr);
    end
    
  end
  
endmodule

//Output
addr = 20 
addr = 5 
addr = 10 
addr = 20 
addr = 5 
addr = 12 
addr = 15 
addr = 0 
addr = 20 
addr = 0 
addr = 15 
addr = 15 
addr = 5 
addr = 15 
addr = 12
```
