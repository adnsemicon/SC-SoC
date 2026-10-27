`ifndef __GUARD_HELLO_TEST_SV__
`define __GUARD_HELLO_TEST_SV__

`include "sc_soc_uvm_tb/sequence/boot_core_seq.sv"

class hello_test extends base_test;
  `uvm_component_utils(hello_test)

  function new(string name = "hello_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual task main_phase(uvm_phase phase);
    boot_core_seq boot_seq;
    bit [7:0]     data;
    bit           parity;
    string        msg = "";
    bit           got_line = 0;
    string        expected = "Hello World...!";

    phase.raise_objection(this);

    `uvm_info("TEST", "=== Starting hello_test ===", UVM_LOW)

    load_symbols("prog.sym");
    if (!sym.exists("_start"))
      `uvm_fatal("TEST", "_start not found. Run: make test TEST=uart");
    `uvm_info("TEST", $sformatf("_start = 0x%08h", sym["_start"]), UVM_MEDIUM)

    load_program("prog.hex");
    `uvm_info("TEST", "Program loaded", UVM_MEDIUM)

    #2us;

    boot_seq = boot_core_seq::type_id::create("boot_seq");
    boot_seq.boot_addr = sym["_start"];
    boot_seq.start(env.apb.sqr);
    `uvm_info("TEST", "Core booted. Listening UART @ 1Mbps...", UVM_MEDIUM)

    fork
      begin
        #8000us;
        if (!got_line)
          `uvm_warning("TEST", $sformatf("Timeout. Got so far: \"%s\"", msg));
      end
      begin
        forever begin
          @(negedge uart_intf.rx);
          uart_intf.recv_rx(data, parity, 1000000, 0, 0, 0, 8);

          if (data >= 32 && data <= 126)
            msg = {msg, string'(data)};

          `uvm_info("UART", $sformatf("got: %c (0x%02h) msg=\"%s\"", data, data, msg), UVM_MEDIUM)

          if (msg.len() >= expected.len()) begin
            `uvm_info("UART", $sformatf(">>> \"%s\"", msg), UVM_LOW)
            if (msg.substr(0, expected.len()-1) == expected)
              `uvm_info("TEST", "PASS: UART message matched", UVM_LOW)
            else
              `uvm_error("TEST", $sformatf("FAIL: expected \"%s\"", expected))
            got_line = 1;
            break;
          end
        end
      end
    join_any
    disable fork;

    `uvm_info("TEST", "=== finished ===", UVM_LOW)
    phase.drop_objection(this);
  endtask
endclass

`endif