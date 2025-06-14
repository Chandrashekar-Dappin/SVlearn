> ## Interface :
> It's a container for all communication signals through which TB and DUT communicate
> (It's a bunch if communication signals)
> by default it it static type.
>
>  ## Ex 1:
 ```
interface intf;
  logic a;
  logic b;
  logic s;
  logic c;
  
endinterface


module HA(intf inf);
  
  assign {inf.c, inf.s} = inf.a + inf.b;
  
endmodule


module test (intf inf);
  
  initial begin
    
    repeat(10) begin
      {inf.a , inf.b} = $random;
      #1;
    end 
    
  end
  
  initial begin
    $monitor("a = %0d | b = %0d | s = %0d | c = %0d ",inf.a, inf.b, inf.s, inf.c);
  end
  
endmodule


module top;
  
  intf inf();
  
  HA uut(inf);
  
  test tb(inf);
  
endmodule

//Output
a = 0 | b = 0 | s = 0 | c = 0 
a = 0 | b = 1 | s = 1 | c = 0 
a = 1 | b = 1 | s = 0 | c = 1 
a = 0 | b = 1 | s = 1 | c = 0 
a = 1 | b = 0 | s = 1 | c = 0 
a = 0 | b = 1 | s = 1 | c = 0
```



