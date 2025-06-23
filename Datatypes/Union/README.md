## Union represents a single piece of storage element which can be accessed by any of its members.
## Only one member is used at a time.

## Ex:Packed union members must have same size.
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
