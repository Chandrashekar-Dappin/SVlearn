## The enum (enumeration) keyword in SystemVerilog is used to create a user-defined data type consisting of a set of named integral constants.
## Important in making state machines.
## It has 'int' as default index...or we can provide signed or unsigned index like logic[1:0]...but it must be of INTEGRAL TYPE. it shoild not be STRING type.
## NOTE : enum are stored as 'int' unless specified.
## First member gets value 0 , then goes on....we can give different values to members if required...but 2 different members cannot have same value.( enum { RED , BLUE = 3, GREEN = 3} colour; ------> illegal ).
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

## accessing enum using for loop
```
module tb;
  
  typedef enum {ONE,TWO, THREE,FOUR} numbers;
  
  numbers num;
  
  initial begin
    
//     num = num.first;
//     $display("number: %s",num.name);
//     num = num.next;
//     $display("number: %s",num.name);
    
    for(int i=0; i<4; i++) begin
      num = numbers'(i);
      $display("numbers: %s",num.name);
    end
    

  end
  
endmodule

//output
numbers: ONE
numbers: TWO
numbers: THREE
numbers: FOUR
```

## Illegal enum declaration

## if any of value is undeclared , the next value must be  declared with valid value else it will throw error 
```
module tb;
  
  typedef enum logic [1:0] { s1=2'bxx, s2,s3,s4} states;
  
  states st;
  
  initial begin
    
    foreach(st[i]) begin
      st[i] = states'(i);
      $display(" states : %s", st.name);
    end
    
  end
  
endmodule

//ERROR
Cannot create implicit value for enum label 's2' of the enum 'states' due to
presence of x/z in enum label 's1'
Specify an explicit value for the enum label
```
