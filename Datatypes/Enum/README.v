#Example
```
module tb;
  
  typedef enum { RED, BLUE ,GREEN} color;
  
  color mycolor;
  
  initial begin
    mycolor = mycolor.first;
    $display("The first member of enum datatype is %s",mycolor.name);
    mycolor = mycolor.next;
    $display("The next member of enum datatype is %s",mycolor.name);
    mycolor = mycolor.next(2);
    $display("The next member of enum datatype is %s",mycolor.name);

  end
  
endmodule
```

#Outout
```
The first member of enum datatype is RED
The next member of enum datatype is BLUE
The next member of enum datatype is RED
```
