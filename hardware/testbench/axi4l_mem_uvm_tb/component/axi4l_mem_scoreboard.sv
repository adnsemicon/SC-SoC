class axi4l_mem_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(axi4l_mem_scoreboard)
  uvm_analysis_imp #(axi4l_mem_seq_item, axi4l_mem_scoreboard) analysis_export;
  bit [7:0] model[longint unsigned];
  int unsigned passed;
  int unsigned failed;
  int unsigned case_passed[AXI4L_MEM_CASE_COUNT];
  int unsigned case_failed[AXI4L_MEM_CASE_COUNT];

  function new(string name="axi4l_mem_scoreboard", uvm_component parent=null);
    super.new(name,parent);
    analysis_export=new("analysis_export",this);
    passed = 0;
    failed = 0;
    foreach (case_passed[i]) begin
      case_passed[i] = 0;
      case_failed[i] = 0;
    end
  endfunction

  function void write(axi4l_mem_seq_item tr);
    longint unsigned base;
    bit check_ok;
    bit read_match;
    base = tr.addr & 64'hffff_ffff_ffff_fff8;
    check_ok = (tr.resp == 0);
    read_match = 1;
    if (tr.resp != 0) begin
      `uvm_error("AXI_RESP",$sformatf("Non-OKAY response at %h",tr.addr))
    end
    if (tr.write) begin
      if (check_ok)
        for (int i=0;i<8;i++) if (tr.strb[i]) model[base+i]=tr.data[i*8 +: 8];
      `uvm_info("AXI_SB",$sformatf("Observed write addr=%h data=%h strb=%h",tr.addr,tr.data,tr.strb),UVM_MEDIUM)
    end else begin
      logic [63:0] expected;
      for (int i=0;i<8;i++) expected[i*8 +: 8]=model.exists(base+i) ? model[base+i] : 8'hxx;
      if (tr.read_data !== expected) begin
        check_ok = 0;
        read_match = 0;
        `uvm_error("AXI_DATA",$sformatf("Read mismatch addr=%h expected=%h actual=%h",tr.addr,expected,tr.read_data))
      end
      if (check_ok && read_match)
        `uvm_info("AXI_SB",$sformatf("Read matched addr=%h data=%h",tr.addr,tr.read_data),UVM_MEDIUM)
    end

    if (tr.test_id >= AXI4L_MEM_CASE_COUNT) begin
      failed++;
      `uvm_error("AXI_CASE",$sformatf("Invalid test ID %0d for transaction at %h",tr.test_id,tr.addr))
    end else if (check_ok) begin
      passed++;
      case_passed[tr.test_id]++;
    end else begin
      failed++;
      case_failed[tr.test_id]++;
    end
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);

    $display("");
    $display("========================================");
    $display("       FINAL TEST SUMMARY               ");
    $display("========================================");
    $display(" 1. full_access_test.sv       : %s (%0d/2 checks)",
             (case_passed[AXI4L_MEM_CASE_FULL_ACCESS] == 2 && case_failed[AXI4L_MEM_CASE_FULL_ACCESS] == 0) ? "PASS" : "FAIL",
             case_passed[AXI4L_MEM_CASE_FULL_ACCESS]);
    $display(" 2. partial_write_test.sv     : %s (%0d/3 checks)",
             (case_passed[AXI4L_MEM_CASE_PARTIAL_WRITE] == 3 && case_failed[AXI4L_MEM_CASE_PARTIAL_WRITE] == 0) ? "PASS" : "FAIL",
             case_passed[AXI4L_MEM_CASE_PARTIAL_WRITE]);
    $display(" 3. zero_strobe_test.sv       : %s (%0d/3 checks)",
             (case_passed[AXI4L_MEM_CASE_ZERO_STROBE] == 3 && case_failed[AXI4L_MEM_CASE_ZERO_STROBE] == 0) ? "PASS" : "FAIL",
             case_passed[AXI4L_MEM_CASE_ZERO_STROBE]);
    $display(" 4. address_isolation_test.sv : %s (%0d/4 checks)",
             (case_passed[AXI4L_MEM_CASE_ADDRESS_ISOLATION] == 4 && case_failed[AXI4L_MEM_CASE_ADDRESS_ISOLATION] == 0) ? "PASS" : "FAIL",
             case_passed[AXI4L_MEM_CASE_ADDRESS_ISOLATION]);
    $display("----------------------------------------");
    $display(" PASS            = %0d", passed);
    $display(" FAIL            = %0d", failed);
    $display("========================================");
    if (failed == 0 &&
        case_passed[AXI4L_MEM_CASE_FULL_ACCESS] == 2 &&
        case_passed[AXI4L_MEM_CASE_PARTIAL_WRITE] == 3 &&
        case_passed[AXI4L_MEM_CASE_ZERO_STROBE] == 3 &&
        case_passed[AXI4L_MEM_CASE_ADDRESS_ISOLATION] == 4) begin
      $display(" ALL TESTS PASSED");
    end else if (passed == 0 && failed == 0) begin
      $display(" NO TRANSACTIONS CHECKED");
    end else begin
      $display(" SOME TESTS FAILED");
    end
    $display("========================================");
  endfunction
endclass
