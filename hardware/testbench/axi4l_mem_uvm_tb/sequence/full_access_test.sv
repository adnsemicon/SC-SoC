class axi4l_mem_full_access_test extends axi4l_mem_base_seq;
  `uvm_object_utils(axi4l_mem_full_access_test)
  function new(string name = "axi4l_mem_full_access_test"); super.new(name); endfunction

  task body();
    transfer(1, 32'h40, 64'h0123_4567_89ab_cdef, 8'hff, AXI4L_MEM_CASE_FULL_ACCESS);
    transfer(0, 32'h40, '0, '0, AXI4L_MEM_CASE_FULL_ACCESS);
  endtask
endclass
