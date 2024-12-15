//reference: https://www.chipverify.com/uvm/uvm-sequence
class transaction extends uvm_sequence_item;

  
  //--------------------------------------------------------
  //Instantiation
  //--------------------------------------------------------
  bit reset;
  rand logic [63:0] message;
  //logic [63:0] n;
  //logic [63:0] encrypted_msg;
  logic [63:0] decrypted_msg;
  
  
  //--------------------------------------------------------
  //Default Constraints
  //--------------------------------------------------------
  
  `uvm_object_utils_begin(transaction)
    `uvm_field_int(reset, UVM_ALL_ON)
    `uvm_field_int(message, UVM_ALL_ON)
    `uvm_field_int(decrypted_msg, UVM_ALL_ON)
  
  `uvm_object_utils_end
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name= "transaction");
    super.new(name);
  endfunction: new

  
endclass: transaction 