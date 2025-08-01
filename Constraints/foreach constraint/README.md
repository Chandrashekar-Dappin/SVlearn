## foreach constraint : used for randomising the values of arrays..

## Ex1 : randomising values of 1D array between 0-100

```

class packet;
  
  rand int arr[10];

  constraint c1 { foreach(arr[i])
                    arr[i] inside {[0:100]};
                }
endclass

module tb;
  
  packet p1;
  
  initial begin
    p1 = new();
    
    assert(p1.randomize())
      $display("p1 : array elements : %0p ",p1.arr); 

  end
  
endmodule

// Output
p1 : array elements : '{21, 94, 20, 74, 4, 11, 99, 16, 55, 55}
```

## Ex2 : write a constraint to i) randomize dynamic array size to 10-15  ii) on each location it should generate unique even number iv) array must be sorted in ascending order

```
class packet;
  
  rand int array[];
  
  constraint c1 { array.size>=10 && array.size<=15; }
  
  constraint c2 { foreach (array[i]) 
                    array[i]>0 && array[i]<100; }
  
  constraint c3 { foreach (array[i]) 
                    array[i] % 2 == 0; }
  
  constraint c4 { foreach (array[i])
                    if(i>=1)
                      array[i-1]<array[i] ; }
  
endclass


module tb;
  packet p;
  
  initial begin
    p = new();
    
    assert(p.randomize())
      $display("array = %0p",p.array);
    
  end
  
endmodule

//Output
array = '{4, 6, 8, 20, 22, 34, 38, 44, 46, 48, 80}

```

## Ex2 : randomise the size of dynamic array and to generate even values on odd positions, & odd values on even positions between (0-100)
```
class packet;
  
  rand int array[];
  
  constraint c1 { array.size == 10 ; }
  
  constraint c2 { foreach (array[i]) 
                    array[i]>0 && array[i]<100; }
  
  constraint c3 { foreach (array[i]) 
                   if(i%2 == 0)        //it refers to element, takes some value, passes it if it is even then it fits into odd index
                      array[i]%2 != 0; // it refers to index
                
                    else
                      array[i]%2 == 0;
                }  

endclass


module tb;
  packet p;
  
  initial begin
    p = new();
    
    assert(p.randomize())
      $display("array = %0p",p.array);
    
  end
  
endmodule

//Output
array = '{25, 66, 3, 74, 87, 68, 5, 64, 3, 54}
```

## Ex3 : generate 0, 1, 0, 2, 0, 3, 0, 4, ....
```
class packet;
  
  rand int array[];
  
  constraint c1 { array.size == 10 ; }
  
  constraint c2 { foreach (array[i])
                    if(i%2 == 0)
                      array[i] == 0;
                 
                    else
                      array[i] == (i+1)/2;
                }
  
endclass

module tb;
  packet p;
  
  initial begin
    p = new();
    
    assert(p.randomize())
      $display("array = %0p",p.array);
    
  end
  
endmodule

//Output
array = '{0, 1, 0, 2, 0, 3, 0, 4, 0, 5}
```

## Ex4 : randomize an array of real numbers in between (1.000 - 1.999)
## NOTE : $randomize() never generate fractional value
```
class packet;
  real array2[$];
  rand int array[];
  
  constraint c1 { array.size == 10 ; }
  
  constraint c2 { foreach (array[i])
                    array[i] inside {[1000:1999]};
                }
  constraint c3 { foreach (array[i])  //sorting
                    if(i>=1)
                      array[i-1]<array[i]; }
  
  function void post_randomize();
    
    //real array2[$];
    foreach(array[i])
      array2[i] = real'(array[i]) / 1000;
    $display("array = %p",array);
    //$display("array2 = %p",array2);
    
  endfunction
  
  
endclass

module tb;
  packet p;
  
  initial begin
    p = new();
    
    assert(p.randomize());
    $display("array2 = %p",p.array2);
    
  end
  
endmodule

//Output
array = '{1043, 1044, 1047, 1177, 1178, 1180, 1181, 1182, 1185, 1703} 
array2 = '{1.043, 1.044, 1.047, 1.177, 1.178, 1.18, 1.181, 1.182, 1.185, 1.703}
```

