## Structure:
## structures & unions are used to group non-homogenous datatypes.
## By default structures are UNPACKED and UNSIGNED
## Unpacked structures can contain ANY DATATYPE.

## Packed Structure:
## packed structure is made up of BIT FIELDS (bit,byte,int,shortint,longint) which are packed together without gap (1D).
## packed str. can be used as a whole to perform arithmetic and logical operations.
## first member of packed str. occupies MSB & subsequent members follow decreasing significance.
## structures can be using 'packed' followed by 'signed' or 'unsigned' keyword.
## Packed str. is always 1D vector.
## NOTE : only packed datatype and integer datatypes are allowed inside packed structures.

## Ex:
```
module tb;
  
  typedef struct {
    string name;
    string num;
    string addr;
  } ID_CARD;
  
  ID_CARD e1,e2,e3;
  
  initial begin
    e1.name = "chandrashekar";
    e1.num = "9148185352";    
    e1.addr = "vijayapur";
    
    e2.name = "chirag";
    e2.num = "8310991090";    
    e2.addr = "vijayapur";
    
    e3.name = "rahul";
    e3.num = "8296161026";    
    e3.addr = "vijayapur";
    
    $display(" Name : %s | Number : %s | Address : %s",e1.name,e1.num,e1.addr);
    $display(" Name : %s | Number : %s | Address : %s",e2.name,e2.num,e2.addr);
    $display(" Name : %s | Number : %s | Address : %s",e3.name,e3.num,e3.addr);
      
  end
  
endmodule

//output
 Name : chandrashekar | Number : 9148185352 | Address : vijayapur
 Name : chirag | Number : 8310991090 | Address : vijayapur
 Name : rahul | Number : 8296161026 | Address : vijayapur
```

## Ex2: packed structure
```
module tb;
  
  typedef struct packed signed{
    shortint a;
    byte b;
    bit [7:0] c;
    //bit [7:0] c[10];   //throws an error saying "Unpacked member found in a packed structure or union:"

  }str1;
  
  str1 pack1;
  bit [7:0] x,y,z;
  
  initial begin
    
    pack1 = '{a : '1 , b : -10, c : 8'b1001_1100};
    
    x = pack1.a;
    y = pack1.b;
    z = pack1[16:9];  // only possible in packed str. coz it is 1D
 
    $display("x = %0d | y = %0d | z = %0d ",x,y,z);
    
  end
  
endmodule

//output
x = 255 | y = 246 | z = 251
```


