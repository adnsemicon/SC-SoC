`ifndef __GUARD_SMOKE_TEST_SV__
`define __GUARD_SMOKE_TEST_SV__

`include "sc_soc_uvm_tb/sequence/boot_core_seq.sv"

class smoke_test extends base_test;
  `uvm_component_utils(smoke_test)

  function new(string name = "smoke_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual task main_phase(uvm_phase phase);
    boot_core_seq boot_seq;

    phase.raise_objection(this);

    `uvm_info("TEST", "=== Starting smoke_test ===", UVM_LOW)

    load_symbols("prog.sym");
    if (!sym.exists("_start"))
      `uvm_fatal("TEST", "_start not found. Run: make test TEST=<name>");
    `uvm_info("TEST", $sformatf("_start = 0x%08h", sym["_start"]), UVM_MEDIUM)

    load_program("prog.hex");
    `uvm_info("TEST", "Program loaded", UVM_MEDIUM)

    #2us;

    boot_seq = boot_core_seq::type_id::create("boot_seq");
    boot_seq.boot_addr = sym["_start"];
    boot_seq.start(env.apb.sqr);
    `uvm_info("TEST", "Core booted", UVM_MEDIUM)

    #500us;

    `uvm_info("TEST", "=== smoke_test finished ===", UVM_LOW)
    phase.drop_objection(this);
  endtask
endclass

`endif