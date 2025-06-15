## ✅ Summary Table
## Method	Description :
> exists(key)	:Check if a key is present

> delete(key)	:Delete a specific key

> delete(*)	:Clear entire associative array

> num()	:Get total number of entries

> first(var) :Get the first key

> last(var)	:Get the last key

> next(var)	:Get the next key after var

> prev(var)	:Get the previous key before var

## Ex:
```
module assoc_array_methods;

  int a[int];  // associative array with int keys
  int key;

  initial begin
    // Add elements
    a[3] = 30;
    a[1] = 10;
    a[7] = 70;
    a[5] = 50;

    // 1. exists()
    if (a.exists(3))
      $display("✔ Key 3 exists with value = %0d", a[3]);

    // 2. num()
    $display("🔢 Number of entries: %0d", a.num());

    // 3. first()
    if (a.first(key))
      $display("🚩 First key: %0d", key);

    // 4. last()
    if (a.last(key))
      $display("🏁 Last key: %0d", key);

    // 5. next()
    key = 3;
    if (a.next(key))
      $display("➡ Next key after 3: %0d", key);

    // 6. prev()
    key = 5;
    if (a.prev(key))
      $display("⬅ Previous key before 5: %0d", key);

    // 7. delete(key)
    a.delete(1);
    $display("❌ Deleted key 1");
    $display("Remaining entries after delete(1):");
    foreach (a[k])
      $display("a[%0d] = %0d", k, a[k]);

    // 8. delete(*)
    a.delete(*);
    $display("🧹 All entries deleted. Total = %0d", a.num());
  end

endmodule

//Output
? Key 3 exists with value = 30
? Number of entries: 4
? First key: 1
? Last key: 7
? Next key after 3: 5
? Previous key before 5: 3
? Deleted key 1
Remaining entries after delete(1):
a[3] = 30
a[5] = 50
a[7] = 70
? All entries deleted. Total = 0
```
