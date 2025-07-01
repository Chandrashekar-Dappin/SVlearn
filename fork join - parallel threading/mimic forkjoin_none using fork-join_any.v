module tb;
    
  initial begin
  fork
    begin
      //dummy thread executes first and comes out
    end
    
    begin
       $display("thread "); 
    end
     
  join_any
  
  $display("mimicked jork-join_none using fork-join_any");
    
  end

endmodule

///Output
// mimicked jork-join_none using fork-join_any
// thread 
