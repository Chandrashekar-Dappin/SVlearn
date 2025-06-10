![WhatsApp Image 2025-06-10 at 16 08 35_cb393de3](https://github.com/user-attachments/assets/be6208cb-a5f7-4932-86b4-3914ccbf1f27)

## Ex1 : rand_mode(0)
```
class packet;

  rand bit [7:0] a;
  rand bit [7:0] b;
  
  constraint c1 { a inside {5,10,15,20}; }
  constraint c2 { b inside {4,8,12,16,24}; }
  
endclass

module tb;
  packet p;
  
  initial begin
    p = new();
    
    p.rand_mode(0);
    
    repeat(10) begin
      p.randomize();
      $display("a = %0d | b = %0d",p.a,p.b);
    end
    
  end
  
endmodule

// Output
a = 0 | b = 0
```

## Ex2 : rand_mode(1)
```
class packet;

  rand bit [7:0] a;
  rand bit [7:0] b;
  
  constraint c1 { a inside {5,10,15,20}; }
  constraint c2 { b inside {4,8,12,16,24}; }
  
endclass

module tb;
  packet p;
  
  initial begin
    p = new();
    
    p.rand_mode(1);  
    
    repeat(10) begin
      p.randomize();
      $display("a = %0d | b = %0d",p.a,p.b);
    end
    
  end
  
endmodule

//Output
a = 20 | b = 16
a = 20 | b = 4
a = 15 | b = 16
a = 10 | b = 8
a = 20 | b = 12
a = 10 | b = 8
a = 15 | b = 8
a = 15 | b = 24
a = 10 | b = 24
a = 15 | b = 12
```

## Ex3 : p.a.rand_mode(0) -- if any of the property's  rand_mode(0) and other property's rand_mode(1) then also randomisation fails. both of them has to be in enable state to be randomized
```
class packet;

  rand bit [7:0] a;
  rand bit [7:0] b;
  
  constraint c1 { a inside {5,10,15,20}; }
  constraint c2 { b inside {4,8,12,16,24}; }
  
endclass

module tb;
  packet p;
  
  initial begin
    p = new();
    
    p.a.rand_mode(0);
    
    repeat(10) begin
      assert(p.randomize())
      $display("a = %0d | b = %0d",p.a,p.b);
    end
    
  end
  
endmodule

//Output
Constraints are inconsistent and cannot be solved.
```
