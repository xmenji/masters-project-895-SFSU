//reference: https://www.chipverify.com/uvm/uvm-driver
class rsa_driver extends uvm_driver#(transaction);
  //register with uvm factory
  `uvm_component_utils(rsa_driver)
  
  //Declare virtual interface
  virtual dut_if rsa_vif;

  transaction item;
  
  bit [63:0] plaintext_msg;
  bit [63:0] expected;
  
  int rst_counter = 0;
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new (string name = "rsa_driver", uvm_component parent = null);
    super.new(name, parent);
    
    
  endfunction: new
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    
    if(!(uvm_config_db #(virtual dut_if)::get(this, "*", "rsa_vif", rsa_vif))) begin
      
      `uvm_fatal(get_type_name (), "Didn't get handle to virtual interface dut_if")
    end
    
  endfunction: build_phase
  
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------  
  task run_phase(uvm_phase phase);
    //transaction data_obj;
    super.run_phase(phase);
    
    
    /*
    1. Get next item from the sequencer
    2. Assign data from the received item into DUT interface
    3. Finish driving transaction
    */
    forever begin
      
      item = transaction::type_id::create("item"); 
        seq_item_port.get_next_item(item);
        
      
      drive_item(item);
      
      
      seq_item_port.item_done();   
      `uvm_info(get_type_name(), $sformatf("Data succesfully driven"), UVM_LOW)
        

    end
  endtask: run_phase
  
  
  extern task drive_item(transaction item);
    
endclass: rsa_driver
    
  //--------------------------------------------------------
  //[Method] Drive Item
  //--------------------------------------------------------
   
    
    task rsa_driver::drive_item(transaction item);
        
      rsa_vif.drive_cb.reset <= 1; //reset is active low
      
      //Test Reset
      if(rst_counter == 0 || rst_counter == 5) begin

        @(rsa_vif.drive_cb)
        $display("Driver: Applying reset");
        `uvm_info(get_type_name(), $sformatf("Driver: Applying reset"), UVM_LOW)
        rsa_vif.drive_cb.reset <= 0;
        this.expected <= 0;
        
        @(rsa_vif.drive_cb);
        
    
        rsa_vif.drive_cb.reset <= 1;
        `uvm_info(get_type_name(), $sformatf("Driver: Coming out of reset"), UVM_LOW)

      end
      rst_counter += 1;
        
      
      
      //Apply inputs
      @(rsa_vif.drive_cb)
      plaintext_msg = item.message; //retrieve plaintext msg
      $display("Driver: Sending Plaintext Message: %d", item.message);
      rsa_vif.drive_cb.message <= item.message;
      //585,000ns delay 
      #585000;
      
      item.decrypted_msg = rsa_vif.drive_cb.decrypted_msg;

      
    endtask: drive_item
    
    