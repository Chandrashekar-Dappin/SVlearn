## we cannot directly initialise the assoc.. array first we need to define the keys..then we can modify those values using foreach loop.

## Ex1: initialising for string index
```
module assoc_array_example;

  // Declare an associative array with string indices
  int assoc_array[string];

  // Declare a dynamic array of strings to use as keys
  string keys[] = '{"apple", "banana", "grape"};

  initial begin
    // Initialize associative array using the keys array
    foreach (keys[i]) begin
      assoc_array[keys[i]] = 0;  // Assign value 0 to each key
    end

    // Display the initialized associative array
    foreach (assoc_array[key]) begin
      $display("assoc_array[%s] = %0d", key, assoc_array[key]);
    end
  end

endmodule

```

## Ex2: Initialising for int index
```

module assoc_array_int_example;

  // Declare associative array with integer index
  int assoc_array[int];

  initial begin
    // Step 1: Create keys and assign default values using a for loop
    for (int i = 0; i < 10; i++) begin
      assoc_array[i] = 0;  // Initial dummy value
    end

    // Step 2: Modify values using foreach loop
    foreach (assoc_array[i]) begin
      assoc_array[i] = i * 2;
    end

    // Step 3: Display contents using foreach loop
    $display("Associative array contents:");
    foreach (assoc_array[i]) begin
      $display("assoc_array[%0d] = %0d", i, assoc_array[i]);
    end
  end

endmodule

//output
assoc array : '{0x0:0, 0x1:1, 0x2:2, 0x3:3}
```
