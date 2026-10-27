// Default regression test. The base test runs the shared regression sequence.
class axi4l_mem_test extends axi4l_mem_base_test;
  `uvm_component_utils(axi4l_mem_test)

  function new(string name = "axi4l_mem_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass
