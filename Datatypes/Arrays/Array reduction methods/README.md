## 🧠 SystemVerilog Array Reduction Methods:
## Reduction methods apply operations (like sum, product, min, max, etc.) across all elements of an array and return a single value
## ✅ You can use array reduction methods only on: DYNAMIC ARRAY and QUEUE but not on FIXED ARRAY and ASSOCIATIVE ARRAY.
## Both dynamic arrays and queues support reduction methods like:
## .sum()
## .product()
## min()
## .max()
## .and(), .or(), .xor() — bitwise reductions

## Ex:
```
module array_reduction;
  int a[] = '{6,4,7,5,1,3,2};
  
  initial begin
    
    $display("sum of array : %0d", a.sum);
    $display("product of array : %0d", a.product);
    
    $display("bitwise and of sorted array : %0d", a.and);
    
    $display("bitwise xor array : %0d", a.xor);
    
  end
  
endmodule
    

//Output
sum of array : 28
product of array : 5040
bitwise and of array : 0
bitwise xor array : 0
```
