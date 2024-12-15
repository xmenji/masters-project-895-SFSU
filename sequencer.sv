//reference: https://www.chipverify.com/uvm/uvm-sequencer
class rsa_sequencer extends uvm_sequencer#(transaction);
  //register with uvm factory
  `uvm_component_utils(rsa_sequencer)
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "rsa_sequencer", uvm_component parent = null);
    super.new(name, parent);
    
    
  endfunction: new
  
  
endclass: rsa_sequencer
    