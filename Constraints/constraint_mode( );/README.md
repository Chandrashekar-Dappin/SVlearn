![WhatsApp Image 2025-06-10 at 16 08 35_1acfa847](https://github.com/user-attachments/assets/5bed8e13-934e-4328-b84e-ade45032a52a)

## Ex1 : handle_name.constraint_mode(0);
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
    
    p.constraint_mode(0);
    
    repeat(10) begin
      assert(p.randomize())
      $display("a = %0d | b = %0d",p.a,p.b);
    end
    
  end
  
endmodule

//Output
a = 86 | b = 16
a = 225 | b = 4
a = 96 | b = 16
a = 204 | b = 8
a = 201 | b = 12
a = 249 | b = 8
a = 143 | b = 8
a = 255 | b = 24
a = 173 | b = 24
a = 35 | b = 12
```

## Ex2 : handle_name.prop_name.constraint_mode(0);
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
    
    p.c2.constraint_mode(0);
    
    repeat(10) begin
      assert(p.randomize())
      $display("a = %0d | b = %0d",p.a,p.b);
    end
    
  end
  
endmodule

//Output
a = 20 | b = 247
a = 20 | b = 63
a = 15 | b = 129
a = 10 | b = 169
a = 20 | b = 103
a = 10 | b = 106
a = 15 | b = 190
a = 15 | b = 4
a = 10 | b = 162
a = 15 | b = 242
```
