## Ex1 :
```
module test;
  event done_a;
  event done_b;
  
  initial begin
    fork 
      begin                          //10
        #5 $display($time," Th A");  //5
      -> done_a;                     //5
      end
      
      begin                          //0
        #10 $display($time," Th B"); //10
        -> done_b;                   //10
      end
      
    join_none                       //0
    
    fork                            //0
      begin                         //0
        @(done_a);                  //5
        $display($time," Th C");    //5
      end
      
      begin                         //0
        @(done_b);                  //10
        $display($time," Th D");    //10
      end
      
    join                            //10
  end
  
endmodule

//Output
                   5 Th A
                   5 Th C
                  10 Th B
                  10 Th D
```

