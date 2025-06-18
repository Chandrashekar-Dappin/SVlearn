> ## MAILBOX : it is a built in class that allows messages to be exchanged between processes.
>
> data is sent by one process and recieved by another.
>
> mailbox is FIFO queue.
>
> mailbox is BOUNDED or UNBOUNDED queue.
>
> mailbox can be PARAMETERISED OR NON-PARAMETERISED.
> 
> ✅ Mailbox Basics Recap
> 
> Operation	Behavior :
> 
> put(item) :	Blocks if mailbox is full until space is available.
> 
> try_put(item)	: Non-blocking put, returns immediately (success/fail).
> 
> get(variable)	: Blocks if mailbox is empty until data is available.
> 
> try_get(var)	: Non-blocking get. If data is present, gets it. Else returns immediately.
> 
> peek(var)	: Reads the oldest entry without removing it (blocking).
> 
> try_peek(var)	: Non-blocking version of peek.

## Ex:
```
module tb;
  mailbox #(int) mb;
  int i;
  
  initial begin
    mb = new(3);  //bounded mailbox
    $monitor(" i = %0d at %0d",i,$time);
  
  fork
    gen_data;
    rec_data;
  join
    
  end
  
  task gen_data;
    mb.put(1);
    #1 mb.put(7);
    #1 mb.put(4);
    #2 mb.put(3);
    #2 void'(mb.try_put(2));
    #10 mb.put(5);
    #2 mb.put(6);           
  endtask
    
   task rec_data;
     #1 mb.peek(i);
     #5 mb.get(i);
     #2 mb.get(i);
     #2 void'(mb.try_get(i));
     #1 mb.get(i);
     #2 void'(mb.try_get(i));
     #2 void'(mb.try_peek(i));
     #2 mb.get(i);
   endtask
               
endmodule


//Output
 i = 0 at 0
 i = 1 at 1
 i = 7 at 8
 i = 4 at 10
 i = 3 at 11
 i = 2 at 13
 i = 5 at 18
```
