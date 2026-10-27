`ifndef __GUARD_APB_BASE_SEQ_SV__
`define __GUARD_APB_BASE_SEQ_SV__

class apb_base_seq extends uvm_sequence #(apb_seq_item);
  `uvm_object_utils(apb_base_seq)

  function new(string name = "apb_base_seq");
    super.new(name);
  endfunction

  // Convenience tasks
  virtual task apb_write(bit [31:0] addr, bit [31:0] data);
    apb_seq_item req = apb_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      write == 1;
      addr  == local::addr;
      data  == local::data;
    });
    finish_item(req);
  endtask

  virtual task apb_read(bit [31:0] addr, output bit [31:0] data);
    apb_seq_item req = apb_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      write == 0;
      addr  == local::addr;
    });
    finish_item(req);
    data = 0; // placeholder
  endtask
endclass
`endif