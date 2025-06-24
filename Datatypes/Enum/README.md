## The enum (enumeration) keyword in SystemVerilog is used to create a user-defined data type consisting of a set of named integral constants.
## Important in making state machines.
## It can have any type of index and scattered index.
## NOTE : enum are stored as 'int' unless specified.
## First member gets value 0 , then goes on....we can give different values to members if required
# Example
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

# Output
```
The first member of enum datatype is RED
The next member of enum datatype is BLUE
The next member of enum datatype is RED
```
