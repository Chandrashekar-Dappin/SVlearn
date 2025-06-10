## dist operator : It is used for weighted distribution 
## 2 types : (:=) - weights are divided equally when they are in range
##           (:/) - weights are divided equally when they are in range -- more accurate

## Ex1 :
```
class packet;

  rand int a;
  
  
  constraint c1 { a dist {5:=50, [2:3]:=20, [6:7]:=50 }; }
  
endclass

module tb;
  packet p;
  
  initial begin
    p = new();
    
    repeat(50) begin
      p.randomize();
      $display("addr = %0d ",p.a);
    end
    
  end
  
endmodule
```

## Ex2:
```
class packet;

  rand int a;
  
  
  constraint c1 { a dist {5:/50, [2:3]:/20, [6:7]:/50 }; }
  
endclass

module tb;
  packet p;
  
  initial begin
    p = new();
    
    repeat(50) begin
      p.randomize();
      $display("addr = %0d ",p.a);
    end
    
  end
  
endmodule
```

![WhatsApp Image 2025-06-10 at 15 52 11_f917f2aa](https://github.com/user-attachments/assets/674fcf12-69d5-47db-a6bb-025bf6e77d68)
![WhatsApp Image 2025-06-10 at 15 52 11_02ccaf95](https://github.com/user-attachments/assets/f31c6c46-c279-461e-80d1-18b71f8b70f5)

