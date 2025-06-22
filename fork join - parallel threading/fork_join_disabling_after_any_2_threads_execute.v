module threads;
  
  int count = 0;
  
  initial begin
    fork 
     begin
       #($urandom_range(1,15));
       $display("thread 1 at %0t ",$time);
       count++;
     end
    
    begin
      #($urandom_range(1,15));
      $display("thread 2 at %0t ",$time);
      count++;
     end
    
    begin
      #($urandom_range(1,15));
      $display("thread 3 at %0t",$time);
      count++;
    end
    
    begin
      wait(count == 2);
      $display("2 threads completed at %0t disabling fork",$time);
      disable fork;
    end
        
        
  join
      
 end
     
      
endmodule
    
        
        
      
      
