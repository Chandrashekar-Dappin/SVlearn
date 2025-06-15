# Array ordering methods are applicable to only DYNAMIC ARRAYS
> ## Method	Description
> 
> .reverse()	Reverses the elements in place
> 
> .sort()	Sorts the array in ascending order
> 
> .rsort()	Sorts in descending order
> 
> .shuffle()	Randomly shuffles the elements

> All these are built-in methods for dynamic arrays only.
> 
## Ex:
```
module kyuu;
  int a[] = '{6,4,7,5,1,3,2};
  
  initial begin
    
    a.reverse;
    $display("reversed array : %p", a);
    a.sort();
    $display("sorted array : %p", a);
    a.rsort();
    $display("reversed sorted array : %p", a);
    a.shuffle();
    $display("shuffled array : %p", a);
    
  end
  
endmodule
    

//Output
reversed array : '{2, 3, 1, 5, 7, 4, 6} 
sorted array : '{1, 2, 3, 4, 5, 6, 7} 
reversed sorted array : '{7, 6, 5, 4, 3, 2, 1} 
shuffled array : '{5, 4, 7, 2, 6, 1, 3}
```

