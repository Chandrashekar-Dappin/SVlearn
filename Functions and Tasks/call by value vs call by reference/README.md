##  1. Call by Value (default behavior)
### A copy of the actual argument is passed.
### Changes inside the function do not affect the original variable.
```
task display_val(int a); // call by value
  a = a + 10;
  $display("Inside task: a = %0d", a);
endtask

initial begin
  int x = 5;
  display_val(x);
  $display("Outside task: x = %0d", x); // x is still 5
end

```

## 2. Call by Reference (ref)
### The original variable is passed directly.
### Any modification inside the task/function affects the actual variable.
```
task display_ref(ref int a); // call by reference
  a = a + 10;
  $display("Inside task: a = %0d", a);
endtask

initial begin
  int x = 5;
  display_ref(x);
  $display("Outside task: x = %0d", x); // x becomes 15
end

```

## 3. Call by Refernce function
```
module tb;
  
  int a,b,c;
  
  function automatic int add(ref int x,y);
    x=10;
    y=20;
    add=a+b;
  endfunction
  
  initial begin
    
    a =100;
    b =200;
    c = add(a,b);
    
    $display("a = %0d b =%0d c = %0d",a,b,c);
    
  end
  
endmodule
```

## Output
```
a = 10 b =20 c = 30
```
