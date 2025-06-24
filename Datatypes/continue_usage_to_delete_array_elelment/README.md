```
// deleting elements of dynamic array using continue;

module arr_delete;
  
  int arr[0:9];
  int arr2[0:$size(arr)-2];
  int j;
  
  initial begin
  
  foreach(arr[i])
    arr[i] = i*7;
  
  foreach(arr[i]) begin
    if(i==7)
      continue;
    arr2[j] = arr[i];
    j++;
  end
  
    $display("arr2 : %p arr : %p",arr2,arr);
  
  end
  
endmodule


arr2 : '{0, 7, 14, 21, 28, 35, 42, 56, 63}  arr : '{0, 7, 14, 21, 28, 35, 42, 49, 56, 63}
```
  
