## Ex : Allocating memory to dynamic array
```
module tb;
  int a[][];
  
  initial begin
    
    a = new[4];
    
    foreach (a[i])
      a[i] = new[3];  //array : '{'{0, 0, 0} , '{0, 0, 0} , '{0, 0, 0} , '{0, 0, 0} }
    
    foreach(a[i,j])
      a[i][j] = {$random}%30;
    
    $display("array : %p",a);
    
  end
  
endmodule
      
      
//Output
//array : '{'{8, 27, 7} , '{17, 27, 17} , '{5, 22, 21} , '{19, 18, 17} }

```

## Ex2 : Initialising without declaring size
```
module tb;
  int a[][];
  
  initial begin
    
    a = new[4];
    
    foreach (a[i])
      a[i] = '{'{8, 27, 7} , '{17, 27, 17} , '{5, 22, 21} , '{19, 18, 17} }
    
    $display("array : %p",a);
    
  end
  
endmodule
      
      
//Output
//array : '{'{8, 27, 7} , '{17, 27, 17} , '{5, 22, 21} , '{19, 18, 17} }
```

## Ex3 : Irregular column allocation
```
module tb;
  int a[][];
  
  initial begin
    
    a = new[4];
    
    // a[0] = new[3];  this can also be done
    // a[1] = new[5];
    // a[2] = new[1];
    // a[3] = new[2];
    
    foreach (a[i])
      a[i] = new[{$random}%7];
    
    $display("array : %p",a);
    
  end
  
endmodule
      
      
//Output
//array : '{'{0, 0, 0} , '{0, 0} , '{0, 0} , '{0, 0} }
```

## Ex4 : Initialising 3D array without new[]
```
module tb;
  
  int arr[][][];
  
  initial begin
    
    arr = new[5];
    
    
    
    foreach (arr[i])
      arr[i] = new[$urandom_range(1,5)];
    
    foreach(arr[i,j])
      arr[i][j] = new[$urandom_range(1,6)];
    
    $display("arr : %p",arr);

    /*or manually when we want definite memories
     foreach (arr[i])
      arr[i] = new[4];
    
    foreach(arr[i,j])
      arr[i][j] = new[2];
    
    $display("arr : %p",arr);
    */
    
  end
  
endmodule

//output
arr : '{'{'{0, 0, 0, 0, 0, 0} , '{0, 0, 0, 0, 0} , '{0, 0, 0, 0} , '{0} }, '{'{0, 0, 0, 0, 0, 0} }, '{'{0, 0, 0, 0, 0, 0} , '{0, 0, 0} , '{0, 0, 0} , '{0, 0, 0, 0, 0, 0} }, '{'{0, 0, 0, 0, 0, 0} }, '{'{0} , '{0, 0, 0} , '{0, 0, 0, 0, 0, 0} }}
```


## Ex5: initialising 3D array..    int a[][$][*];     // all are of 2 sizes
```
module tb;
  
  int a[][$][*];     // all are of 2 sizes
  
  initial begin
    
    a='{ '{ '{1:100,2:00},'{3:300,4:400} }, '{ '{5:500,6:600},'{7:700,8:800} } };    //innermost is assoc. of size 2, outside is queue of size 2, outermost is dynamic array of 2 queues
    
    $display("a = %p",a);
    
  end
  
endmodule

//output
a = '{'{'{0x1:100, 0x2:0} , '{0x3:300, 0x4:400} }, '{'{0x5:500, 0x6:600} , '{0x7:700, 0x8:800} }}

```

