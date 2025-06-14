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
