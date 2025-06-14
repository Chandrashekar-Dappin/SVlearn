> ## Modport : It determines the direction of the signals. It is written inside interface
>
> ## Ex1 :
```
interface intf;
  logic a;
  logic b;
  logic s;
  logic c;
  
  modport DUT(input a,b ,output s,c);
  modport TB(input s,c, output a,b);
  
endinterface


module HA(intf.DUT inf);
  
 // assign {inf.a, inf.b} = inf.c + inf.s;  // HA, "inf.a"Port 'a' of modport 'DUT' has been restricted as an input port. Input ports cannot be driven
assign {inf.c, inf.s} = inf.a + inf.b;
endmodule


module test (intf.TB inf);
  
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
