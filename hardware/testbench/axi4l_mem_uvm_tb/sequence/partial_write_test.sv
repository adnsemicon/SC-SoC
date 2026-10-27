class axi4l_mem_partial_write_test extends axi4l_mem_base_seq;
  `uvm_object_utils(axi4l_mem_partial_write_test)
  function new(string name = "axi4l_mem_partial_write_test"); super.new(name); endfunction

  task body();
    transfer(1, 32'h48, 64'h0123_4567_89ab_cdef, 8'hff, AXI4L_MEM_CASE_PARTIAL_WRITE);
    transfer(1, 32'h48, 64'hffeeddccbbaa9988, 8'b0000_0101, AXI4L_MEM_CASE_PARTIAL_WRITE);
    transfer(0, 32'h48, '0, '0, AXI4L_MEM_CASE_PARTIAL_WRITE);
  endtask
endclass
