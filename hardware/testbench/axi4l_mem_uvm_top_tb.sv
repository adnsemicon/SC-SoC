`include "package/axi4l_mem_uvm_pkg.sv"
module axi4l_mem_uvm_top_tb;
  import uvm_pkg::*;
  import defaults_pkg::*;
  import axi4l_mem_uvm_pkg::*;
  logic clk_i=0;
  logic arst_ni=0;
  always #5 clk_i=~clk_i;
  axi4l_if #(.req_t(axi4l_req_t),.resp_t(axi4l_resp_t)) axi_vif(.arst_ni(arst_ni),.clk_i(clk_i));
  axi4l_mem #(.axi4l_req_t(axi4l_req_t),.axi4l_resp_t(axi4l_resp_t),.ADDR_WIDTH(32),.DATA_WIDTH(64)) dut
    (.arst_ni(arst_ni),.clk_i(clk_i),.axi4l_req_i(axi_vif.req),.axi4l_resp_o(axi_vif.resp));
  initial begin
    string test_name;
    axi_vif.req_reset();
    uvm_config_db#(virtual axi4l_if #(.req_t(axi4l_req_t), .resp_t(axi4l_resp_t)))::set(null,"*","vif",axi_vif);
    if (!$value$plusargs("UVM_TESTNAME=%s", test_name))
      test_name = "axi4l_mem_test";
    run_test(test_name);
  end
  initial begin
    repeat(4) @(posedge clk_i);
    arst_ni = 1;
  end
endmodule
