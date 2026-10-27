localparam int unsigned AXI4L_MEM_CASE_FULL_ACCESS = 0;
localparam int unsigned AXI4L_MEM_CASE_PARTIAL_WRITE = 1;
localparam int unsigned AXI4L_MEM_CASE_ZERO_STROBE = 2;
localparam int unsigned AXI4L_MEM_CASE_ADDRESS_ISOLATION = 3;
localparam int unsigned AXI4L_MEM_CASE_COUNT = 4;

class axi4l_mem_base_seq extends uvm_sequence #(axi4l_mem_seq_item);
  function new(string name = "axi4l_mem_base_seq"); super.new(name); endfunction

  protected task automatic transfer(
      input bit write,
      input bit [31:0] addr,
      input bit [63:0] data,
      input bit [7:0] strb,
      input int unsigned test_id
  );
    axi4l_mem_seq_item req;
    req = axi4l_mem_seq_item::type_id::create("req");
    start_item(req);
    req.write = write;
    req.addr = addr;
    req.data = data;
    req.strb = strb;
    req.test_id = test_id;
    finish_item(req);
  endtask
endclass
