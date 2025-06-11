**Verilog has only $random but SV has $random, $urandom ,$urandom_range   // for this the variables need not to be declared as  rand / randc**

**SV has a built in class method - 'randomize()**

**1. scope randomization : randomize(signal names);     // for this the variables need not to be declared as  rand / randc**

**2. object randomization : handle.randomize();    // for this the variables must be declared as rand / randc**

**NOTE : randomize() has no size,it randomizes the data based datatype size**

## Ex1:
```
class packet;
  rand int a;
  int b;
  
endclass

module tb;
  packet p;
  
  initial begin
    p = new();
    
    repeat(5) begin
      p.randomize();
      $display("a = %0d | b = %0d",p.a,p.b);
    end
    
  end
  
endmodule

//Output
a = -384116807 | b = 0
a = 1637914715 | b = 0
a = 397247290 | b = 0
a = -407577593 | b = 0
a = -1298805792 | b = 0
```

## Ex2:
```
class packet;
  rand bit [7:0] a;
  rand bit [7:0] b;
  
  function void display();
    $display("a = %0d | b = %0d",a,b);
  endfunction
  
endclass

module tb;
  packet p;
  
  initial begin
    p = new();
    
    repeat(5) begin
      if(p.randomize())
       $display("a = %0d | b = %0d",p.a,p.b);
    end
    
  end
  
endmodule

//Output
a = 185 | b = 108
a = 91 | b = 128
a = 58 | b = 86
a = 7 | b = 82
a = 224 | b = 76
```
