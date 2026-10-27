class axi4l_mem_monitor extends uvm_monitor;
  `uvm_component_utils(axi4l_mem_monitor)
  uvm_analysis_port #(axi4l_mem_seq_item) ap;
  virtual axi4l_if #(.req_t(axi4l_req_t), .resp_t(axi4l_resp_t)) vif;
  function new(string name="axi4l_mem_monitor", uvm_component parent=null); super.new(name,parent); ap=new("ap",this); endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual axi4l_if #(.req_t(axi4l_req_t), .resp_t(axi4l_resp_t)))::get(this,"","vif",vif)) `uvm_fatal("NOVIF","axi4l_if not configured")
  endfunction
  task run_phase(uvm_phase phase);
    // look_* returns immediately while reset is asserted. Do not start the
    // sampling loops until the interface is live, or they emit zero-valued
    // phantom transactions continuously at time zero.
    wait (vif.arst_ni);
    fork
      forever begin
        axi4l_mem_seq_item tr;
        logic [31:0] addr; logic [63:0] data; logic [7:0] strb;
        fork
          begin axi4l_aw_chan_t aw; vif.look_aw(aw); addr=aw.addr; end
          begin axi4l_w_chan_t w; vif.look_w(w); data=w.data; strb=w.strb; end
        join
        begin axi4l_b_chan_t b; vif.look_b(b); tr=axi4l_mem_seq_item::type_id::create("write_observed"); tr.write=1; tr.addr=addr; tr.data=data; tr.strb=strb; tr.resp=b.resp; ap.write(tr); end
      end
      forever begin
        axi4l_mem_seq_item tr;
        axi4l_ar_chan_t ar; axi4l_r_chan_t r;
        vif.look_ar(ar); vif.look_r(r);
        tr=axi4l_mem_seq_item::type_id::create("read_observed"); tr.write=0; tr.addr=ar.addr; tr.read_data=r.data; tr.resp=r.resp; ap.write(tr);
      end
    join
  endtask
endclass
