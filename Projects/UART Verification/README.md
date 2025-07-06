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


## /////////////////////Transmitter///////////////////////
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


## ////////////////Reciever//////////////////
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
