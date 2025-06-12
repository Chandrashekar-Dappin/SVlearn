> 3 types :
> 1. fork join : blocks master threads until all child threads are executed
> 2. fork joi_any : blocks master threads until any of child threads is executed then master and child threads exexcute parallely
> 3. fork join_none : It runs all child threads in background parallel to parent threads...first parent thread is executed after child thread is executed if there is same delay
>
> Ex1 :
