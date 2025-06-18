# 4 x 2 Priority Encoder Verification
## Testbench Architecture
![INTERFACE (1)](https://github.com/user-attachments/assets/d70efff1-a685-4b82-a729-3fa72d0f0f0f)


## 1.DUT
```
module priority_enc(D,I);
  input [3:0] D;
  output reg [1:0] I;
  
  always@(D) begin
    casez(D)
      4'b0001 : I = 2'b00;
      4'b001? : I = 2'b01;
      4'b01?? : I = 2'b10;
      4'b1??? : I = 2'b11;
    endcase
  end
  
endmodule
```



## 2.Interface
```
interface PR_intf;
  logic [3:0] D;
  logic [1:0] I;
endinterface
```

## 3.Transaction
```
class transaction;
  rand bit[3:0] D;
  bit [1:0]I;
  
  function void display(string name);
    $display("[%s] : D = %b | I = %b",name,D,I);
  endfunction
  
endclass
```
## 4.Genarator
```
class generator;
  
  rand transaction tr;
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
      tr=new();
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
  virtual PR_intf vif;
  
  int count;
  
  function new(mailbox gen2drv, virtual PR_intf vif,int count);
    this.gen2drv = gen2drv;
    this.vif = vif;
    this.count = count;
  endfunction
  
  task main();
    
    repeat(count) begin
      gen2drv.get(tr);
      
      vif.D <= tr.D;
      
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
  virtual PR_intf vif;
  
  int count;
  
  function new(mailbox mon2scr,virtual PR_intf vif,int count);
    this.mon2scr = mon2scr;
    this.vif = vif;
    this.count = count;
  endfunction
  
  
  task main();
    
    repeat(count)begin
      #1;
      tr = new();
      tr.D = vif.D;
      tr.I = vif.I;
      
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
  bit [1:0] expected_I;
  
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
      
      casez(tr.D)
        4'b0001 : expected_I = tr.I;
        4'b001? : expected_I = tr.I;
        4'b01?? : expected_I = tr.I;
        4'b1??? : expected_I = tr.I;
      endcase
      
      if(expected_I === tr.I)
        $display("TEST PASSED");
      else
        $display("TEST FAILED");
      
      $display("");
      ->done;
      
    end
    
  endtask 
  
endclass
```

## 8.Environment
```
class environment;
  
  //declare class handles
  generator gen;
  driver drv;
  monitor mon;
  scoreboard scr;
  
  //declare mailbox
  mailbox gen2drv;
  mailbox mon2scr;
  
  //declare interface
  virtual PR_intf vif;
  
  //declare events and count
  event done;
  int count;
  
  
  //custom constructor
  function new(virtual PR_intf vif,int count);
    this.vif = vif;
    this.count = count;
    
    
    //object creation of mailboxes
    gen2drv = new();
    mon2scr = new();
    
    //object creation of classes using custom constructor
    gen = new(gen2drv,done,count);
    drv = new(gen2drv, vif,count);
    mon = new(mon2scr,vif,count);
    scr = new(mon2scr,done,count);
    
  endfunction
  
  // run all the main() tasks of classes
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
module test(PR_intf inf);
  
  environment env;
  
  //for repeatation
  int count = 12;
  
  initial begin
    env = new(inf,count);
    env.run();
  end
  
endmodule
```


## Top
```
module top;
  
  //instantiate interface
  PR_intf inf();
  
  //instantiate DUT
  priority_enc dut(.I(inf.I), .D(inf.D));
  
  //instantiate test
  test tb(inf);
  
endmodule
```  

## Output
```
[GEN] : D = 1101 | I = 00
[DRV] : D = 1101 | I = 00
[MON] : D = 1101 | I = 11
[SCR] : D = 1101 | I = 11
TEST PASSED

[GEN] : D = 0110 | I = 00
[MON] : D = 0110 | I = 10
[DRV] : D = 0110 | I = 00
[SCR] : D = 0110 | I = 10
TEST PASSED

[GEN] : D = 1111 | I = 00
[MON] : D = 1111 | I = 11
[DRV] : D = 1111 | I = 00
[SCR] : D = 1111 | I = 11
TEST PASSED

[GEN] : D = 1111 | I = 00
[MON] : D = 1111 | I = 11
[DRV] : D = 1111 | I = 00
[SCR] : D = 1111 | I = 11
TEST PASSED

[GEN] : D = 0111 | I = 00
[MON] : D = 0111 | I = 10
[DRV] : D = 0111 | I = 00
[SCR] : D = 0111 | I = 10
TEST PASSED

[GEN] : D = 1111 | I = 00
[MON] : D = 1111 | I = 11
[DRV] : D = 1111 | I = 00
[SCR] : D = 1111 | I = 11
TEST PASSED

[GEN] : D = 0100 | I = 00
[MON] : D = 0100 | I = 10
[DRV] : D = 0100 | I = 00
[SCR] : D = 0100 | I = 10
TEST PASSED

[GEN] : D = 1100 | I = 00
[MON] : D = 1100 | I = 11
[DRV] : D = 1100 | I = 00
[SCR] : D = 1100 | I = 11
TEST PASSED

[GEN] : D = 0100 | I = 00
[MON] : D = 0100 | I = 10
[DRV] : D = 0100 | I = 00
[SCR] : D = 0100 | I = 10
TEST PASSED

[GEN] : D = 0111 | I = 00
[MON] : D = 0111 | I = 10
[DRV] : D = 0111 | I = 00
[SCR] : D = 0111 | I = 10
TEST PASSED

[GEN] : D = 1101 | I = 00
[MON] : D = 1101 | I = 11
[DRV] : D = 1101 | I = 00
[SCR] : D = 1101 | I = 11
TEST PASSED

[GEN] : D = 1011 | I = 00
[MON] : D = 1011 | I = 11
[DRV] : D = 1011 | I = 00
[SCR] : D = 1011 | I = 11
TEST PASSED
```
        
        
      
    
      
  
  
      
