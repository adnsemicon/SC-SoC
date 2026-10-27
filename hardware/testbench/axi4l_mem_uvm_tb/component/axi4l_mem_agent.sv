class axi4l_mem_agent extends uvm_agent;
  `uvm_component_utils(axi4l_mem_agent)
  uvm_sequencer #(axi4l_mem_seq_item) seqr;
  axi4l_mem_driver driver;
  axi4l_mem_monitor monitor;
  function new(string name="axi4l_mem_agent", uvm_component parent=null); super.new(name,parent); endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seqr=uvm_sequencer#(axi4l_mem_seq_item)::type_id::create("seqr",this);
    driver=axi4l_mem_driver::type_id::create("driver",this);
    monitor=axi4l_mem_monitor::type_id::create("monitor",this);
  endfunction
  function void connect_phase(uvm_phase phase); super.connect_phase(phase); driver.seq_item_port.connect(seqr.seq_item_export); endfunction
endclass
