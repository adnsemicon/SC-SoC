class axi4l_mem_zero_strobe_test extends axi4l_mem_base_seq;
  `uvm_object_utils(axi4l_mem_zero_strobe_test)
  function new(string name = "axi4l_mem_zero_strobe_test"); super.new(name); endfunction

  task body();
    transfer(1, 32'h50, 64'h7654_3210_fedc_ba98, 8'hff, AXI4L_MEM_CASE_ZERO_STROBE);
    transfer(1, 32'h50, 64'hffff_ffff_ffff_ffff, 8'h00, AXI4L_MEM_CASE_ZERO_STROBE);
    transfer(0, 32'h50, '0, '0, AXI4L_MEM_CASE_ZERO_STROBE);
  endtask
endclass
