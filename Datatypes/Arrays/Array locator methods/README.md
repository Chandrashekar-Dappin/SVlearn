## Array Locator Methods :

## Array locator methods work on UNPACKED ARRAYS and return QUEUE.

![WhatsApp Image 2025-06-23 at 18 35 22_05597568](https://github.com/user-attachments/assets/69b64a72-3ba1-450f-9ab3-3297d2503e57)
![WhatsApp Image 2025-06-23 at 18 35 22_05597568](https://github.com/user-attachments/assets/3d8e885d-40e6-4035-aaa9-ffd6bfc28fc3)

## Ex:
```
module tb;
  
  int a[7] = '{9,3,4,8,2,1,1};
  int b[$];
  int c[$] = '{1,3,5,7};
  
  initial begin
    
    // no 'with' clause
    b = c.min; $display(b);
    b = c.max; $display(b);
    b = c.unique; $display(b);
    b = c.unique_index; $display(b);
    
    //'with' clause
    b = a.find with (item>3); $display(b);
    b = a.find_index with (item>3); $display(b);
    b = a.find_first with (item>3); $display(b);
    b = a.find_first_index with (item>3); $display(b);
    b = a.find_last with (item==1); $display(b);
    b = a.find_last_index with (item==1); $display(b);
    
  end
  
endmodule

//Output
'{1} 
'{7} 
'{1, 3, 5, 7} 
'{0, 1, 2, 3} 
'{9, 4, 8} 
'{0, 2, 3} 
'{9} 
'{0} 
'{1} 
'{6}
```

