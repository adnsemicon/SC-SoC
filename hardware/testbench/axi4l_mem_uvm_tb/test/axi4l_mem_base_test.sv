// Shared setup and regression sequence for all AXI4-Lite memory tests.
class axi4l_mem_base_test extends uvm_test;
  `uvm_component_utils(axi4l_mem_base_test)

  axi4l_mem_env env;

  function new(string name = "axi4l_mem_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = axi4l_mem_env::type_id::create("env", this);
  endfunction

  virtual task run_test_sequence();
    axi4l_mem_full_access_test full_access_seq;
    axi4l_mem_partial_write_test partial_write_seq;
    axi4l_mem_zero_strobe_test zero_strobe_seq;
    axi4l_mem_address_isolation_test address_isolation_seq;

    full_access_seq = axi4l_mem_full_access_test::type_id::create("full_access_seq");
    full_access_seq.start(env.agent.seqr);
    partial_write_seq = axi4l_mem_partial_write_test::type_id::create("partial_write_seq");
    partial_write_seq.start(env.agent.seqr);
    zero_strobe_seq = axi4l_mem_zero_strobe_test::type_id::create("zero_strobe_seq");
    zero_strobe_seq.start(env.agent.seqr);
    address_isolation_seq = axi4l_mem_address_isolation_test::type_id::create("address_isolation_seq");
    address_isolation_seq.start(env.agent.seqr);
  endtask

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    wait (env.agent.driver.vif.arst_ni);
    run_test_sequence();
    repeat (5) @(posedge env.agent.driver.vif.clk_i);
    phase.drop_objection(this);
  endtask
endclass
