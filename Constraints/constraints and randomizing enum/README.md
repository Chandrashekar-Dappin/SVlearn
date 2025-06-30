## Enum can be constrained and randomized.

## Ex:
```
class packet ;
  
  typedef enum {FETCH,DECODE,READ,WRITE} pipeline;
  
  rand pipeline pipe;
  
  constraint c1 { pipe >= 1;}
  

  
endclass


module tb;
  
  initial begin
    
    packet p = new();
    
    repeat(10)begin
      assert(p.randomize())
        $display("enum value = %s",p.pipe.name);
      
    end
    
  end
  
endmodule

//Output
enum value = READ
enum value = READ
enum value = DECODE
enum value = WRITE
enum value = READ
enum value = DECODE
enum value = READ
enum value = WRITE
enum value = DECODE
enum value = DECODE
```
