# Full Adder Verification
## Test Bench Architecture
![INTERFACE (1)](https://github.com/user-attachments/assets/7e216adb-4730-439d-9488-1bacf8e970a0)

## 1.DUT
```
module FA (input a,b,cin, output s,cout);
  assign {cout,s} = a+b+cin;
endmodule
```

## 2.Interface
```
interface FA_intf;
  
  logic a;
  logic b;
  logic cin;
  logic s;
  logic cout;
  
endinterface
```

## 3.Transaction
```
class transaction;
  
  rand bit a,b,cin;
  bit s,cout;
  
  function void display(string name);
    $display("[%s] : A = %b | B = %b | Cin = %b | Sum = %b | Carry = %b ",name,a,b,cin,s,cout);
    
  endfunction
  
endclass
```

## 4.Generator
```
class generator;
  
  //declaring the handlers
  rand transaction tr;
  mailbox gen2drv;
  
  // write custom constructor
  function new(mailbox gen2drv);
    this.gen2drv = gen2drv;
  endfunction
  
  // write the main task (generate the packet, randomize  and put this packet into mailbox
  task main();
    
    repeat(10) begin
      tr = new();
      assert(tr.randomize());
      gen2drv.put(tr);
      tr.display("GEN");
    end
    
  endtask
  
endclass
```

## 5.Driver
```
class driver;
  
  //declaring the handlers
  transaction tr;
  mailbox gen2drv;
  virtual FA_intf vif;
  
  // write custom constructor
  function new(mailbox gen2drv,virtual FA_intf vif);
    this.gen2drv = gen2drv;
    this.vif = vif;
  endfunction
  
  // write the main task
  task main();
    
    repeat(10) begin
      gen2drv.get(tr);
      
      // driving the inputs from the transaction packet to interface using NBA 
      vif.a <= tr.a;
      vif.b <= tr.b;
      vif.cin <= tr.cin;
      
      //printing the inputs before driving them
      
      #1;   // giving delay to avoid race condition
      $display("");
      tr.display("DRV");
    end
    
  endtask
  
endclass
```

## 6.Monitor
```
class monitor;
  
  //declaring the handlers
  transaction tr;
  mailbox mon2scr;
  virtual FA_intf vif;
  
  //write the custom constructor
  function new(mailbox mon2scr , virtual FA_intf vif);
    this.mon2scr = mon2scr;
    this.vif = vif;
  endfunction

  // write the main task
  task main();
    
    repeat(10) begin
      #1;   // same delay as driver
      tr = new();
      // monitoring the IO's
      tr.a = vif.a;
      tr.b = vif.b;
      tr.cin = vif.cin;
      tr.s = vif.s;
      tr.cout = vif.cout;
      
      mon2scr.put(tr);  // putting the all data loaded transaction packet to mailbox
      
      tr.display("MON");
      
    end
    
  endtask
  
endclass
```

## 7.Scoreboard
```
class scoreboard;
  
  // declaring the handlers
  transaction tr;
  mailbox mon2scr;
  
  //custom constructor
  function new(mailbox mon2scr);
    this.mon2scr = mon2scr;
  endfunction
  
  // write the main task
  task main();
    
    repeat(10) begin
      mon2scr.get(tr);
      
      //checking with golden data
      if({tr.cout, tr.s} == tr.a + tr.b + tr.cin)
          $display("TEST PASSED");
      
      else
        $error("TEST FAILED");
     
      tr.display("SCR");
      
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
  
  virtual FA_intf vif;
  
  function new(virtual FA_intf vif);
    this.vif = vif;
    
    gen2drv = new();
    mon2scr = new();
    
    gen=new(gen2drv);
    drv=new(gen2drv,vif);
    mon=new(mon2scr,vif);
    scr=new(mon2scr);
    
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
module test(FA_intf inf);
  
  environment env;
  
  initial begin
    env = new(inf);
    env.run();
  end
  
endmodule
```


## 10.Top
```
module top;
  
  FA_intf inf();
  
  FA dut(.a(inf.a), .b(inf.b), .cin(inf.cin), .s(inf.s), .cout(inf.cout));
  
  test tb(inf);
  
  initial begin
    $dumpfile("Dumpfile.vcd");
    $dumpvars(1,tb);
  end
  
endmodule
```


         
