## Ex1 : 1D array
```
module tb;
  int a[10];
  
  initial begin
    
    //  a = '{10,20,30,40,45,54,23,32,12,21};   can also be initialised
    for(int i=0; i<10 ;i++) begin
      a[i] = {$random}%51;
    end
    $display("array : %p",a);
    
  end
  
endmodule

// Output
//array : '{26, 42, 28, 41, 21, 26, 44, 37, 12, 31}
```

## Ex2 :
```
module tb;
  int a[10][5];
  
  initial begin
    
    //  a = '{'{10,20,30,40,45},'{10,20,30,40,45}'{10,20,30,40,45}'{10,20,30,40,45}'{10,20,30,40,45}};   can also be initialised
    for(int i=0; i<10 ;i++) begin
      for (int j=0; j<=5 ; j++) 
        a[i][j] = {$random}%51;
    end
    $display("array : %p",a);
    
  end
  
endmodule

// Output
//array : '{'{26, 42, 28, 41, 21}, '{44, 37, 12, 31, 45}, '{42, 43, 43, 6, 37}, '{0, 18, 11, 6, 6}, '{37, 40, 44, 32, 46}, '{1, 10, 5, 28, 36}, '{39, 12, 34, 21, 30}, '{24, 27, 21, 35, 2}, '{46, 37, 44, 44, 13}, '{47, 30, 1, 19, 9}}
```

## Ex3 : using foreach loop
```
module tb;
  int a[10][5];
  
  initial begin
    
    //  a = '{'{10,20,30,40,45},'{10,20,30,40,45}'{10,20,30,40,45}'{10,20,30,40,45}'{10,20,30,40,45}};   can also be initialised
    foreach(a[i,j])
      a[i][j] = (j+1)*10;
    
    $display("array : %p",a);
    
  end
  
endmodule

// Output
//array : '{'{10,20,30,40,45},'{10,20,30,40,45}'{10,20,30,40,45}'{10,20,30,40,45}'{10,20,30,40,45}};
```

## Ex4 :
```
module tb;
  int a[10];
  
  initial begin
    a='{0:5,2:10,4:15,default:7};
    
    $display("array : %p",a);
    
  end
  
endmodule

// // Output
// //array : '{5, 7, 10, 7, 15, 7, 7, 7, 7, 7}


module tb;
  int a[4][3];
  
  initial begin
    a='{'{1,2,3},'{3{7}},'{default:0},'{0,0,0}};
    
    $display("array : %p",a);
    
  end
  
endmodule

// Output
//array : '{'{1, 2, 3}, '{7, 7, 7}, '{0, 0, 0}, '{0, 0, 0}}
```

