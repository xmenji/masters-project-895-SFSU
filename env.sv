//reference: https://www.chipverify.com/uvm/uvm-environment
class rsa_env extends uvm_env;
  
  //register with uvm factory
  `uvm_component_utils(rsa_env)
  
  //declare agent 
  rsa_agent agnt;
  
  //declare functional coverage
  rsa_coverage msg_cov;
  
  //declare scoreboard
  rsa_scoreboard scb;
  
  //constructor
  function new(string name = "rsa_env", uvm_component parent = null);
    super.new(name, parent);
    
  endfunction: new
  
  //Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    //build all of the components
    agnt = rsa_agent::type_id::create("agnt", this);
    msg_cov = rsa_coverage::type_id::create("msg_cov", this);
    scb = rsa_scoreboard::type_id::create("scb", this);
    
  endfunction: build_phase
  
  //Connect Phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    agnt.mon.mon_analysis_port.connect(scb.item_collect_export);
    
  endfunction: connect_phase

  
endclass: rsa_env