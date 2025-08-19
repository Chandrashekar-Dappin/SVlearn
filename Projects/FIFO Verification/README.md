```
module FIFO (input clk,rst,rd,wr,
             input [7:0]din,
             output reg [7:0] dout,
             output empty,full);
  
  reg [3:0] rptr = 0,wptr = 0;
  reg [4:0] count = 0;
  
  reg [7:0] mem [0:15];
  
  always@(posedge clk) begin
    
    if(rst) begin
      rptr <= 0;
      wptr <= 0;
      count <= 0;
    end
    
    else if(wr && !full) begin
      mem[wptr] <= din;
      wptr 		<= wptr+1;
      count 	<= count+1;
    end
    
    else if(rd && !empty) begin
      dout <= mem[rptr];
      rptr 		<= rptr+1;
      count 	<= count-1;
    end
    
  end
  
  assign empty = (count == 0) ? 1'b1 : 1'b0;
  assign full  = (count == 16) ? 1'b1 : 1'b0;
  
endmodule





/*
module tb;
  
  reg clk,rst,rd,wr;
  reg [7:0]din;
  wire [7:0] dout;
  wire empty,full;
  
  FIFO dut ( clk,rst,rd,wr,
             din,
             dout,
             empty,full); 
  
  initial begin
    clk = 0;
    rst = 1;
    #20 rst = 0;
    
    wr = 1;
    din = 5;
    #10 din = 10;
    #10 din = 15;
    #10 wr = 0;
    rd = 1;
    #30 rd = 0;
    #10 $finish;
    
  end
  
  always #5 clk = ~clk;
  
  initial  begin
    $monitor(" wr: %0d  |  rd : %0d  |  din : %0d  |  dout : %0d  | empty : %0d  | full : %0d", wr, rd, din, dout, empty, full);
    
    $dumpfile("dump.vcd");
    $dumpvars(1,tb);
  end
  
endmodule
  
*/





//////////interface////////////////////////

interface intf;
  
  logic clk,rst;
  logic wr,rd;
  logic empty ,full;
  logic [7:0] din,dout;
  
endinterface



////////TB codes /////////////////////////



class transaction;
  
  typedef enum bit { READ, WRITE} oper;
  rand oper op;
  bit wr,rd;
  bit empty,full;
  bit [7:0] din, dout;
  
  
endclass




class generator;
  
  transaction tr;
  mailbox #(transaction) gen2drv;
  
  int count;
  int i;
  
  event next;
  event done;
  
  function new( mailbox #(transaction) gen2drv);
    this.gen2drv = gen2drv;
    tr = new();
  endfunction
  
  
  
  task run();
    
    repeat(count) begin
      
      assert(tr.randomize())  else $error("Randomization Failed");
      i++;
      gen2drv.put(tr);
      $display("[GEN] : Operation : %0s  | iteration : %0d",tr.op.name, i);
      @(next);
      
    end
    
   ->done;
    
  endtask
  
endclass






class driver;
  
  virtual intf vif;
  transaction tr;
  mailbox #(transaction) gen2drv;
  
  function new( mailbox #(transaction) gen2drv, virtual intf vif);
    this.gen2drv = gen2drv;
    this.vif = vif;
  endfunction
  
  
  task reset();
    vif.rst <= 1;
    vif.rd <= 0;
    vif.wr <= 0;
    vif.din <= 0;
    
    repeat(5) @(posedge vif.clk);
    vif.rst <= 0;
    $display("[DRV] : DUT reset done");
    $display("------------------------------------------------");
  endtask
  
  
  task write();
    
    @(posedge vif.clk);
    vif.rst <= 0;
    vif.wr <= 1;
    vif.rd <= 0;
    vif.din <= $urandom_range(1,10);
    
    @(posedge vif.clk);
    vif.wr <= 0;
    $display("[DRV] : DATA WRITE : DATA : %0d ", vif.din);
    
    @(posedge vif.clk);
    
  endtask
  
  
  task read();
    
    @(posedge vif.clk);
    vif.rst <= 0;
    vif.wr <= 0;
    vif.rd <= 1;
    
    @(posedge vif.clk);
    vif.rd <= 0;
    $display("[DRV] : Data Read ");
    @(posedge vif.clk);
    
  endtask
  
  
  task run();
    forever begin
      gen2drv.get(tr);
      
      if(tr.op == 1)
        write();
      else
        read();
      
    end
    
  endtask
  
endclass




class monitor;
  
  virtual intf vif;
  transaction tr;
  mailbox #(transaction) mon2scr;
  
  function new(mailbox #(transaction) mon2scr, virtual intf vif);
    this.mon2scr = mon2scr;
    this.vif = vif;
  endfunction
  
  
  task run();
    
    tr = new();
    
    forever begin
      
    repeat(2) @(posedge vif.clk);
    
    tr.rd = vif.rd;
    tr.wr = vif.wr;
    tr.full = vif.full;
    tr.empty = vif.empty;
    tr.din = vif.din;
    
    @(posedge vif.clk);
    tr.dout = vif.dout;
    
    mon2scr.put(tr);
    $display("[MON] : wr: %0d  |  rd : %0d  |  din : %0d  |  dout : %0d  | empty : %0d  | full : %0d", tr.wr, tr.rd, tr.din, tr.dout, tr.empty, tr.full);
      
    end
      
  endtask
  
endclass




class scoreboard;
  
  transaction tr;
  mailbox #(transaction) mon2scr;
  
  event next;
  
  reg [7:0] data[$];
  reg [7:0] temp;
  int err;
  
  
  function new(mailbox #(transaction) mon2scr);
    this.mon2scr = mon2scr;
  endfunction
  
  task run();
    
    forever begin
    mon2scr.get(tr);
    
    $display("[SCR] : wr: %0d  |  rd : %0d  |  din : %0d  |  dout : %0d  | empty : %0d  | full : %0d", tr.wr, tr.rd, tr.din, tr.dout, tr.empty, tr.full);
    
    if(tr.wr == 1) begin
      
      if(tr.full == 0) begin
        data.push_front(tr.din);
        $display("[SCO] : DATA STORED IN QUEUE : %0d",tr.din);
      end
      
      else 
        $display("[SCO] : FIFO is Full");
      
      $display("--------------------------------------------");
    end
    
     if(tr.rd == 1) begin
      
      if(tr.empty == 0) begin
        temp = data.pop_back;
        
        if(tr.dout == temp)
          $display("[SCO] : DATA MATCHED");
        else begin
          $display("[SCO] : DATA MISMATCHED");
          err++;
        end
        
      end
      
      else
         $display("[SCO] : FIFO is empty");
      
      $display("-----------------------------------------");
      
    end
    
    -> next;
    
    end
    
  endtask
  
endclass
        
      
      
        
    
class environment;    
  
  virtual intf vif;
  
  event next;
  event done;
  
  mailbox #(transaction) gen2drv;
  mailbox #(transaction) mon2scr;  
  
  generator gen;
  driver drv;
  monitor mon;
  scoreboard sco;  
  
  
  function new(virtual intf vif);
    
    this.vif = vif;
    
    gen2drv = new();
    mon2scr = new();
    
    gen = new(gen2drv);
    drv = new(gen2drv,vif);
    mon = new(mon2scr,vif);
    sco = new(mon2scr);
    
    gen.next = next;
    sco.next = next;
    
  endfunction
  
  
  task pre_run();
    drv.reset();
  endtask
  
  task run();
    fork
      gen.run();
      drv.run();
      mon.run();
      sco.run();
    join_any
  endtask
  
  task post_run();
    wait(gen.done.triggered);
    $display("-----------------------------------------");
    $display("error count : %0d",sco.err);
    $display("-----------------------------------------");
    $finish();
  endtask
  
  
  task main();
    pre_run();
    run();
    post_run();
  endtask
  
endclass



module tb;
  
  intf inf();
  
  FIFO dut( inf.clk,inf.rst,inf.rd,inf.wr,
            inf.din,
            inf.dout,
            inf.empty,inf.full);
  
  environment env;
  
  initial inf.clk <= 0;
  
  always #10 inf.clk = ~inf.clk;
  
  initial begin
    
    env = new(inf);
    env.gen.count = 20;
    env.main();
    
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
endmodule
```

