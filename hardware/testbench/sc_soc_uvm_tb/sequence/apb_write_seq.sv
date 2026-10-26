// sequence/apb_write_seq.sv
`ifndef __GUARD_APB_WRITE_SEQ_SV__
`define __GUARD_APB_WRITE_SEQ_SV__ 0

`include "sc_soc_uvm_tb/sequence/apb_base_seq.sv"
class apb_write_seq extends apb_base_seq;
  `uvm_object_utils(apb_write_seq)

  rand bit [31:0] addr;
  rand bit [31:0] data;

  function new(string name = "apb_write_seq");
    super.new(name);
  endfunction

  virtual task body();
    apb_write(addr, data);
  endtask
endclass
`endif