## Ex5 : randomize an array and generate 16-bit onehot data
```
class packet;
  rand bit [15:0] arr[10];
  
  constraint c1 { foreach(arr[i])
    // $onehot(arr[i]); //this can also returns onehot values
    $countones(arr[i]) == 1; }
  
  
endclass

module tb;
  packet p;
  
  initial begin
    p = new();
    
    $write("array = '{" );
    
    foreach(p.arr[i]) begin
      assert(p.randomize());
      $write("%b, ",p.arr[i]);
    end
    
    $write("}");
    
  end
  
endmodule

//Output
array = '{0000000000001000, 0010000000000000, 0000000000001000, 0000000000000100, 0000000010000000, 0000000100000000, 0000000010000000, 0001000000000000, 0000000000001000, 0000000000100000, }
```

## Ex6 : randomize 13th bit of 16 bit variable
```
class packet;
  rand bit [15:0] arr;
  
  constraint c1 { foreach(arr[i])
                   if(i == 13)
                     arr[i] inside {[0:1]}; 
                 
                   else
                     arr[i] == 1'b0;
                }
  
endclass

module tb;
  packet p;
  
  initial begin
    p = new();
       
    foreach(p.arr[i]) begin
      assert(p.randomize());
      $display("array : %b ",p.arr);
    end
    
  end
  
endmodule

//Output
array : 0010000000000000 
array : 0000000000000000 
array : 0010000000000000 
array : 0000000000000000 
array : 0000000000000000 
array : 0000000000000000 
array : 0000000000000000 
array : 0000000000000000 
array : 0000000000000000 
array : 0010000000000000 
array : 0010000000000000 
array : 0000000000000000 
array : 0000000000000000 
array : 0010000000000000 
array : 0000000000000000 
array : 0000000000000000
```

## Ex7 : randomize 16 bit variable with 5 non-consecutive ones
```

class packet;
  rand bit [15:0] a;
  
  constraint c { $countones(a) == 5;
                
                foreach(a[i])
                  if(i<15)
                  !(a[i] && a[i+1]);
                  
                
               }
  
endclass


module tb;
  packet p;
  
  initial begin
    p = new();
    
    repeat(5) begin
      assert(p.randomize());
      $displayb(" %b ",p.a);
      
    end
    
  end
  
endmodule

//Output
 1001010010001000 
 0101000010100100 
 1000000010010101 
 0100001001010001 
 0010001000100101
```

## Ex8 : randomize 16 bit variable with 5 consecutive ones
```
class packet;
  rand bit [15:0] N;
  rand bit [3:0] pos;

  constraint pos_range { pos <= 11; } // only positions 0 to 11 for 5-bit fit

  constraint pattern_c {
    N == (16'h1F << pos); // 5 consecutive 1s generated using mask
  }                       // first 0000000000011111 is generated and it is left shifted pos number of times

  function void post_randomize();
    $display("N   = %b", N);
    $display("pos = %0d", pos);
  endfunction
endclass

module test;
  packet p;

  initial begin
    p = new();
    repeat (10) begin
      assert(p.randomize());
    end
  end
endmodule

//Output
N   = 0000000011111000
pos = 3
N   = 0111110000000000
pos = 10
N   = 0000000111110000
pos = 4
N   = 0000000111110000
pos = 4
N   = 0000000000011111
pos = 0
N   = 0000000111110000
pos = 4
N   = 0001111100000000
pos = 8
N   = 0000000011111000
pos = 3
N   = 0000000001111100
pos = 2
N   = 0000011111000000
pos = 6
```

## Ex8 : randomize 16 bit variable with 5 consecutive ones (another method)
```
class packet; 
  rand bit [15:0] N;
  rand bit [3:0] pos;
  constraint c0 { $countones(N) == 5;}
  constraint c1 { pos <= 11;}
  constraint c2 { foreach(N[i])
    if(N[i]==1 && i<15)
      N[i+1] ==1;  }
  
  function void post_randomize(); 
    N = N>>pos;
    $display("N = %b", N);
    $display("pos = %d", pos);
  endfunction
endclass

module test;
  packet p1;
  initial begin 
    p1 = new();
    repeat(10) begin
      assert(p1.randomize());
    end
  end
endmodule

// 🔹 1. foreach(N[i])
// This loops through each bit of the 16-bit vector N[15:0]. The index i goes from 0 to 15.
  
// 🔹 i is the index
// It represents the position in the array N, ranging from 0 to 15.

// 🔹 N[i] is the element
// It refers to the bit value at position i in the 16-bit vector N.

//Output
N = 0000000000011111
pos = 11
N = 0011111000000000
pos =  2
N = 0000001111100000
pos =  6
N = 0000000111110000
pos =  7
N = 0000111110000000
pos =  4
N = 0000111110000000
pos =  4
N = 0000000011111000
pos =  8
N = 1111100000000000
pos =  0
N = 0000000111110000
pos =  7
N = 0000000000011111
pos = 11
```

