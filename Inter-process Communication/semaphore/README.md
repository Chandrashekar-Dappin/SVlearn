## semaphore is a part of IPC which is used for synchronisation in parallel processing.
## It comes into picture when multiple processes are accessing the shared resource.
## It does the scheduling of processes,

## Ex1: get(); blocks further execution until it gets the required no.of keys.
```
module semaa;
  
  semaphore sema;
  
  initial begin
    
    sema = new(5);   // by default 0 keys are assigned
    
    fork 
      process1;
      process2;
    join
    
  end
  
  task process1;
    sema.get(3);
    $display("process1 at %0t",$time);
    #5 sema.put(3);
  endtask
  
  
  task process2;
    sema.get(3); // blocks upto 5ns until it gets 3 keys 
    $display("process2 at %0t",$time);
    sema.put(3);
  endtask
  
endmodule


//Output
process1 at 0
process2 at 5
```

## Ex2: 
```
module semaa;
  
  semaphore sema;
  
  initial begin
    
    sema = new(5);   // by default 0 keys are assigned
    
    fork 
      process1;
      process2;
    join
    
  end
  
  task process1;
    sema.get(3);
    $display("process1 at %0t",$time);
    #5 sema.put(3);
  endtask
  
  
  task process2;
    sema.get(2); // blocks upto 5ns until it gets 3 keys 
    $display("process2 at %0t",$time);
    sema.put(2);
  endtask
  
endmodule
  
//Output
process1 at 0
process2 at 0
```

## Ex3: try_get()
```
module semaa;
  
  semaphore sema;
  
  initial begin
    
    sema = new(5);   // by default 0 keys are assigned
    
    fork 
      process1;
      process2;
    join
    
  end
  
  task process1;
    sema.get(3);
    $display("process1 at %0t",$time);
    #5 sema.put(3);
  endtask
  
  
  task process2;
    if(sema.try_get(3)) begin 
      $display("process2 at %0t",$time);
      sema.put(3);
    end
    
    else
      $display("could not enough keys at %0t",$time);
  endtask
  
endmodule

//Output
process1 at 0
could not enough keys at 0
```

## Ex4:
```
module semaa;
  
  semaphore sema;
  
  initial begin
    
    sema = new(5);   // by default 0 keys are assigned
    
    fork 
      process1;
      process2;
    join
    
  end
  
  task process1;
    sema.get(3);
    $display("process1 at %0t",$time);
    #5 sema.put(3);
  endtask
  
  
  task process2;
    if(sema.try_get(2)) begin
      $display("process2 at %0t",$time);
      sema.put(2);
    end
    
    else
      $display("could not enough keys at %0t",$time);
  endtask
  
endmodule

//Output
process1 at 0
process2 at 0
```
