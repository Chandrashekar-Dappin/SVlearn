**In SystemVerilog, pre_randomize() and post_randomize() are callback methods that let you insert custom code before and after randomization of a class object.**

**🔹 pre_randomize()**
**This method is automatically called before randomization.**

**You use it to initialize variables or set up constraints.**

**🔹 post_randomize()**
**This method is automatically called after successful randomization.**

**You use it to process randomized values, apply mappings, or do any post-processing logic.**


## Ex:
```
class packet;
  rand bit[7:0]a;
  int b;

  function void pre_randomize();
    $display("Before randomization: a = %0d", a);
  endfunction

  function void post_randomize();
    $display("After randomization: a = %0d", a);
    b = a * 2; // Post-process
  endfunction
endclass

module tb;
  packet p;

  initial begin
    p = new();
    
    repeat(3) begin 
      p.randomize();
      $display("b = %0d", p.b);
    end
    
  end
endmodule

//Output
Before randomization: a = 0
After randomization: a = 185
b = 370
Before randomization: a = 185
After randomization: a = 91
b = 182
Before randomization: a = 91
After randomization: a = 58
b = 116
```
