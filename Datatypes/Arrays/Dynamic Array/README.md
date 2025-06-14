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

## Ex4 : Array reduction methods
```
module tb;
  int a[];
  
  initial begin
    $display("array size before initialisation is %0d",a.size());
    
    a='{1,2,3,4,5,6};
      
    $display("array : %p",a);
    $display("array sum : %0d",a.sum);
    $display("array product: %0d",a.product);
    $display("array and: %0d",a.and);
    $display("array or : %0d",a.or);
      
  end
  
endmodule

//Output
array size before initialisation is 0
array : '{1, 2, 3, 4, 5, 6} 
array sum : 21
array product: 720
array and: 0
array or : 7
```

