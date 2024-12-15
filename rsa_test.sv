//Custom Base test
//reference: https://www.chipverify.com/uvm/uvm-test
class rsa_test extends uvm_test;
  //register class with uvm factory
  `uvm_component_utils(rsa_test)
  
  //Declare the environment & configuration obj (If I need to add config)
  rsa_env top_env;
  
  //Sequencer
  rsa_sequencer sqr;
  //sequence instances
  base_sequence b_seq;
  reset_sequence rst_seq;
  msg_sequence msg_seq;
  
  //declare functional coverage
  rsa_coverage msg_cov;
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "rsa_test", uvm_component parent = null);
    super.new(name, parent);
    
  endfunction: new
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    
    //instantiate the environment 
    top_env = rsa_env::type_id::create("top_env", this);
    
    sqr = rsa_sequencer::type_id::create("sqr", this);
    
    msg_cov = rsa_coverage::type_id::create("msg_cov", this);
  endfunction: build_phase

  
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    
    //Create and instantiate the sequences
    b_seq = base_sequence::type_id::create("b_seq");
    rst_seq = reset_sequence::type_id::create("rst_seq");
    msg_seq = msg_sequence::type_id::create("msg_seq");
    

    //start the sequence on the given sequencer
    /*
    `uvm_info(get_type_name(), $sformatf("Starting sequence: %s", b_seq.get_full_name()), UVM_LOW)

    repeat(1000) begin
      phase.raise_objection(this);
      b_seq.start(top_env.agnt.seqr); 
      phase.drop_objection(this);
    end
    */
  
    ///*
    `uvm_info(get_type_name(), $sformatf("Starting sequence: %s", msg_seq.get_full_name()), UVM_LOW)
    //Set the number below to the number of tests you want to perform.
    repeat(1000) begin 
      phase.raise_objection(this);
      msg_seq.start(top_env.agnt.seqr);
      phase.drop_objection(this);
    end
    //*/
    /*
    `uvm_info(get_type_name(), $sformatf("Starting sequence: %s", rst_seq.get_full_name()), UVM_LOW)
    repeat(1) begin
      phase.raise_objection(this);
      rst_seq.start(top_env.agnt.seqr);
      phase.drop_objection(this);
    end
    `uvm_info(get_type_name(), $sformatf("Starting sequence: %s", msg_seq.get_full_name()), UVM_LOW)
    repeat(5) begin 
      phase.raise_objection(this);
      msg_seq.start(top_env.agnt.seqr);
      phase.drop_objection(this);
    end
    */
    
  endtask: run_phase
  
  //---------------------------------------------------------
  //print topology for debugging purposes
  //---------------------------------------------------------
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction
  
  
  
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    
    uvm_config_db#(uvm_object_wrapper)::set(this, "top_env.sqr.main_phase", "default_sequence", base_sequence::type_id::get());
    
  endfunction: start_of_simulation_phase
  
  
endclass: rsa_test