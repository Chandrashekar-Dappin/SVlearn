## Functional coverage can be written as

### coverage declaration inside module
```
module tb;
  
  covergroup cg;
    
    coverpoint a;
    
  endgroup
  
  cg cg1, cg2;
  
  initial begin
    
    cg1 = new();
    cg2 = new();
    
  end
  
endmodule
```


### coverage declaration inside class

```
class packet;
  
  covergroup cg;
    
    coverpoint a;
    
  endgroup
  
  function new();
    
    cg = new();
    
  endfunction
  
endclass
```
```
