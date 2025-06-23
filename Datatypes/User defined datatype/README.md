## User Defined Datatypes:
## New datatypes are created using 'typedef' keyword.

## Ex:
```
module tb;
  
  typedef byte unsigned bit8;
  typedef bit[15:0] word;
  
  bit8 a;
  word b;
  
  initial begin
    a = -8'd1;
    b = 1;
    $display(" a = %0d",a);
    $display("b = %b",b);
  end
  
endmodule
```
