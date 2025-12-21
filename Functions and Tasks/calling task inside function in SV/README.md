## A task  cannot be called inside function in verilog... but it can be called in SystemVerilog.
## Rules:
### 1. task with no delay can be directly called inside function
### 2. task with delay can be called inside fork  join_none block inside funtion

```
//calling task inside function

module tb;
  
  int a1=10, b1=20, c1;
  
  task add(input int a,b, output int sum);
    sum = a+b;
    #5 $display("addition successful");
  endtask
  
  function addd(input int x,y,output int z);
    fork
    add(x,y,z);
    join_none
  endfunction
  
  initial begin
    
    addd(a1,b1,c1);
    $display(a1,b1,c1);
    
  end
  
endmodule
```
