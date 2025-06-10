## By default constraints are hard constraints. they cannot be overridden or conflicted.

## In normal case if we write in-line constraint with normal constraint it will be added to it if they are in common range. if they are conflicted randomization won't happen.

## Soft constraint : in this case,in-line constraints will override the existing constraints.

## Ex: constraint c1 { soft addr>100; addr<200; }  // 'soft' keyword is used.

## NOTE : whichever member needs to be overridden , we should add prefix 'soft' to it.

## Ex:
```
class packet;
  rand bit [7:0] a;
  rand bit [7:0] b;
  
  constraint c1{ soft a>=50; a<=100; soft b>100; b<=200;}  // a and b are mentioned as 'soft'
  
endclass

module tb;
  packet p;
  
  initial begin
    p = new();
    
    repeat(5) begin
      p.randomize() with {p.a<50 ; p.b<100;};   // a and b constraints are overridden
      $display("a = %0d | b = %0d",p.a,p.b);
    end
    
  end
  
endmodule

//Output
a = 43 | b = 44
a = 19 | b = 81
a = 0 | b = 20
a = 17 | b = 3
a = 18 | b = 27
```


