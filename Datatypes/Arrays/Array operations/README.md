## Following operations are possible for both packed and unpacked arrays.
## NOTE : Both array A & B should be of same type and size.

## Ex: Array slicing and copying
```
module arr;
  
  bit [7:0] a [10];
  bit [7:0] b [10];
  
  initial begin
    a = '{0,1,2,3,4,5,6,7,8,9};
    
    b = a;
    
    $display(" a : %p",a);
    $display(" b : %p",b);
    
    b[0:3] = a[0:3];
    
    $display(" a : %p",a);
    $display(" b : %p",b);  
    
    b[1+:5] = a[5+:5];
    
    $display(" a : %p",a);
    $display(" b : %p",b);
    
    
  end

//Output
 a : '{'h0, 'h1, 'h2, 'h3, 'h4, 'h5, 'h6, 'h7, 'h8, 'h9} 
 b : '{'h0, 'h1, 'h2, 'h3, 'h4, 'h5, 'h6, 'h7, 'h8, 'h9} 
 a : '{'h0, 'h1, 'h2, 'h3, 'h4, 'h5, 'h6, 'h7, 'h8, 'h9} 
 b : '{'h0, 'h1, 'h2, 'h3, 'h4, 'h5, 'h6, 'h7, 'h8, 'h9} 
 a : '{'h0, 'h1, 'h2, 'h3, 'h4, 'h5, 'h6, 'h7, 'h8, 'h9} 
 b : '{'h0, 'h5, 'h6, 'h7, 'h8, 'h9, 'h6, 'h7, 'h8, 'h9}
  
endmodule
```

## Following operations are possible for only packed arrays.
```
module arr;
  
  bit [4:0][7:0] a;

  
  initial begin

    a =1;
    
    $display(" a : %h",a);
    
    a ='1;
    
    $display(" a : %h",a);
    
    a = a&32'd255;
    
    $display(" a : %b",a);
    
    a[3:1] = 16'b1101_1110_0000_1010;
    
    $display(" a : %b",a);
    
    $display(" a : %0d",$size(a));

    $display(" a : %0d",$bits(a));


  end

  
endmodule

//Output
 a : 0000000001
 a : ffffffffff
 a : 0000000000000000000000000000000011111111
 a : 0000000000000000110111100000101011111111
 a : 5
 a : 40
```
