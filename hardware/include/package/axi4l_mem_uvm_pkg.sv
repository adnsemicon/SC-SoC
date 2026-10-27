`ifndef AXI4L_MEM_UVM_PKG_SV
`define AXI4L_MEM_UVM_PKG_SV
package axi4l_mem_uvm_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import defaults_pkg::*;
  `include "axi4l_mem_uvm_tb/object/axi4l_mem_seq_item.sv"
  `include "axi4l_mem_uvm_tb/sequence/axi4l_mem_basic_seq.sv"
  `include "axi4l_mem_uvm_tb/sequence/full_access_test.sv"
  `include "axi4l_mem_uvm_tb/sequence/partial_write_test.sv"
  `include "axi4l_mem_uvm_tb/sequence/zero_strobe_test.sv"
  `include "axi4l_mem_uvm_tb/sequence/address_isolation_test.sv"
  `include "axi4l_mem_uvm_tb/component/axi4l_mem_driver.sv"
  `include "axi4l_mem_uvm_tb/component/axi4l_mem_monitor.sv"
  `include "axi4l_mem_uvm_tb/component/axi4l_mem_agent.sv"
  `include "axi4l_mem_uvm_tb/component/axi4l_mem_scoreboard.sv"
  `include "axi4l_mem_uvm_tb/component/axi4l_mem_env.sv"
  `include "axi4l_mem_uvm_tb/test/axi4l_mem_base_test.sv"
  `include "axi4l_mem_uvm_tb/test/axi4l_mem_full_access_test.sv"
  `include "axi4l_mem_uvm_tb/test/axi4l_mem_partial_write_test.sv"
  `include "axi4l_mem_uvm_tb/test/axi4l_mem_zero_strobe_test.sv"
  `include "axi4l_mem_uvm_tb/test/axi4l_mem_address_isolation_test.sv"
  `include "axi4l_mem_uvm_tb/test/axi4l_mem_test.sv"
endpackage
`endif
