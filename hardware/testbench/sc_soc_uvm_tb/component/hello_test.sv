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
  bit           got_newline = 0;

  phase.raise_objection(this);

  `uvm_info("TEST", "=== Starting hello_test ===", UVM_LOW)

  // 1. Load symbols & program
  load_symbols("prog.sym");
  load_program("prog.hex");
  `uvm_info("TEST", "Program loaded", UVM_MEDIUM)

  // _start অ্যাড্রেস দেখাও
  if (sym.exists("_start"))
    `uvm_info("TEST", $sformatf("_start = 0x%08h", sym["_start"]), UVM_MEDIUM)
  else
    `uvm_error("TEST", "_start symbol not found!")

  #1us;

  // 2. Boot the core (সঠিক অ্যাড্রেস দিয়ে)
  boot_seq = boot_core_seq::type_id::create("boot_seq");
  boot_seq.boot_addr = sym["_start"];          // ← এখানেই মূল ফিক্স
  `uvm_info("TEST", $sformatf("Starting boot sequence from 0x%08h...", boot_seq.boot_addr), UVM_MEDIUM)
  boot_seq.start(env.apb.sqr);
  `uvm_info("TEST", "Boot sequence finished. Listening on UART...", UVM_MEDIUM)

  // 3. UART থেকে ডেটা পড়া
  fork
    begin
      #2000us;   // একটু বেশি সময় দিলাম
      if (!got_newline)
        `uvm_warning("TEST", "Timeout! No complete UART line received")
    end
    begin
      forever begin
        uart_intf.recv_rx(data, parity, 115200, 0, 0, 0, 8);

        if (data == "\n" || data == "\r") begin
          if (msg.len() > 0) begin
            `uvm_info("UART", $sformatf("Software said: \"%s\"", msg), UVM_LOW)
            got_newline = 1;
            break;
          end
        end else begin
          msg = {msg, string'(data)};
        end
      end
    end
  join_any
  disable fork;

  `uvm_info("TEST", "=== hello_test finished ===", UVM_LOW)
  phase.drop_objection(this);
endtask

endclass

`endif