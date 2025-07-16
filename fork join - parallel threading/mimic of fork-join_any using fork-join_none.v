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
thread 1
outer thread
thread 2


// another method : by giving different delays
module tb;
  
  initial begin
    
    fork
      #3 $display("thread A");
      $display("thread B");
      #10 $display("thread C");
    join_none
      
    #1 $display("after fork join_none");
      
  end
      
endmodule

//Output
thread B
after fork join_none
thread A
thread C



