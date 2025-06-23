## Array Query Functions:
> 1. $left : returns left bound of dimension
> 2. $right : returns right bound of dimension
>
> 3. $increment : returns -1 if indexing is in increment order else returns 1
>
> 4. $low : returns lowest index of index
> 5. $high : returns highest index of index
>
> 6. $size : returns the No. of elements in dimesion
>
> 7. $dimensions : returns total No.of dimensions in an array.
> 8. $unpacked_dimensions : returns total No.of unpacked dimensions in an array.
>

## Ex:
```
module tb;
  
  logic [15:0] arr1 [0:63];
  logic [7:0][15:0] arr2[2:0][4:0];
  
  initial begin
    
    $display(" Array1 dimensions :%0d",$dimensions(arr1));
    
    $display("Array2 dimensions :%0d",$dimensions(arr2));
    
    $display(" Array1 unpacked_dimensions :%0d",$unpacked_dimensions(arr1));
    
    $display("Array2 unpacked_dimensions :%0d",$unpacked_dimensions(arr2)); //refers to first unpacked dimension 
    
    $display("left bound of array1 : %0d",$left(arr1));  //refers to first unpacked dimension 
    
    $display("right bound of array1 : %0d",$right(arr1)); //refers to first unpacked dimension 
        
    $display("left bound of array2 : %0d",$left(arr2)); //refers to first unpacked dimension 
    
    $display("right bound of array2 : %0d",$right(arr2)); //refers to first unpacked dimension 
    
    $display("increment of array1 : %0d",$increment(arr1));  //refers to first unpacked dimension 
    
    $display("increment of array2 : %0d",$increment(arr2));  //refers to first unpacked dimension 
    
    $display("size of array1 : %0d",$size(arr1));  //refers to total elements in first unpacked dimension 
    
    $display("size of array2 : %0d",$size(arr2));   //refers to total elements in first unpacked dimension 
    
    
  end
  
endmodule


//Output
 Array1 dimensions :2
Array2 dimensions :4
 Array1 unpacked_dimensions :1
Array2 unpacked_dimensions :2
left bound of array1 : 0
right bound of array1 : 63
left bound of array2 : 2
right bound of array2 : 0
increment of array1 : -1
increment of array2 : 1
size of array1 : 64
size of array2 : 3
```
