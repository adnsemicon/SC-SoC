class axi4l_mem_env extends uvm_env;
  `uvm_component_utils(axi4l_mem_env)
  axi4l_mem_agent agent;
  axi4l_mem_scoreboard scoreboard;
  function new(string name="axi4l_mem_env", uvm_component parent=null); super.new(name,parent); endfunction
  function void build_phase(uvm_phase phase); super.build_phase(phase); agent=axi4l_mem_agent::type_id::create("agent",this); scoreboard=axi4l_mem_scoreboard::type_id::create("scoreboard",this); endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent.driver.completed_ap.connect(scoreboard.analysis_export);
  endfunction
endclass
