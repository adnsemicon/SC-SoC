class axi4l_mem_address_isolation_test extends axi4l_mem_base_seq;
  `uvm_object_utils(axi4l_mem_address_isolation_test)
  function new(string name = "axi4l_mem_address_isolation_test"); super.new(name); endfunction

  task body();
    transfer(1, 32'h58, 64'h1111_2222_3333_4444, 8'hff, AXI4L_MEM_CASE_ADDRESS_ISOLATION);
    transfer(1, 32'h60, 64'haaaa_bbbb_cccc_dddd, 8'hff, AXI4L_MEM_CASE_ADDRESS_ISOLATION);
    transfer(0, 32'h58, '0, '0, AXI4L_MEM_CASE_ADDRESS_ISOLATION);
    transfer(0, 32'h60, '0, '0, AXI4L_MEM_CASE_ADDRESS_ISOLATION);
  endtask
endclass
