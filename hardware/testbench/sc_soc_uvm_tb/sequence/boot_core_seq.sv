`ifndef __GUARD_BOOT_CORE_SEQ_SV__
`define __GUARD_BOOT_CORE_SEQ_SV__

`include "sc_soc_uvm_tb/sequence/apb_base_seq.sv"

class boot_core_seq extends apb_base_seq;
  `uvm_object_utils(boot_core_seq)

  bit [31:0] boot_addr = 32'h0000_0000;

  function new(string name = "boot_core_seq");
    super.new(name);
  endfunction

virtual task body();
  `uvm_info("BOOT", $sformatf("Booting core from 0x%08h", boot_addr), UVM_MEDIUM)

  `uvm_info("BOOT", "Writing BOOT_ADDR...", UVM_HIGH)
  apb_write(32'h0001_0020, boot_addr);

  `uvm_info("BOOT", "Writing HART_ID...", UVM_HIGH)
  apb_write(32'h0001_0024, 32'h0);

  `uvm_info("BOOT", "Writing CORE_CLK_EN...", UVM_HIGH)
  apb_write(32'h0001_0028, 32'h2);

  `uvm_info("BOOT", "Core released from reset", UVM_MEDIUM)
endtask

endclass

`endif