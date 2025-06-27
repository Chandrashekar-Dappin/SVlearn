## Union represents a single piece of storage element which can be accessed by any of its members.
## Only one member is used at a time.

## In SystemVerilog, a union is a user-defined data type where all members share the same memory location. This means only one member holds a valid value at a time, and writing to one member overwrites the others.

## 🔹 Why Use a Union?
```
To reinterpret the same bits in different ways

To save memory (all members share the same space)

Often used in testbenches, protocol parsers, or bit manipulations

## Ex:Packed union members must have same size.

```
```
module tb;
  
  union packed{byte a;
               bit[7:0] b;
         byte c;
        } my_un;
  
  initial begin
    my_un.a = 8'hff;
    $displayh(my_un.b);
    my_un.c = -8'd26;
    $displayh(my_un.b);
  end
  
endmodule

 //output
ff
e6
```
