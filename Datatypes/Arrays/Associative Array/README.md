## Associative array comes into picture when size of array is **unknown and scattered.**
## index of associative array can be of INTEGER or any other type except 'REAL' and 'SHORTREAL' (they are illegal)
## SV allocates memory for an associative element when they are assigned.
## It is kind of key-value data structure similar to dictionary in python.
## If index is specified as *, then array can be indexed by any integral type (int,shortint,longint,byte,bit,reg...)
## you can use negative indexing in SystemVerilog associative arrays — as long as the index type supports negative values, like int or integer.
## NOTE : we can use foreach loop for accessing the elements of associative array.
## NOTE : assoc = '{0,1,2,3,4};     illegal ..cannot initialise it as normal array
```
module tb;
  

  int assoc[int];
  
  initial begin
    
    assoc = '{0,1,2,3,4};     //illegal ..cannot initialise it as normal array
    $display(" assoc : %p",assoc);

  end
  
endmodule
```

## Use Cases of Associative Arrays in SystemVerilog
> Associative arrays are ideal when:

> You don’t know the index range ahead of time

> You need a sparse or non-contiguous index space

> You want fast key-based lookups

> You want something like a dictionary (like in Python)

## Ex1 : accessing the elements of associative array using foreach loop
```
module tb;
  
  int assoc[string];
  
  initial begin
    
    assoc = '{ "JAN" : 1, "fEB" : 100, "MAR" : 200};
    
    //V.IMp : we can access the elements of assoc. array using foreach loop
    
    foreach(assoc[name])
      $display("assoc[%s] = %0d",name,assoc[name]);   //increments alphabetically based on ASCII value
    
    //$display(" Assoc : %p",assoc);
    
  end
  
endmodule

//Output
//increments alphabetically based on ASCII value
assoc[JAN] = 1
assoc[MAR] = 200
assoc[fEB] = 100
```
## Ex2: an associative array with integer keys and string values.
```
module tb;
  
 // string assoc[int];: Creates an associative array with integer keys and string values.
  string assoc[int];
  
  initial begin
    
    assoc = '{-20 : "chandru", 0 : "chirag", 10 : "rahul" };
    
    foreach(assoc[i])
      $display("assoc[%0d] = %s",i,assoc[i]);   
    
    
  end
  
endmodule

//Output
assoc[-20] = chandru
assoc[0] = chirag
assoc[10] = rahul
```

## Ex1:
```
bit enable_config[string];

enable_config["modA"] = 1;
enable_config["modB"] = 0;

if (enable_config["modA"])
  $display("Module A is enabled");
```

## Ex2:🧱 Sparse Memory Modeling
## Model only the accessed memory addresses — efficient in simulation:
```

bit [7:0] mem[int];

mem[0] = 8'hFF;
mem[1024] = 8'hAA;  // No need to define all 1024 addresses
```

## Ex3: foreach loop
```
module foreach_assoc_array;
  int scores[string];

  initial begin
    scores["Alice"] = 90;
    scores["Bob"]   = 80;
    scores["Charlie"] = 85;

    foreach (scores[name])
      $display("%s => %0d", name, scores[name]);
  end
endmodule
```
