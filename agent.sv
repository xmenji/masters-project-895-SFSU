//Reference: https://www.chipverify.com/uvm/uvm-agent
class rsa_agent extends uvm_agent;
  //register with uvm factory
  `uvm_component_utils(rsa_agent)
  
  //declare driver, monitor, sequencer, config
  rsa_driver drv;
  rsa_monitor mon;
  rsa_sequencer seqr;
  
  //constructor
  function new(string name="rsa_agent", uvm_component parent = null);
    super.new(name, parent);
    
  endfunction: new
  
  //Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    //build driver, monitor, swquencer, ocnfig...
    drv = rsa_driver::type_id::create("drv", this);
    mon = rsa_monitor::type_id::create("mon", this);
    seqr = rsa_sequencer::type_id::create("seqr", this);
    
  endfunction: build_phase
  
  //connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
   
    //connect the driver to the sequencer
    drv.seq_item_port.connect(seqr.seq_item_export);
    
  endfunction: connect_phase
  
endclass: rsa_agent
  
  