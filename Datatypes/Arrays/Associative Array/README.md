## Associative array comes into picture when size of array is **unknown and scattered.**
## index of associative array can be of INTEGER or any other type except 'REAL' and 'SHORTREAL' (they are illegal)
## SV allocates memory for an associative element when they are assigned.
## It is kind of key-value data structure similar to dictionary in python.
## If index is specified as *, then array can be indexed by any integral type (int,shortint,longint,byte,bit,reg...)
## you can use negative indexing in SystemVerilog associative arrays — as long as the index type supports negative values, like int or integer.
## NOTE : we can use foreach loop for accessing the elements of associative array.

## Use Cases of Associative Arrays in SystemVerilog
> Associative arrays are ideal when:

> You don’t know the index range ahead of time

> You need a sparse or non-contiguous index space

> You want fast key-based lookups

> You want something like a dictionary (like in Python)

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
