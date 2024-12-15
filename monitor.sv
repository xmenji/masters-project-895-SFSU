//reference: https://www.chipverify.com/uvm/uvm-monitor
class rsa_monitor extends uvm_monitor;
  /*Collect bus or signal information through a virtual interface
    Collected data can be used for protocol checking and coverage
    Collected data is exported via an analysis port*/
  
  //register with uvm factory
  `uvm_component_utils(rsa_monitor)
  
  //declare virtual interface & analysis ports
  virtual dut_if rsa_vif; //connects to the DUT
  uvm_analysis_port #(transaction) mon_analysis_port;
  //sequence item
  transaction data_obj;
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new (string name= "rsa_monitor", uvm_component parent = null);
    super.new(name, parent);
    
    mon_analysis_port = new("mon_analysis_port", this);
    data_obj = new();
  endfunction: new
  
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    //get virtual interface handle form config DB
    if(!(uvm_config_db #(virtual dut_if)::get(this, "", "rsa_vif", rsa_vif))) begin
      `uvm_error(get_type_name(), "Failed to get rsa_vif from config DB!")
    end
    
  endfunction: build_phase
  
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin

        repeat(14625) @(rsa_vif.mon_cb);
        data_obj.reset = rsa_vif.mon_cb.reset;
        data_obj.message = rsa_vif.mon_cb.message;             //plaintext message
        data_obj.decrypted_msg = rsa_vif.mon_cb.decrypted_msg; //decrypted message
      
        //send data obj through analysis port
        mon_analysis_port.write(data_obj);
        
    end
    
  endtask: run_phase
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
  endfunction : report_phase
  
  
endclass: rsa_monitor