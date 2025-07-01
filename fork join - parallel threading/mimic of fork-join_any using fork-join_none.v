//can be done using event controlling

module tb;
  
  event done;
  
  initial begin
    
    fork
      
      begin
        #5 $display("thread 1");
        ->done;
      end
      
      begin
        #10 $display("thread 2");
      end
      
    join_none
    
    @(done);
    $display("outer thread");
    
  end
  
endmodule

// output
// thread 1
// outer thread
// thread 2
