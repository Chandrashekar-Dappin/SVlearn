## Ex:
```
class randd;
  reg a;
  rand bit[1:0] b;

  constraint s { b inside {[0:3]}; }

  function void post_randomize();
    case (b)
      2'b00: a = 0;
      2'b01: a = 1;
      2'b10: a = 1'bx;
      2'b11: a = 1'bz;
    endcase
  endfunction
endclass

module test;

  randd r;

  initial begin
    r = new();
    repeat (5) begin
      void'(r.randomize());
      $display("a = %b", r.a);
    end
  end
endmodule

//Output
a = 0
a = 0
a = x
a = z
a = 0
```
