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
