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

## Ex5 : randomize 13th bit of 16 bit variable
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


