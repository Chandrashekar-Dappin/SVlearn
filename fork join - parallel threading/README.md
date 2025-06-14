> 3 types :
> 1. fork join : blocks master threads until all child threads are executed
> 2. fork joi_any : blocks master threads until any of child threads is executed then master and child threads exexcute parallely
> 3. fork join_none : It runs all child threads in background parallel to parent threads...first parent thread is executed after child thread is executed if there is same delay
> 4. disable fork : disables fork
> 5. wait fork : blocks the further execution until all the threads of fotk join are executed...similar to fork join.

```
Ex1 :Q1) What is the output of this snippet, tell the gap of compilation as well?

module tb;

For (int i=0; i<5; i++)
begin
fork
$display(" i =%0d",i);
Join_none
end

endmodule

Q2)What is the output of this snippet ?

module tb;

integer i;
initial
begin
for(i=0; i<5; i++) begin
fork
#5;
$display("%0t , i=%0d", $time, i);
join_none
end
end

endmodule

Q3) What is the output of this snippet ?

module tb;

integer i;
initial
begin
for(i=0; i<5; i++) begin
#0;
fork
$display("%0t , i=%0d", $time, i);
join_none
end
end

endmodule

Q4) What is the output of this snippet ?

module tb;

initial
for( int i = 0; i < 3; i++ )
begin
fork
begin
automatic int j = i;
$display( "j : %0d", j );
end
join_none
end
endmodule

Q5) What is the output of this snippet ?

module tb;
static int j;
initial
for( int i = 0; i < 3; i++ )
begin
fork
begin
j=i;
$display( "j : %0d", j );
end
join_none
end
endmodule

Q6) Explain why value of j prints in reverse order?

module tb;
initial
for( int i = 0; i < 5; i++ )

begin
automatic int j = i;
fork
begin
$display( "j : %0d", j );
end
join_none
end
endmodule

Q7) What is the output of this snippet ?

module tb;
initial
for( int i = 0; i < 5; i++ )

begin
int j;
j= i;
fork
begin
$display( "j : %0d", j );
end
join_none
end
endmodule

Q8) What is the output of this snippet ?

module tb;

initial
for( int i = 0; i < 5; i++ )
begin
fork
automatic int j = i;
$display( "j : %0d", j );
join_none
end
endmodule

Q9) What is the output of this snippet ?

module tb;

initial
for( int i = 0; i < 5; i++ )
begin
fork
begin
automatic int j = i;
$display( "j : %0d", j );
end
join_none
end
endmodule


Q10. module fork_join;
 
  initial begin
    
    $display("*BEFORE FORK..JOIN*");                                     
    
    fork
      #15 $display($time,"\tThread A");
      #5  $display($time,"\tThread B");
      #10 $display($time,"\tThread C");
      #2  $display($time,"\tThread D");
    join
	disable fork;
      #7  $display($time,"\tThread E");
 
    $display("*AFTER FORK..JOIN*");
    
    $finish;
  end
endmodule

Q11. module fork_join;
 
  initial begin
    
    $display("*BEFORE FORK..JOIN*");
    
    fork
      begin
        #15 $display($time,"\tThread A");
        #5  $display($time,"\tThread B");
      end
      begin
        #10 $display($time,"\tThread C");
        #2  $display($time,"\tThread D");
      end
    join
    
      #7  $display($time,"\tThread E");
 
    $display("*AFTER FORK..JOIN*");
    
    $finish;
  end
  
endmodule

Q12. module fork_join_any;
 
  initial begin
    
    $display("*BEFORE FORK..JOIN_ANY*");
    
    fork
        #15 $display($time,"\tThread A");
        #5  $display($time,"\tThread B");
        #10 $display($time,"\tThread C");
    Join_any

        #2  $display($time,"\tThread D");
      #12  $display($time,"\tThread E");
 
    $display("*AFTER FORK..JOIN_ANY*");
    
   #30 $finish;
  end
  
endmodule

Q13. module fork_join_any;
 
  initial begin
    
    $display("*BEFORE FORK..JOIN_ANY*");
    
    fork
      begin
        #20 $display($time,"\tThread A");
        #25 $display($time,"\tThread B");
      end
      begin
        #10 $display($time,"\tThread C");
        #2  $display($time,"\tThread D");
      end
    join_any
       #4  $display($time,"\tThread E");
       #3  $display($time,"\tThread F");
 
    $display("*AFTER FORK..JOIN_ANY*");
    
    #30 $finish;
  end
  
endmodule


Q14. module fork_join_none;
 
  initial begin
    
    $display("*BEFORE FORK..JOIN_ANY*");
    
    fork
        #15 $display($time,"\tThread A");
        #5   $display($time,"\tThread B");
        #10 $display($time,"\tThread C");
    join_none
      
        #2  $display($time,"\tThread D");
      #12  $display($time,"\tThread E");
 
    $display("*AFTER FORK..JOIN_NONE*");
    
    #30 $finish;
  end
  
endmodule

Q15. module wait_fork;
 
  initial begin
    $display("*BEFORE_FORK*");
 
 
    fork
      begin
        $display($time,"\tThread A");
        #15;
        $display($time,"\tThread B");
      end
 
      begin
        $display($time,"\tThread C");
        #30;
        $display($time,"\tThread D");
      end
    join_any
 
    $display("*AFTER_FORK*");

    $finish;
  
  end
endmodule

Q16. module wait_fork;
 
  initial begin
    $display("*BEFORE_WAIT_FORK*");
 
 
    fork
      begin
        $display($time,"\tThread A");
        #15;
        $display($time,"\tThread B");
      end
 
      begin
        $display($time,"\tThread C");
        #30;
        $display($time,"\tThread D");
      end
    join_any
    
    wait fork; //waiting for all active fork threads to be finished
 
      $display("*AFTER_WAIT_FORK*");

    $finish;
  
  end
endmodule

Q17. module disable_fork;
 
  initial begin
    $display("*BEFORE_DISABLE_FORK*");
 
 
    fork
      begin
        $display($time,"\tThread A");
        #15;
        $display($time,"\tThread B");
      end
 
      begin
        $display($time,"\tThread C");
        #30;
        $display($time,"\tThread D");
      end
    join_any
    
    fork
      begin
        $display($time,"\tThread A1");
        #15;
        $display($time,"\tThread B1");
      end
 
      begin
        $display($time,"\tThread C1");
        #30;
        $display($time,"\tThread D1");
      end
    join_none
    
    disable fork;
 
    $display("*AFTER_DISABLE_FORK*");

    $finish;
  
  end
endmodule

Q18. module disable_specific_thread;
 
  initial begin
    $display("*BEFORE_DISABLE_SPECIFIC_THREAD*");
 
 
    fork
      begin : A1
        $display($time,"\tThread A");
        #30;
        $display($time,"\tThread B");
      end
 
      begin : B1
        $display($time,"\tThread C");
        #15;
        $display($time,"\tThread D");
      end
    join_any
         
    disable A1;
 
    $display("*AFTER_DISABLE_SPECIFIC_THREAD*");

    #50 $finish;
  
  end
endmodule
```
