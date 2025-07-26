## Code:
```
interface intf;
  
  logic a,b,cin,s,c;
  
endinterface




module FA (intf inf);
  
  assign  {inf.c,inf.s} = inf.a + inf.b + inf.cin;
  
endmodule


 

class transaction extends uvm_sequence_item;
  
  `uvm_object_utils(transaction)
  
  function new(string name = "transaction");
    super.new(name);
  endfunction
  
  rand bit a,b,cin;
  bit s,c;
  
endclass





class generator extends uvm_sequence #(transaction);
  
  `uvm_object_utils(generator)
  
  function new(string name = "generator");
    super.new(name);
  endfunction
  
  //handle creation
  
  rand transaction tr;
  
  virtual task body();
    
    repeat(10) begin
      
      tr = transaction::type_id::create("tr");
      
      start_item(tr);
      
      assert(tr.randomize());
      `uvm_info("GEN",$sformatf("a = %b b = %b cin = %b s = %b cout = %b",tr.a,tr.b,tr.cin,tr.s,tr.c),UVM_NONE)
      
      finish_item(tr);
                
    end
    
  endtask
  
endclass




class sequencer extends uvm_sequencer #(transaction);
  
  `uvm_component_utils(sequencer)
  
  function new(string name = "sequencer",uvm_component parent = null);
    
    super.new(name, parent);
    
  endfunction
  
  
endclass





class driver extends uvm_driver #(transaction);
  
  `uvm_component_utils(driver)
  
  function new(string name = "driver", uvm_component parent = null);
    
    super.new(name,parent);
    
  endfunction
  
  //handle declaration
  transaction tr;
  virtual intf vif;
  
  virtual function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    
    
    if(!(uvm_config_db #(virtual intf) :: get(this," ","vif", vif)))
      `uvm_fatal("DRV","unable to access the interface")
      
      
      tr = transaction :: type_id::create("tr");
    
    
  endfunction
  
  
  
  virtual task run_phase(uvm_phase phase);
    
    super.run_phase(phase);
    
    forever begin
      
    seq_item_port.get_next_item(tr);
    
    vif.a <= tr.a;
    vif.b <= tr.b;
    vif.cin <= tr.cin;
    
      `uvm_info("DRV",$sformatf("a = %b b = %b cin = %b s = %b cout = %b",tr.a,tr.b,tr.cin,tr.s,tr.c),UVM_NONE)
    
    seq_item_port.item_done();
    
    #10;
      
    end
    
  endtask
  
  
  
endclass






class monitor extends uvm_monitor;
  
  `uvm_component_utils(monitor)
  
  function new(string name = "monitor",uvm_component parent = null);
    
    super.new(name,parent);
    
  endfunction
  
  //handle declaration
  transaction tr;
  virtual intf vif;
  uvm_analysis_port #(transaction) send;
  
  virtual function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    
    if(!(uvm_config_db #(virtual intf) :: get(this, " ", "vif", vif)))
      `uvm_fatal("MON","unable to access interface")
    
    //tr = transaction::type_id::create("tr");        cannot be created here....it should be created inside forever loop of run_phase as it needs to be created newly on each iteration
    
    send = new("send",this);
    
  endfunction
  
  
  
  
  virtual task run_phase(uvm_phase phase);
    
    super.run_phase(phase);
    
    repeat(10) begin
      
      #10;
      tr = transaction::type_id::create("tr");
      
      tr.a = vif.a;
      tr.b = vif.b;
      tr.cin = vif.cin;
      tr.s = vif.s;
      tr.c = vif.c;
      
      `uvm_info("MON",$sformatf("a = %b b = %b cin = %b s = %b cout = %b",tr.a,tr.b,tr.cin,tr.s,tr.c),UVM_NONE)
      
      //broadcasting.......write method
      
      send.write(tr);            //mon2scr.put(tr)
      
    end
    
  endtask
  
endclass




class scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(scoreboard)
  
  function new(string name = "scoreboard", uvm_component parent = null);
    
    super.new(name,parent);
    
  endfunction
  
  bit c_ref, s_ref;
  
  transaction tr;
  
  uvm_analysis_imp #(transaction,scoreboard) recv;
  
  
  virtual function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    
    recv = new("recv",this);
    
  endfunction
  
  
  
  function void write(transaction tr);
    
    {c_ref,s_ref} = tr.a+tr.b+tr.cin;
      
    if({tr.c,tr.s} == {c_ref,s_ref})
      `uvm_info("SCB",$sformatf("TEST PASSED : a = %b b = %b cin = %b s = %b cout = %b",tr.a,tr.b,tr.cin,tr.s,tr.c),UVM_NONE)
    
      
    else
      `uvm_info("SCB",$sformatf("TEST FAILED :  a = %b b = %b cin = %b | Expected s = %b cout = %b, Got s = %b cout = %b",tr.a, tr.b, tr.cin,s_ref,c_ref, tr.s, tr.c),UVM_NONE)
        
    $display();
  
  endfunction
        
        
endclass





class agent extends uvm_agent;
  
  `uvm_component_utils(agent)
  
  function new(string name = "agent", uvm_component parent = null);
    
    super.new(name,parent);
    
  endfunction
        
  sequencer sqr;
  driver drv;
  monitor mon;
  
  virtual function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    
    sqr = sequencer::type_id::create("sqr",this);
    drv = driver::type_id::create("drv",this);
    mon = monitor::type_id::create("mon",this);
    
  endfunction
  
  
  virtual function void connect_phase(uvm_phase phase);
    
    super.connect_phase(phase);
    
    drv.seq_item_port.connect(sqr.seq_item_export);
    
  endfunction
  
  
endclass




class environment extends uvm_env;
  
  `uvm_component_utils(environment)
  
  function new(string name = "environment",uvm_component parent = null);
    
    super.new(name,parent);
    
  endfunction
  
  agent agt;
  scoreboard scb;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    agt = agent::type_id::create("agt",this);
    scb = scoreboard::type_id::create("scb",this);
    
  endfunction
    
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    agt.mon.send.connect(scb.recv);
    
  endfunction
  
endclass






class test extends uvm_test;
  
  `uvm_component_utils(test)
  
  function new(string name="test",uvm_component parent = null);
    
    super.new(name,parent);
    
  endfunction
  
  environment env;
  generator gen;
  
  
  virtual function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    
    env = environment::type_id::create("env",this);
    gen = generator::type_id::create("gen");
    
  endfunction
  
  
  virtual task run_phase(uvm_phase phase);
    
    super.run_phase(phase);
    
    //objections
    phase.raise_objection(this);
    
    //running sequence over sequencer
    gen.start(env.agt.sqr);
    
    phase.drop_objection(this);
    
  endtask
  
  
endclass




module top;
  
  intf inf();
  
  FA dut(inf);
  
  initial begin
    
    //setting of config_db
    
    uvm_config_db #(virtual intf)::set(null,"*","vif",inf);
    
    //running test
    
    run_test("test");
    
  end
  
endmodule

```


## Output
```
UVM_INFO @ 0: reporter [RNTST] Running test test...
UVM_INFO testbench.sv(57) @ 0: uvm_test_top.env.agt.sqr@@gen [GEN] a = 0 b = 0 cin = 0 s = 0 cout = 0
UVM_INFO testbench.sv(129) @ 0: uvm_test_top.env.agt.drv [DRV] a = 0 b = 0 cin = 0 s = 0 cout = 0
UVM_INFO testbench.sv(194) @ 10: uvm_test_top.env.agt.mon [MON] a = 0 b = 0 cin = 0 s = 0 cout = 0
UVM_INFO testbench.sv(241) @ 10: uvm_test_top.env.scb [SCB] TEST PASSED : a = 0 b = 0 cin = 0 s = 0 cout = 0
 
UVM_INFO testbench.sv(57) @ 10: uvm_test_top.env.agt.sqr@@gen [GEN] a = 1 b = 0 cin = 1 s = 0 cout = 0
UVM_INFO testbench.sv(129) @ 10: uvm_test_top.env.agt.drv [DRV] a = 1 b = 0 cin = 1 s = 0 cout = 0
UVM_INFO testbench.sv(194) @ 20: uvm_test_top.env.agt.mon [MON] a = 1 b = 0 cin = 1 s = 0 cout = 1
UVM_INFO testbench.sv(241) @ 20: uvm_test_top.env.scb [SCB] TEST PASSED : a = 1 b = 0 cin = 1 s = 0 cout = 1
 
UVM_INFO testbench.sv(57) @ 20: uvm_test_top.env.agt.sqr@@gen [GEN] a = 0 b = 1 cin = 0 s = 0 cout = 0
UVM_INFO testbench.sv(129) @ 20: uvm_test_top.env.agt.drv [DRV] a = 0 b = 1 cin = 0 s = 0 cout = 0
UVM_INFO testbench.sv(194) @ 30: uvm_test_top.env.agt.mon [MON] a = 0 b = 1 cin = 0 s = 1 cout = 0
UVM_INFO testbench.sv(241) @ 30: uvm_test_top.env.scb [SCB] TEST PASSED : a = 0 b = 1 cin = 0 s = 1 cout = 0
 
UVM_INFO testbench.sv(57) @ 30: uvm_test_top.env.agt.sqr@@gen [GEN] a = 1 b = 1 cin = 0 s = 0 cout = 0
UVM_INFO testbench.sv(129) @ 30: uvm_test_top.env.agt.drv [DRV] a = 1 b = 1 cin = 0 s = 0 cout = 0
UVM_INFO testbench.sv(194) @ 40: uvm_test_top.env.agt.mon [MON] a = 1 b = 1 cin = 0 s = 0 cout = 1
UVM_INFO testbench.sv(241) @ 40: uvm_test_top.env.scb [SCB] TEST PASSED : a = 1 b = 1 cin = 0 s = 0 cout = 1
 
UVM_INFO testbench.sv(57) @ 40: uvm_test_top.env.agt.sqr@@gen [GEN] a = 0 b = 0 cin = 1 s = 0 cout = 0
UVM_INFO testbench.sv(129) @ 40: uvm_test_top.env.agt.drv [DRV] a = 0 b = 0 cin = 1 s = 0 cout = 0
UVM_INFO testbench.sv(194) @ 50: uvm_test_top.env.agt.mon [MON] a = 0 b = 0 cin = 1 s = 1 cout = 0
UVM_INFO testbench.sv(241) @ 50: uvm_test_top.env.scb [SCB] TEST PASSED : a = 0 b = 0 cin = 1 s = 1 cout = 0
 
UVM_INFO testbench.sv(57) @ 50: uvm_test_top.env.agt.sqr@@gen [GEN] a = 0 b = 1 cin = 0 s = 0 cout = 0
UVM_INFO testbench.sv(129) @ 50: uvm_test_top.env.agt.drv [DRV] a = 0 b = 1 cin = 0 s = 0 cout = 0
UVM_INFO testbench.sv(194) @ 60: uvm_test_top.env.agt.mon [MON] a = 0 b = 1 cin = 0 s = 1 cout = 0
UVM_INFO testbench.sv(241) @ 60: uvm_test_top.env.scb [SCB] TEST PASSED : a = 0 b = 1 cin = 0 s = 1 cout = 0
 
UVM_INFO testbench.sv(57) @ 60: uvm_test_top.env.agt.sqr@@gen [GEN] a = 1 b = 0 cin = 0 s = 0 cout = 0
UVM_INFO testbench.sv(129) @ 60: uvm_test_top.env.agt.drv [DRV] a = 1 b = 0 cin = 0 s = 0 cout = 0
UVM_INFO testbench.sv(194) @ 70: uvm_test_top.env.agt.mon [MON] a = 1 b = 0 cin = 0 s = 1 cout = 0
UVM_INFO testbench.sv(241) @ 70: uvm_test_top.env.scb [SCB] TEST PASSED : a = 1 b = 0 cin = 0 s = 1 cout = 0
 
UVM_INFO testbench.sv(57) @ 70: uvm_test_top.env.agt.sqr@@gen [GEN] a = 0 b = 0 cin = 1 s = 0 cout = 0
UVM_INFO testbench.sv(129) @ 70: uvm_test_top.env.agt.drv [DRV] a = 0 b = 0 cin = 1 s = 0 cout = 0
UVM_INFO testbench.sv(194) @ 80: uvm_test_top.env.agt.mon [MON] a = 0 b = 0 cin = 1 s = 1 cout = 0
UVM_INFO testbench.sv(241) @ 80: uvm_test_top.env.scb [SCB] TEST PASSED : a = 0 b = 0 cin = 1 s = 1 cout = 0
 
UVM_INFO testbench.sv(57) @ 80: uvm_test_top.env.agt.sqr@@gen [GEN] a = 1 b = 1 cin = 0 s = 0 cout = 0
UVM_INFO testbench.sv(129) @ 80: uvm_test_top.env.agt.drv [DRV] a = 1 b = 1 cin = 0 s = 0 cout = 0
UVM_INFO testbench.sv(194) @ 90: uvm_test_top.env.agt.mon [MON] a = 1 b = 1 cin = 0 s = 0 cout = 1
UVM_INFO testbench.sv(241) @ 90: uvm_test_top.env.scb [SCB] TEST PASSED : a = 1 b = 1 cin = 0 s = 0 cout = 1
 
UVM_INFO testbench.sv(57) @ 90: uvm_test_top.env.agt.sqr@@gen [GEN] a = 1 b = 0 cin = 0 s = 0 cout = 0
UVM_INFO testbench.sv(129) @ 90: uvm_test_top.env.agt.drv [DRV] a = 1 b = 0 cin = 0 s = 0 cout = 0
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_objection.svh(1276) @ 90: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
UVM_INFO /apps/vcsmx/vcs/U-2023.03-SP2//etc/uvm-1.2/src/base/uvm_report_server.svh(904) @ 90: reporter [UVM/REPORT/SERVER] 
```
