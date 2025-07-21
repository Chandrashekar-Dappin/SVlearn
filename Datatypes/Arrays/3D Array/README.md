## 3D array initialisation
```
module arr;
  
  bit[1:0] a[2][2][2];
  
  initial begin
    
   // a = '{'{'{1,2},'{3,4}},'{'{5,6},'{7,8}}};
    foreach (a[i,j,k])
      a[i][j][k] = 0;
    
    $display("arr : %p",a);
    
  end
  
endmodule
```

## Initialising mixed array a[][$][*];
```

module tb;
  
  int a[][$][*];
  
  initial begin
    
   a = '{ '{ '{ 1 : 100, 2 : 200},'{ 3 : 100, 4 : 200}}, '{ '{ 5 : 300 , 6 : 400}, '{ 7 : 300 , 8 : 400}}};
   
//     another method
//     a = new[3];
    
//     a[0][0][0] = 1;
//     a[0][0][1] = 2;
//     a[0][1][0] = 3;
//     a[0][1][1] = 4;
//     a[1][0][0] = 1;
//     a[1][0][1] = 2;
//     a[1][1][0] = 3;
//     a[1][1][1] = 4;
    
    
    $display(a);
    
  end
  
endmodule

```

## Output
```
'{'{'{0x1:100, 0x2:200} , '{0x3:100, 0x4:200} }, '{'{0x5:300, 0x6:400} , '{0x7:300, 0x8:400} }}
```