## Ex9 : constraint for prime number generation
```
class prime;
  rand int a[];

  constraint c1 { a.size() == 10; }

  // Just randomize any values; we'll filter them in post_randomize()
  function void post_randomize();
    int i = 0;
    int n;
    for(int i=0; i<a.size ; i++) begin
      do begin
        n = $urandom_range(2, 100); // Random number between 2 and 100  ...it continuously generate the numbers until the prime number comes
      end while (!is_prime(n));
      a[i] = n;
    end
  endfunction

  // function to check prime 
  function bit is_prime(int N);
    if (N <= 1) return 0;
    for (int j = 2; j*j <= N; j++) begin
      if (N % j == 0)
        return 0;
    end
    return 1;
  endfunction

endclass


module tb;
  prime p;

  initial begin
    p = new();
    assert(p.randomize());
    $display("Prime numbers: %p", p.a);
  end

endmodule

//Output
Prime numbers: '{19, 61, 71, 53, 19, 7, 23, 23, 67, 37}
```

## Ex9 : constraint for prime number generation using only constraint
```
class prime;
  rand int a[];
  int b[$];
  int c[10];
        
  
  constraint c1 { a.size > 100 && a.size < 200; }
  
  constraint c2 { foreach(a[i]) a[i] == prime(i) ; }
  
  function int prime(int N);
    if(N<=1)
      return 2;
    
    for(int j = 2; j <= N/2 ; j++) 
      if(N%j == 0)
        return 2;
    
    return N;
    
  endfunction
  
  function void post_randomize();
    b= a.unique;
    foreach(c[i])
      c[i] = b[i];
  endfunction
  
endclass
  
  module tb;
    prime p;
    
    initial begin
      p = new();
      
      assert(p.randomize());
      $display("array = %p",p.c);
      
    end
    
  endmodule
    

//Output
array = '{2, 3, 5, 7, 11, 13, 17, 19, 23, 29}
```


## VIMP Ex 10: 0,0,1,1,0,0,2,2,0,0,3,3,...........
```
class packet;

  rand int a[12];

  constraint c1 {
    foreach (a[i]) 
      if (i <= 8 && (i % 4 == 0)) 
      {
        a[i]     == 0;
        a[i+1]   == 0;
        a[i+2]   == (i+4)/4;
        a[i+3]   == (i+4)/4;
      }
    
  }

endclass


module tb;
  
  packet p;
  
  initial begin
    
    p = new();
    
    assert(p.randomize());
    $display("a = %p",p.a);
    
  end
  
endmodule

//Output
a = '{0, 0, 1, 1, 0, 0, 2, 2, 0, 0, 3, 3}
```


## Ex11 : creating palindrome of 32 bit number
```
class packet;
  
  rand bit [31:0] a;
  
  constraint c1 {a[31:28] == a[3:0];
                 a[27:24] == a[7:4];
                 a[23:20] == a[11:8];
                 a[19:16] == a[15:12];
                }
  
endclass



module tb;
  
  initial begin
    
    packet p = new();
    
    repeat(10) begin
      assert(p.randomize());
      $display("a = %h",p.a);
    end
    
  end
  
endmodule


//Output
a = 72355327
a = f3f44f3f
a = 09666690
a = 966aa669
a = 7f0110f7
a = 13e44e31
a = 34411443
a = f21ee12f
a = ad3aa3da
a = 23eaae32
```

## Ex12 : fibonacci series 0  1 1 2 3 5 8
```
class packet;
  
  rand int a[10];
  
  constraint c1 { foreach(a[i])
    if(i<=1)
      a[i] == i;
    else
      a[i] == a[i-1] + a[i-2];
                } 
  
endclass



module tb;
  
  initial begin
    
    packet p = new();
    
    assert(p.randomize());
    $display("a = %p",p.a);

    
  end
  
endmodule


//Output
a = '{0, 1, 1, 2, 3, 5, 8, 13, 21, 34}
```

