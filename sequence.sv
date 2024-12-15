//Reference: https://www.chipverify.com/uvm/uvm-sequence
//      https://github.com/chenyangbing/UVM-example/blob/master/sequence.sv
//https://verificationguide.com/uvm/uvm-sequence/
class base_sequence extends uvm_sequence#(transaction);
  `uvm_object_utils(base_sequence)
  `uvm_declare_p_sequencer(rsa_sequencer)
  transaction req; 
 
  
  function new(string name = "base_sequence");
    super.new(name);
    
  endfunction: new
  
  
  virtual task body();
    
    req = transaction::type_id::create("req");
    
    start_item(req); // Request a slot from the sequencer
    assert(req.randomize()); // Randomize the data object
    finish_item(req); // Send the data object to the driver
    
  endtask: body
  
endclass: base_sequence
//===================================================================
class reset_sequence extends uvm_sequence#(transaction);
  `uvm_object_utils(reset_sequence)

  //transaction data_obj;
  function new(string name = "reset_sequence");
    super.new(name);
  endfunction: new
  
  virtual task pre_body();
    
    if (starting_phase != null)
      starting_phase.raise_objection(this);
  endtask: pre_body
  
  virtual task body();
    
      `uvm_do_with(req,{req.reset<=0;}) //active low
      repeat(20);

      //#100;
  endtask: body
  
  virtual task post_body();
    
    if (starting_phase != null)
      starting_phase.drop_objection(this);
  endtask: post_body
    
  
endclass: reset_sequence

//===================================================================
class msg_sequence extends uvm_sequence#(transaction);
  `uvm_object_utils(msg_sequence)
  
  //transaction data_obj;
  function new(string name = "msg_sequence");
    super.new(name);
  endfunction: new
  
  virtual task pre_body();
    `uvm_info("MSG SEQ", $sformatf("Executing pre body phase"), UVM_LOW)
    if (starting_phase != null)
      starting_phase.raise_objection(this);
  endtask: pre_body
  
  virtual task body();
    //Constraint set for plaintext message:
    
    //0xFFFFFFFFFFFFFFFF -> 2^64
    //0x1000000000000000 -> 2^60
    //0x7FFFFE -> 2^59
    //0xffffffff -> 2^32
    `uvm_do_with(req,{req.message <= 64'h7FFFFE;})

  endtask: body
  
  virtual task post_body();
    `uvm_info("MSG SEQ", $sformatf("Executing post body phase"), UVM_LOW)
    if (starting_phase != null)
      starting_phase.drop_objection(this);
  endtask: post_body
  
endclass: msg_sequence