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
