## Code;
```
//============================================================
// Interface
//============================================================
interface intf;
  logic a, b, cin, s, c;
endinterface

//============================================================
// DUT
//============================================================
module FA (intf inf);
  assign {inf.c, inf.s} = inf.a + inf.b + inf.cin;
endmodule


//============================================================
// Transaction
//============================================================
class transaction extends uvm_sequence_item;
  `uvm_object_utils(transaction)

  rand bit a, b, cin;
  bit s, c;

  function new(string name = "transaction");
    super.new(name);
  endfunction
endclass

//============================================================
// Generator (Sequence)
//============================================================
class generator extends uvm_sequence#(transaction);
  `uvm_object_utils(generator)

  function new(string name = "generator");
    super.new(name);
  endfunction

  task body();
    transaction tr;
    repeat(10) begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize());
      finish_item(tr);
    end
  endtask
endclass

//============================================================
// Sequencer
//============================================================
class sequencer extends uvm_sequencer#(transaction);
  `uvm_component_utils(sequencer)

  function new(string name = "sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
endclass

//============================================================
// Driver
//============================================================
class driver extends uvm_driver#(transaction);
  `uvm_component_utils(driver)

  virtual intf vif;

  function new(string name = "driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual intf)::get(this, "", "vif", vif))
      `uvm_fatal("DRV", "Unable to access the interface")
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      transaction tr;
      seq_item_port.get_next_item(tr);

      vif.a   <= tr.a;
      vif.b   <= tr.b;
      vif.cin <= tr.cin;

      `uvm_info("DRV", $sformatf("Driving: a=%b b=%b cin=%b", tr.a, tr.b, tr.cin), UVM_NONE)

      seq_item_port.item_done();
      #1; // Wait for DUT
    end
  endtask
endclass

//============================================================
// Monitor
//============================================================
class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)

  transaction tr;
  virtual intf vif;
  uvm_analysis_port#(transaction) send;

  function new(string name = "monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual intf)::get(this, "", "vif", vif))
      `uvm_fatal("MON", "Unable to access the interface");
    send = new("send", this);
  endfunction

  task run_phase(uvm_phase phase);
    repeat(10) begin
      #1;
      tr = transaction::type_id::create("tr");
      tr.a   = vif.a;
      tr.b   = vif.b;
      tr.cin = vif.cin;
      tr.s   = vif.s;
      tr.c   = vif.c;

      `uvm_info("MON", $sformatf("Sampled: a=%b b=%b cin=%b s=%b c=%b", tr.a, tr.b, tr.cin, tr.s, tr.c), UVM_NONE)

      send.write(tr);
    end
  endtask
endclass

//============================================================
// Scoreboard
//============================================================
class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

  uvm_analysis_imp#(transaction, scoreboard) recv;

  function new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    recv = new("recv", this);
  endfunction

  function void write(transaction tr);
    bit [1:0] expected = tr.a + tr.b + tr.cin;

    if ({tr.c, tr.s} == expected)
      `uvm_info("[SCB]", $sformatf("TEST PASSED : a=%b b=%b cin=%b => s=%b c=%b", tr.a, tr.b, tr.cin, tr.s, tr.c), UVM_NONE)
    else
      `uvm_info("[SCB]", $sformatf("TEST FAILED : a=%b b=%b cin=%b | Expected s=%b c=%b, Got s=%b c=%b",
                                    tr.a, tr.b, tr.cin, expected[0], expected[1], tr.s, tr.c), UVM_NONE)
  endfunction
endclass

//============================================================
// Agent
//============================================================
class agent extends uvm_agent;
  `uvm_component_utils(agent)

  sequencer sqr;
  driver drv;
  monitor mon;

  function new(string name = "agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sqr = sequencer::type_id::create("sqr", this);
    drv = driver::type_id::create("drv", this);
    mon = monitor::type_id::create("mon", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction
endclass

//============================================================
// Environment
//============================================================
class environment extends uvm_env;
  `uvm_component_utils(environment)

  agent agt;
  scoreboard scb;

  function new(string name = "environment", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    agt = agent::type_id::create("agt", this);
    scb = scoreboard::type_id::create("scb", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    agt.mon.send.connect(scb.recv);
  endfunction
endclass

//============================================================
// Test
//============================================================
class test extends uvm_test;
  `uvm_component_utils(test)

  environment env;
  generator gen;

  function new(string name = "test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    env = environment::type_id::create("env", this);
    gen = generator::type_id::create("gen");
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    gen.start(env.agt.sqr);
    phase.drop_objection(this);
  endtask
  
//   virtual function void end_of_elaboration_phase(uvm_phase phase);
//     super.end_of_elaboration_phase(phase);
    
//     `uvm_top.print_topology();
    
//   endfunction
  
endclass

//============================================================
// Top Module
//============================================================
module top;

  intf inf();
  FA dut(inf);

  initial begin
    uvm_config_db#(virtual intf)::set(null, "*", "vif", inf);
    run_test("test");
  end

endmodule
```

## Output
```
UVM_INFO @ 0: reporter [RNTST] Running test test...
UVM_INFO design.sv(89) @ 0: uvm_test_top.env.agt.drv [DRV] Driving: a=0 b=0 cin=0
UVM_INFO design.sv(128) @ 1: uvm_test_top.env.agt.mon [MON] Sampled: a=0 b=0 cin=0 s=0 c=0
UVM_INFO design.sv(156) @ 1: uvm_test_top.env.scb [[SCB]] TEST PASSED : a=0 b=0 cin=0 => s=0 c=0
UVM_INFO design.sv(89) @ 1: uvm_test_top.env.agt.drv [DRV] Driving: a=1 b=0 cin=1
UVM_INFO design.sv(128) @ 2: uvm_test_top.env.agt.mon [MON] Sampled: a=1 b=0 cin=1 s=0 c=1
UVM_INFO design.sv(156) @ 2: uvm_test_top.env.scb [[SCB]] TEST PASSED : a=1 b=0 cin=1 => s=0 c=1
UVM_INFO design.sv(89) @ 2: uvm_test_top.env.agt.drv [DRV] Driving: a=0 b=1 cin=0
UVM_INFO design.sv(128) @ 3: uvm_test_top.env.agt.mon [MON] Sampled: a=0 b=1 cin=0 s=1 c=0
UVM_INFO design.sv(156) @ 3: uvm_test_top.env.scb [[SCB]] TEST PASSED : a=0 b=1 cin=0 => s=1 c=0
UVM_INFO design.sv(89) @ 3: uvm_test_top.env.agt.drv [DRV] Driving: a=1 b=1 cin=0
UVM_INFO design.sv(128) @ 4: uvm_test_top.env.agt.mon [MON] Sampled: a=1 b=1 cin=0 s=0 c=1
UVM_INFO design.sv(156) @ 4: uvm_test_top.env.scb [[SCB]] TEST PASSED : a=1 b=1 cin=0 => s=0 c=1
UVM_INFO design.sv(89) @ 4: uvm_test_top.env.agt.drv [DRV] Driving: a=0 b=0 cin=1
UVM_INFO design.sv(128) @ 5: uvm_test_top.env.agt.mon [MON] Sampled: a=0 b=0 cin=1 s=1 c=0
UVM_INFO design.sv(156) @ 5: uvm_test_top.env.scb [[SCB]] TEST PASSED : a=0 b=0 cin=1 => s=1 c=0
UVM_INFO design.sv(89) @ 5: uvm_test_top.env.agt.drv [DRV] Driving: a=0 b=1 cin=0
UVM_INFO design.sv(128) @ 6: uvm_test_top.env.agt.mon [MON] Sampled: a=0 b=1 cin=0 s=1 c=0
UVM_INFO design.sv(156) @ 6: uvm_test_top.env.scb [[SCB]] TEST PASSED : a=0 b=1 cin=0 => s=1 c=0
UVM_INFO design.sv(89) @ 6: uvm_test_top.env.agt.drv [DRV] Driving: a=1 b=0 cin=0
UVM_INFO design.sv(128) @ 7: uvm_test_top.env.agt.mon [MON] Sampled: a=1 b=0 cin=0 s=1 c=0
UVM_INFO design.sv(156) @ 7: uvm_test_top.env.scb [[SCB]] TEST PASSED : a=1 b=0 cin=0 => s=1 c=0
UVM_INFO design.sv(89) @ 7: uvm_test_top.env.agt.drv [DRV] Driving: a=0 b=0 cin=1
UVM_INFO design.sv(128) @ 8: uvm_test_top.env.agt.mon [MON] Sampled: a=0 b=0 cin=1 s=1 c=0
UVM_INFO design.sv(156) @ 8: uvm_test_top.env.scb [[SCB]] TEST PASSED : a=0 b=0 cin=1 => s=1 c=0
UVM_INFO design.sv(89) @ 8: uvm_test_top.env.agt.drv [DRV] Driving: a=1 b=1 cin=0
UVM_INFO design.sv(128) @ 9: uvm_test_top.env.agt.mon [MON] Sampled: a=1 b=1 cin=0 s=0 c=1
UVM_INFO design.sv(156) @ 9: uvm_test_top.env.scb [[SCB]] TEST PASSED : a=1 b=1 cin=0 => s=0 c=1
UVM_INFO design.sv(89) @ 9: uvm_test_top.env.agt.drv [DRV] Driving: a=1 b=0 cin=0
```
