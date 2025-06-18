# 2 x 4 Decoder Verification
## Test Bench Architecture
![INTERFACE (3)](https://github.com/user-attachments/assets/b4e787d5-8507-4e1b-a905-e7a7c821c74b)

### event done : it is used for synchronisation
### int count : it is parameterised in test, through which we can randomize the no.of packets

## 1. DUT
```
module decoder_2_4(I,D);
  input [1:0] I;
  output [3:0] D;
  
  assign D = (I == 2'b00) ? 4'b0001 : (I == 2'b01) ? 4'b0010 : (I == 2'b10) ? 4'b0100 : 4'b1000;
  
endmodule
```

## 2.Interface
```
interface dec_intf;
  logic [1:0] I;
  logic [3:0] D;
  
endinterface
```

## 3.Transaction
```
class transaction;
  
  rand bit [1:0] I;
  bit [3:0] D;
  
  function void display(string name);
    $display("[%s] : I = %b | D = %b ", name,I,D);
  endfunction
  
endclass
```


## 4.Generator
```
class generator;
  transaction tr;
  mailbox gen2drv;
  
  event done;
  int count;
  
  function new(mailbox gen2drv,event done,int count);
    this.gen2drv = gen2drv;
    this.done = done;
    this.count = count;
  endfunction
  
  task main();
    
    repeat(count) begin
      tr = new();
      assert(tr.randomize());
      gen2drv.put(tr);
      tr.display("GEN");
      @(done);
    end
    
  endtask
  
endclass
```


## 5.Driver
```
class driver;
  
  transaction tr;
  mailbox gen2drv;
  virtual dec_intf vif;
  
  int count;
  
  function new( mailbox gen2drv, virtual dec_intf vif,int count);
    this.gen2drv = gen2drv;
    this.vif = vif;
    this.count = count;
  endfunction
  
  task main();
    
    repeat(count) begin
      gen2drv.get(tr);
      vif.I <= tr.I;
      
      #1;
      tr.display("DRV");
    end
    
    
  endtask
  
endclass
```

## 6.Monitor
```
class monitor;
  
  transaction tr;
  mailbox mon2scr;
  virtual dec_intf vif;
  
  int count;
  
  
  function new(mailbox mon2scr, virtual dec_intf vif, int count);
    this.mon2scr = mon2scr;
    this.vif = vif;
    this.count = count;
  endfunction
  
  
  task main();
    repeat(count) begin
      #2;
      tr=new();
      tr.I = vif.I;
      tr.D = vif.D;
      
      mon2scr.put(tr);
      
      tr.display("MON");
      
    end
    
  endtask
  
endclass
```

## 7.Scoreboard
```
class scoreboard;
  
  transaction tr;
  mailbox mon2scr;
  bit [3:0] expected_D;
  
  event done;
  int count;
  
  function new(mailbox mon2scr,event done,int count);
    this.mon2scr = mon2scr;
    this.done = done;
    this.count = count;
  endfunction
  
  task main();
    
    repeat(count) begin
      mon2scr.get(tr);
      tr.display("SCR");
      
      case(tr.I)
        2'b00 : expected_D = tr.D;
        2'b01 : expected_D = tr.D;
        2'b10 : expected_D = tr.D;
        2'b11 : expected_D = tr.D;
      endcase
      
      if (expected_D === tr.D)
        $display("TEST PASSED");
      else
        $display("TEST FAILED");
      
      $display("");
      -> done;
    end
    
  endtask
  
endclass
```

## 8.Environment
```
class environment;
  
  generator gen;
  driver drv;
  monitor mon;
  scoreboard scr;
  
  mailbox gen2drv;
  mailbox mon2scr;
  
  event done;  //for synchronisation
  int count;  // for repeatation
  
  virtual dec_intf vif;
  
  function new(virtual dec_intf vif,int count);
    this.vif = vif;
    this.count = count;
    
    gen2drv = new();
    mon2scr = new();
    
    gen=new(gen2drv,done,count);
    drv=new(gen2drv,vif,count);
    mon=new(mon2scr,vif,count);
    scr=new(mon2scr,done,count);
    
  endfunction
  
  task run();
    fork
      gen.main();
      drv.main();
      mon.main();
      scr.main();
    join_any
  endtask
  
endclass
```



## 9.Test
```
module test(dec_intf inf);
  
  environment env;
  
  int count = 15;  //repeatation
  
  initial begin
    env = new(inf,count);
    env.run();
  end
  
endmodule
```

## 10.Top
```
module top;
  
  dec_intf inf();
  
  decoder_2_4 dut(.I(inf.I), .D(inf.D));
  
  test tb(inf);
  
endmodule
```  

## Output
```
[GEN] : I = 00 | D = 0000 
[DRV] : I = 00 | D = 0000 
[MON] : I = 00 | D = 0001 
[SCR] : I = 00 | D = 0001 
TEST PASSED

[GEN] : I = 11 | D = 0000 
[DRV] : I = 11 | D = 0000 
[MON] : I = 11 | D = 1000 
[SCR] : I = 11 | D = 1000 
TEST PASSED

[GEN] : I = 00 | D = 0000 
[DRV] : I = 00 | D = 0000 
[MON] : I = 00 | D = 0001 
[SCR] : I = 00 | D = 0001 
TEST PASSED

[GEN] : I = 01 | D = 0000 
[DRV] : I = 01 | D = 0000 
[MON] : I = 01 | D = 0010 
[SCR] : I = 01 | D = 0010 
TEST PASSED

[GEN] : I = 00 | D = 0000 
[DRV] : I = 00 | D = 0000 
[MON] : I = 00 | D = 0001 
[SCR] : I = 00 | D = 0001 
TEST PASSED

[GEN] : I = 10 | D = 0000 
[DRV] : I = 10 | D = 0000 
[MON] : I = 10 | D = 0100 
[SCR] : I = 10 | D = 0100 
TEST PASSED

[GEN] : I = 11 | D = 0000 
[DRV] : I = 11 | D = 0000 
[MON] : I = 11 | D = 1000 
[SCR] : I = 11 | D = 1000 
TEST PASSED

[GEN] : I = 01 | D = 0000 
[DRV] : I = 01 | D = 0000 
[MON] : I = 01 | D = 0010 
[SCR] : I = 01 | D = 0010 
TEST PASSED

[GEN] : I = 10 | D = 0000 
[DRV] : I = 10 | D = 0000 
[MON] : I = 10 | D = 0100 
[SCR] : I = 10 | D = 0100 
TEST PASSED

[GEN] : I = 01 | D = 0000 
[DRV] : I = 01 | D = 0000 
[MON] : I = 01 | D = 0010 
[SCR] : I = 01 | D = 0010 
TEST PASSED

[GEN] : I = 10 | D = 0000 
[DRV] : I = 10 | D = 0000 
[MON] : I = 10 | D = 0100 
[SCR] : I = 10 | D = 0100 
TEST PASSED

[GEN] : I = 10 | D = 0000 
[DRV] : I = 10 | D = 0000 
[MON] : I = 10 | D = 0100 
[SCR] : I = 10 | D = 0100 
TEST PASSED

[GEN] : I = 01 | D = 0000 
[DRV] : I = 01 | D = 0000 
[MON] : I = 01 | D = 0010 
[SCR] : I = 01 | D = 0010 
TEST PASSED

[GEN] : I = 10 | D = 0000 
[DRV] : I = 10 | D = 0000 
[MON] : I = 10 | D = 0100 
[SCR] : I = 10 | D = 0100 
TEST PASSED

[GEN] : I = 01 | D = 0000 
[DRV] : I = 01 | D = 0000 
[MON] : I = 01 | D = 0010 
[SCR] : I = 01 | D = 0010 
TEST PASSED
```
  
    
    
         



      