## Ex13 : 1,2,4,8,16,32....
```

class packet;
  
  rand int a[10];
  
  constraint c1 { foreach(a[i])
    //a[i] == 2**i;
    if(i<1)
      a[i] == 1;
    else
      a[i] == a[i-1]*2;
                 
    
                } 
  
endclass



module tb;
  
  initial begin
    
    packet p = new();
    
    assert(p.randomize());
    $display("a = %p",p.a);

    
  end
  
endmodule


//Output
a = '{1, 2, 4, 8, 16, 32, 64, 128, 256, 512}
```

## Ex14 : 2D array problems
![WhatsApp Image 2025-07-16 at 19 39 07_91d91d0d](https://github.com/user-attachments/assets/1a20288d-1f85-4b1c-8eaf-a6e14d4a93d3)
![WhatsApp Image 2025-07-16 at 19 39 07_09292f99](https://github.com/user-attachments/assets/cfd51494-11d1-40f6-bbfb-c183e387743c)

## randomising size of 2D dynamic array
```
class packet;
  
  rand int a[][];
  
  constraint  c1 { a.size == 4; }
  
  constraint c2 { foreach(a[i])
    a[i].size == 3; }
  
  constraint c3 {foreach(a[i,j])
    a[i][j] == i*5;
                }
  
endclass


module tb;
  
  initial begin
    
    packet p = new();
    
    assert(p.randomize());
    
    $display("a : %p",p.a);
    
  end
  
endmodule
     

//Output
a : '{'{0, 0, 0} , '{5, 5, 5} , '{10, 10, 10} , '{15, 15, 15} }                 
```

## 2D array with diagonal elements 5
```
class packet;
  
  rand int a[3][3];
  
  constraint c1 { foreach(a[i,j])
    if(i == j)
      a[i][j] == 5;
    else
      a[i][j] == 0;
   
             }

             
endclass


module tb;
  
  initial begin
    
    packet p = new();
    assert(p.randomize());
    $display("2D array with diagonal elements 5 = %p",p.a);
  end
  
endmodule

//Output
2D array with diagonal elements 5 = '{'{5, 0, 0}, '{0, 5, 0}, '{0, 0, 5}}
```

## Ex15 : array with elements last digit 5
```
class packet;
  
  rand int a[10];
  

  constraint c1 { foreach(a[i]){
                 a[i]%10 == 5;
                 a[i] inside {[100:300]};             
                }
                }

             
endclass


module tb;
  
  initial begin
    
    packet p = new();
    assert(p.randomize());
    $display("elemnets with last digit 5 = %p",p.a);
  end
  
endmodule

//Output
elemnets with last digit 5 = '{165, 145, 235, 285, 185, 285, 285, 195, 145, 165}
```

## Ex16: array [2][4] even numbers and multiple of 4 in first 4 locations and odd numbers and multiples of 5 in next 4 locations
```

class packet;
  
  rand int a[2][4];
  
  constraint c1 {foreach(a[i,j])
    if(i == 0)
      a[i][j]%4 == 0;
    else
      a[i][j]%10 == 5;
                }
  
  constraint c2 {foreach(a[i,j])
    a[i][j] inside {[0:200]};
                }
  


             
endclass


module tb;
  
  initial begin
    
    packet p = new();
    assert(p.randomize());
    $display("arrays = %p",p.a);
  end
  
endmodule

//Output
arrays = '{'{104, 180, 72, 76}, '{85, 185, 185, 95}}
```

## Ex17 : 2's table generation
## first method
```
class packet;
  
  rand int a[10];                     // remember to mention it as 'rand'
  
  constraint  c1 { foreach(a[i])
    if(i<1)
      a[i] == 2;
                  
    else
      a[i] == a[i-1]+2;
                 }
  
endclass

module tb;
  
  initial begin
    
    packet p = new();
    
    assert(p.randomize());
    
    $display("2's multiplication table : %p",p.a);
    
  end
  
endmodule

//Output
2's multiplication table : '{2, 4, 6, 8, 10, 12, 14, 16, 18, 20}
```
## second method
```
class packet;
  
  rand int a[1:11];
  
  constraint  c1 { foreach(a[i])
      a[i] == i*5;
                 }
  
endclass


module tb;
  
  initial begin
    
    packet p = new();
    
    assert(p.randomize());
    
    $display("5's table : %p",p.a);
    
  end
  
  
endmodule
     

//Output
5's table : '{5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55}
```
