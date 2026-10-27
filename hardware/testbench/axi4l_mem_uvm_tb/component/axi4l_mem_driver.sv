class axi4l_mem_driver extends uvm_driver #(axi4l_mem_seq_item);
  `uvm_component_utils(axi4l_mem_driver)
  virtual axi4l_if #(.req_t(axi4l_req_t), .resp_t(axi4l_resp_t)) vif;
  uvm_analysis_port #(axi4l_mem_seq_item) completed_ap;
  function new(string name="axi4l_mem_driver", uvm_component parent=null);
    super.new(name,parent);
    completed_ap = new("completed_ap", this);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual axi4l_if #(.req_t(axi4l_req_t), .resp_t(axi4l_resp_t)))::get(this,"","vif",vif)) `uvm_fatal("NOVIF","axi4l_if not configured")
  endfunction
  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      if (req.write) begin
        fork
          vif.send_aw('{addr:req.addr, prot:3'b000});
          vif.send_w('{data:req.data, strb:req.strb});
        join
        begin axi4l_b_chan_t b; vif.recv_b(b); req.resp=b.resp; end
      end else begin
        axi4l_r_chan_t r;
        vif.send_ar('{addr:req.addr, prot:3'b000});
        vif.recv_r(r); req.read_data=r.data; req.resp=r.resp;
      end
      completed_ap.write(req);
      seq_item_port.item_done();
    end
  endtask
endclass