## Output
<img width="1814" height="281" alt="Screenshot 2025-08-19 123917" src="https://github.com/user-attachments/assets/5062eb05-f344-4701-98f2-2491cc9fc0bb" />

```
[DRV] : DUT reset done
------------------------------------------------
[GEN] : Operation : READ  | iteration : 1
[DRV] : Data Read 
[MON] : wr: 0  |  rd : 1  |  din : 0  |  dout : 0  | empty : 1  | full : 0
[SCR] : wr: 0  |  rd : 1  |  din : 0  |  dout : 0  | empty : 1  | full : 0
[SCO] : FIFO is empty
-----------------------------------------
[GEN] : Operation : WRITE  | iteration : 2
[DRV] : DATA WRITE : DATA : 8 
[MON] : wr: 1  |  rd : 0  |  din : 8  |  dout : 0  | empty : 1  | full : 0
[SCR] : wr: 1  |  rd : 0  |  din : 8  |  dout : 0  | empty : 1  | full : 0
[SCO] : DATA STORED IN QUEUE : 8
--------------------------------------------
[GEN] : Operation : WRITE  | iteration : 3
[DRV] : DATA WRITE : DATA : 1 
[MON] : wr: 1  |  rd : 0  |  din : 1  |  dout : 0  | empty : 0  | full : 0
[SCR] : wr: 1  |  rd : 0  |  din : 1  |  dout : 0  | empty : 0  | full : 0
[SCO] : DATA STORED IN QUEUE : 1
--------------------------------------------
[GEN] : Operation : WRITE  | iteration : 4
[DRV] : DATA WRITE : DATA : 10 
[MON] : wr: 1  |  rd : 0  |  din : 10  |  dout : 0  | empty : 0  | full : 0
[SCR] : wr: 1  |  rd : 0  |  din : 10  |  dout : 0  | empty : 0  | full : 0
[SCO] : DATA STORED IN QUEUE : 10
--------------------------------------------
[GEN] : Operation : WRITE  | iteration : 5
[DRV] : DATA WRITE : DATA : 9 
[MON] : wr: 1  |  rd : 0  |  din : 9  |  dout : 0  | empty : 0  | full : 0
[SCR] : wr: 1  |  rd : 0  |  din : 9  |  dout : 0  | empty : 0  | full : 0
[SCO] : DATA STORED IN QUEUE : 9
--------------------------------------------
[GEN] : Operation : WRITE  | iteration : 6
[DRV] : DATA WRITE : DATA : 4 
[MON] : wr: 1  |  rd : 0  |  din : 4  |  dout : 0  | empty : 0  | full : 0
[SCR] : wr: 1  |  rd : 0  |  din : 4  |  dout : 0  | empty : 0  | full : 0
[SCO] : DATA STORED IN QUEUE : 4
--------------------------------------------
[GEN] : Operation : WRITE  | iteration : 7
[DRV] : DATA WRITE : DATA : 6 
[MON] : wr: 1  |  rd : 0  |  din : 6  |  dout : 0  | empty : 0  | full : 0
[SCR] : wr: 1  |  rd : 0  |  din : 6  |  dout : 0  | empty : 0  | full : 0
[SCO] : DATA STORED IN QUEUE : 6
--------------------------------------------
[GEN] : Operation : WRITE  | iteration : 8
[DRV] : DATA WRITE : DATA : 6 
[MON] : wr: 1  |  rd : 0  |  din : 6  |  dout : 0  | empty : 0  | full : 0
[SCR] : wr: 1  |  rd : 0  |  din : 6  |  dout : 0  | empty : 0  | full : 0
[SCO] : DATA STORED IN QUEUE : 6
--------------------------------------------
[GEN] : Operation : READ  | iteration : 9
[DRV] : Data Read 
[MON] : wr: 0  |  rd : 1  |  din : 6  |  dout : 8  | empty : 0  | full : 0
[SCR] : wr: 0  |  rd : 1  |  din : 6  |  dout : 8  | empty : 0  | full : 0
[SCO] : DATA MATCHED
-----------------------------------------
[GEN] : Operation : WRITE  | iteration : 10
[DRV] : DATA WRITE : DATA : 5 
[MON] : wr: 1  |  rd : 0  |  din : 5  |  dout : 8  | empty : 0  | full : 0
[SCR] : wr: 1  |  rd : 0  |  din : 5  |  dout : 8  | empty : 0  | full : 0
[SCO] : DATA STORED IN QUEUE : 5
--------------------------------------------
[GEN] : Operation : READ  | iteration : 11
[DRV] : Data Read 
[MON] : wr: 0  |  rd : 1  |  din : 5  |  dout : 1  | empty : 0  | full : 0
[SCR] : wr: 0  |  rd : 1  |  din : 5  |  dout : 1  | empty : 0  | full : 0
[SCO] : DATA MATCHED
-----------------------------------------
[GEN] : Operation : WRITE  | iteration : 12
[DRV] : DATA WRITE : DATA : 6 
[MON] : wr: 1  |  rd : 0  |  din : 6  |  dout : 1  | empty : 0  | full : 0
[SCR] : wr: 1  |  rd : 0  |  din : 6  |  dout : 1  | empty : 0  | full : 0
[SCO] : DATA STORED IN QUEUE : 6
--------------------------------------------
[GEN] : Operation : WRITE  | iteration : 13
[DRV] : DATA WRITE : DATA : 10 
[MON] : wr: 1  |  rd : 0  |  din : 10  |  dout : 1  | empty : 0  | full : 0
[SCR] : wr: 1  |  rd : 0  |  din : 10  |  dout : 1  | empty : 0  | full : 0
[SCO] : DATA STORED IN QUEUE : 10
--------------------------------------------
[GEN] : Operation : READ  | iteration : 14
[DRV] : Data Read 
[MON] : wr: 0  |  rd : 1  |  din : 10  |  dout : 10  | empty : 0  | full : 0
[SCR] : wr: 0  |  rd : 1  |  din : 10  |  dout : 10  | empty : 0  | full : 0
[SCO] : DATA MATCHED
-----------------------------------------
[GEN] : Operation : WRITE  | iteration : 15
[DRV] : DATA WRITE : DATA : 3 
[MON] : wr: 1  |  rd : 0  |  din : 3  |  dout : 10  | empty : 0  | full : 0
[SCR] : wr: 1  |  rd : 0  |  din : 3  |  dout : 10  | empty : 0  | full : 0
[SCO] : DATA STORED IN QUEUE : 3
--------------------------------------------
[GEN] : Operation : READ  | iteration : 16
[DRV] : Data Read 
[MON] : wr: 0  |  rd : 1  |  din : 3  |  dout : 9  | empty : 0  | full : 0
[SCR] : wr: 0  |  rd : 1  |  din : 3  |  dout : 9  | empty : 0  | full : 0
[SCO] : DATA MATCHED
-----------------------------------------
[GEN] : Operation : WRITE  | iteration : 17
[DRV] : DATA WRITE : DATA : 4 
[MON] : wr: 1  |  rd : 0  |  din : 4  |  dout : 9  | empty : 0  | full : 0
[SCR] : wr: 1  |  rd : 0  |  din : 4  |  dout : 9  | empty : 0  | full : 0
[SCO] : DATA STORED IN QUEUE : 4
--------------------------------------------
[GEN] : Operation : READ  | iteration : 18
[DRV] : Data Read 
[MON] : wr: 0  |  rd : 1  |  din : 4  |  dout : 4  | empty : 0  | full : 0
[SCR] : wr: 0  |  rd : 1  |  din : 4  |  dout : 4  | empty : 0  | full : 0
[SCO] : DATA MATCHED
-----------------------------------------
[GEN] : Operation : READ  | iteration : 19
[DRV] : Data Read 
[MON] : wr: 0  |  rd : 1  |  din : 4  |  dout : 6  | empty : 0  | full : 0
[SCR] : wr: 0  |  rd : 1  |  din : 4  |  dout : 6  | empty : 0  | full : 0
[SCO] : DATA MATCHED
-----------------------------------------
[GEN] : Operation : READ  | iteration : 20
[DRV] : Data Read 
[MON] : wr: 0  |  rd : 1  |  din : 4  |  dout : 6  | empty : 0  | full : 0
[SCR] : wr: 0  |  rd : 1  |  din : 4  |  dout : 6  | empty : 0  | full : 0
[SCO] : DATA MATCHED
-----------------------------------------
-----------------------------------------
error count : 0
-----------------------------------------
```

  
