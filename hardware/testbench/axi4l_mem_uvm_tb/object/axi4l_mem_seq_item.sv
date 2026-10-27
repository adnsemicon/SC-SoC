class axi4l_mem_seq_item extends uvm_sequence_item;
  rand bit write;
  rand bit [31:0] addr;
  rand bit [63:0] data;
  rand bit [7:0] strb;
  bit [63:0] read_data;
  bit [1:0] resp;
  int unsigned test_id;

  `uvm_object_utils_begin(axi4l_mem_seq_item)
    `uvm_field_int(write, UVM_ALL_ON)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(strb, UVM_ALL_ON)
    `uvm_field_int(read_data, UVM_ALL_ON)
    `uvm_field_int(resp, UVM_ALL_ON)
    `uvm_field_int(test_id, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "axi4l_mem_seq_item"); super.new(name); endfunction
  constraint aligned_c { addr[2:0] == 0; }
endclass
