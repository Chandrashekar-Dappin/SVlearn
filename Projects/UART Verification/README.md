# DUT
## Top Module
```
`timescale 1ns / 1ps

module uart_top 
  
  #(parameter clk_freq ,
    parameter baud_rate )
  
  (input clk,rst,
   input rx,
   input newd,
   input [7:0] dintx,
   
   output [7:0] doutrx,
   output tx,
   output donetx,
   output donerx);
  
  // instantiation
  uarttx #(clk_freq,baud_rate) utx(.clk(clk), .rst(rst), .newd(newd), .tx_data(dintx), .donetx(donetx), .tx(tx));
  
  uartrx #(clk_freq,baud_rate) rtx(.clk(clk), .rst(rst), .rx(rx), .donerx(donerx), .rxdata(doutrx));
  
endmodule
```


## Transmitter
```
module uarttx 
  
  #(parameter clk_freq,
    parameter baud_rate)
  
  (input clk,rst,
   input newd,
   input [7:0] tx_data,
   
   output reg tx,
   output reg donetx);
  
  
  localparam clkcount = (clk_freq/baud_rate);
  
  integer count;
  integer counts;
  
  reg uclk = 0;
  
  // states
  enum bit[1:0] {idle = 2'b00, start = 2'b01, transfer = 2'b10, done = 2'b11} state;
  
  //uart_clk_gen
  always@(posedge clk) begin
    if(count < clkcount/2)
      count <= count + 1;
    
    else begin
      count <= 0;
      uclk <= ~uclk;
    end  
  end
  
  
  reg [7:0] din;
  
  
  //////reset decoder//////////
  
  always@(posedge uclk) begin
    
    if(rst)
      state <= idle;
    
    else begin
      case(state)
        idle : begin
         counts <= 0;
         tx <= 1'b1;
         donetx <= 1'b0;
          
         if(newd) begin
            state <= transfer;
            din <= tx_data;
            tx <= 1'b0;
         end
                
         else
            state <= idle;
       end
                  
        
        transfer : begin
          if(counts<= 7) begin
            counts <= counts+1;
            tx <= din[counts];
            state <= transfer;
          end
          
          else begin
            counts <= 0;
            tx <= 1'b1;
            state <= idle;
            donetx <= 1'b1;
          end
        end
            
        
        default : state <= idle;
      endcase
    end
  end
  
endmodule
```          


## Reciever
```
module uartrx
  
  #(parameter clk_freq,
    parameter baud_rate)
  
  (input clk,rst,
   input rx,
   
   output reg [7:0] rxdata,
   output reg donerx);
  
  
  localparam clkcount = (clk_freq/baud_rate);
  
  integer counts;
  integer count;
  
  reg uclk = 0;
  
  //states
  enum bit [1:0] { idle = 2'b00, start = 2'b01} state;
  
  //uart_clk_gen
  always@(posedge clk) begin
    if(count < clkcount/2) 
      count <= count + 1;
    
    else begin
      count <= 0;
      uclk <= ~uclk;
    end
    
  end
  
  
  
  always@(posedge uclk) begin
    
    if(rst) begin
      rxdata <= 8'h00;
      donerx <= 1'b0;
      counts <= 0;
    end
    
    else begin
      
      case(state)
        
        idle : begin
          rxdata <= 8'h00;
          donerx <= 1'b0;
          counts <= 0;
          
          if(rx == 1'b0) 
            state <= start;
          
          else
            state <= idle;
          
        end
        
        
        start : begin
          if(counts <= 7) begin
            counts <= counts+1;
            rxdata <= {rx,rxdata[7:1]};
          end
          
          else begin
            counts <= 0;
            donerx <= 1;
            state <= idle;
          end
          
        end
        
        default : state <= idle;
        
      endcase
      
    end
    
  end
  
endmodule
```


# Test Bench
## 1.Interface
```
interface uart_if;
  logic uclktx;  // uart transmit clk
  logic uclkrx;  // uart recieve clk
  
  logic clk;
  logic rst;
  
  logic rx;   //incoming rx data
  logic [7:0] doutrx;
  logic donerx;
  
  logic newd;
  logic [7:0] dintx;
  logic tx;   // outgoing tx data
  logic donetx;
  
endinterface;
```

## 2.Transaction
```
class transaction;
  
  typedef enum bit { WRITE = 1'b0, READ = 1'b1} oper_type;
  
  randc oper_type oper;
  rand bit [7:0] dintx;
  bit [7:0] doutrx;
  
  bit newd,tx,rx,donetx,donerx;
  
  
  // deep copy 
  function transaction copy();
    copy = new();
    copy.tx = this.tx;
    copy.rx = this.rx;
    copy.donetx = this.donetx;
    copy.donerx = this.donerx;
    copy.newd = this.newd;
    copy.dintx = this.dintx;
    copy.doutrx = this.doutrx;
    copy.oper = this.oper;
  endfunction
  
endclass
```


## 3.Generator
```
class generator;
  
  transaction tr;
  mailbox #(transaction) gen2drv;
  
  event done;
  event drvnext;
  event sconext;
  
  int count = 0;
  
  function new(mailbox #(transaction) gen2drv);
    this.gen2drv = gen2drv;
    tr = new();
  endfunction
  
  task run();
    repeat(count) begin
      assert(tr.randomize()) else $error("[GEN] : Randomization Failed");
      gen2drv.put(tr.copy);
      $display("[GEN] : OPERATION : %0s, Din: %0d",tr.oper.name(), tr.dintx);
      @(drvnext);
      @(sconext);
    end
    -> done;
  endtask
  
endclass
```

## 4.Driver
```
class driver;
  
  virtual uart_if vif;
  
  transaction tr;
  
  mailbox #(transaction) gen2drv;
  mailbox #(bit [7:0]) drv2scr;
  
  event drvnext;
  
  bit [7:0] din;
  
  bit wr = 0;   //random operation read/write
  bit [7:0] datarx;    // data recieved during read
  
  function new(mailbox #(transaction) gen2drv, mailbox #(bit [7:0]) drv2scr);
    this.gen2drv = gen2drv;
    this.drv2scr = drv2scr;
  endfunction
  
  //reset task
  task reset();
    vif.rst <= 1'b1;
    vif.newd <= 1'b0;
    vif.dintx <= 0;
    vif.rx <= 1'b1;
    
    repeat(5) @(posedge vif.uclktx);
    vif.rst <= 1'b0;
    @(posedge vif.uclktx);
    $display("[DRV] : RESET DONE");
    $display("------------------------------------------");
  endtask
  
  
  
  task run();
    forever begin
      gen2drv.get(tr);
      
      if(tr.oper == 1'b0) begin // data transmission operation
        
        @(posedge vif.uclktx);
        vif.rst <= 1'b0;
        vif.newd <= 1'b1;
        vif.rx <= 1'b1;
        
        vif.dintx <= tr.dintx;
        
        @(posedge vif.uclktx);
        vif.newd <= 0;
        drv2scr.put(tr.dintx);
        $display("[DRV] : DATA SENT : %0d",tr.dintx);
        wait(vif.donetx == 1'b1);
        ->drvnext;
        
      end
      
      
      else if(tr.oper == 1'b1) begin  //read operation
        
        @(posedge vif.uclkrx);
        vif.rst <= 1'b0;
        vif.rx <= 1'b0;
        vif.newd <= 1'b0;
        
        @(posedge vif.uclkrx);
        
        for(int i=0; i<=7 ; i++) begin
          @(posedge vif.uclkrx);
          vif.rx <= $urandom;
          datarx[i] = vif.rx;
        end
        
        drv2scr.put(datarx);
        
        $display("[DRV] : DATA RECIEVED : %0d",datarx);
        wait(vif.donerx == 1'b1);
        vif.rx <= 1'b1;
        ->drvnext;
        
      end
      
    end
    
  endtask
  
endclass
```

## 5.Monitor
```
class monitor;
  
  virtual uart_if vif;
  
  transaction tr;
  
  mailbox #(bit [7:0]) mon2scr;
  
  bit [7:0] srx;   //send
  bit [7:0] rrx;   //recieve
  
  function new(mailbox #(bit [7:0]) mon2scr);
    this.mon2scr = mon2scr;
  endfunction
  
  
  task run();
    
    forever begin
      
      @(posedge vif.uclktx);
      
      if((vif.newd == 1'b1) && (vif.rx == 1'b1)) begin
        
        @(posedge vif.uclktx); //start collecting tx data from next clock tick into srx[7:0]
        
        for(int i=0; i<=7 ; i++) begin
          @(posedge vif.uclktx);
          srx[i] = vif.tx;
        end
        
        $display("[MON] : DATA SENT ON UART TX %0d",srx);
        
        @(posedge vif.uclktx);
        mon2scr.put(srx);
        
      end
      
    
      else if((vif.rx == 1'b0) && (vif.newd == 1'b0)) begin  //collects the data in rrx which is stored in doutrx[7:0] 
        
        wait(vif.donerx == 1);
        rrx = vif.doutrx;
        $display("[MON] : DATA RECIEVED RX %0D",rrx);
        
        @(posedge vif.uclktx);
        mon2scr.put(rrx);
        
      end
      
    end
    
  endtask
  
  
endclass
```

## 6.Scoreboard
```
class scoreboard;
  
  mailbox #(bit [7:0]) drv2scr;
  mailbox #(bit [7:0]) mon2scr;
  
  bit [7:0] d2s;
  bit [7:0] m2s;
  
  event sconext;
  
  function new(mailbox #(bit [7:0]) drv2scr,mailbox #(bit [7:0]) mon2scr);
    this.drv2scr = drv2scr;
    this.mon2scr = mon2scr;
  endfunction
  
  
  task run();
    
    forever begin
      
      drv2scr.get(d2s);
      mon2scr.get(m2s);
      
      $display("[SCR] : DRV : %0d | MON : %0d", d2s,m2s);
      
      if(d2s == m2s)
        $display("DATA MATCHED");
      
      else
        $display("DATA MISMATCHED");
      
      $display("------------------------------------------");
      
      ->sconext;
      
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
  
  event nextgd;   // gen - > drv
  event nextgs;   // gen - > scr
  
  mailbox #(transaction) gen2drv;
  mailbox #(bit [7:0]) drv2scr;
  mailbox #(bit [7:0]) mon2scr;
  
  virtual uart_if vif;
  
  
  function new(virtual uart_if vif);
    
    gen2drv=new();
    drv2scr=new();
    mon2scr=new();
    
    gen = new(gen2drv);
    drv = new(gen2drv,drv2scr);
    
    mon = new(mon2scr);
    scr = new(drv2scr, mon2scr);
    
    this.vif = vif;
    
    drv.vif = vif;
    mon.vif = vif;
    
    gen.sconext = nextgs;
    scr.sconext = nextgs;
    
    gen.drvnext = nextgd;
    drv.drvnext = nextgd;
    
  endfunction
  
  
  task pre_test();
    drv.reset();
  endtask
  
  task test();
    fork
      gen.run();
      drv.run();
      mon.run();
      scr.run();
    join_any
    
  endtask
  
  
  task post_test();
    wait(gen.done.triggered);
    $finish();
  endtask
  
  
  task run();
    pre_test();
    test();
    post_test();
  endtask
  
  
endclass
```


## 9.Test
```
module tb;
  
  uart_if vif();
  
  uart_top #(1000000,9600) dut (vif.clk,
                                vif.rst,
                                vif.rx,
                                vif.newd,
                                vif.dintx,
                                
                                vif.doutrx,
                                vif.tx,
                                vif.donetx,
                                vif.donerx);
  
  
  initial begin
    vif.clk <= 0;
  end
  
  always #10 vif.clk <= ~vif.clk;
  
  environment env;
  
  initial begin
    env = new(vif);
    env.gen.count = 10;
    env.run();
  end
  
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1,tb);
  end
  
  
  assign vif.uclktx = dut.utx.uclk;
  assign vif.uclkrx = dut.rtx.uclk;
  
endmodule
```    
    
