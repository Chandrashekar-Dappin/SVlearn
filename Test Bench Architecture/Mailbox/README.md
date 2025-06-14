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
