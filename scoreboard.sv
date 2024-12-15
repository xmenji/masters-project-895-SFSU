//reference: https://www.chipverify.com/uvm/uvm-scoreboard
//           https://github.com/chenyangbing/UVM-example/blob/master/scoreboard.sv
class rsa_scoreboard extends uvm_scoreboard;
  
  //register with uvm factory
  `uvm_component_utils(rsa_scoreboard)
  
  //TLM Analysis Port to receive data objs from other tb components
  uvm_analysis_imp #(transaction, rsa_scoreboard) item_collect_export;
  
  transaction item_qu[$]; 
  transaction item;
  int data_match;
  int data_mismatch;
  int packet;

  //declare functional coverage
  rsa_coverage msg_cov;
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new (string name = "rsa_scoreboard", uvm_component parent = null);
    super.new(name, parent);
    //instantiate analysis port
    item_collect_export = new("item_collect_export", this);
  endfunction: new
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    msg_cov = rsa_coverage::type_id::create("msg_cov", this);
  endfunction: build_phase
  
  //--------------------------------------------------------
  //Write Method
  //--------------------------------------------------------
  //***Define the action to be taken when data is received from the analysis port***
  function void write(transaction item);
    //actions to take on data item

    item_qu.push_back(item);
  endfunction: write
  
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase(uvm_phase phase);
    transaction sb_item;
    data_match = 0;
    data_mismatch = 0;
    packet = 0;
    #500;
    forever begin
  
     
      wait((item_qu.size() > 0));

          phase.raise_objection(this);
          sb_item = item_qu.pop_front();
          
          //sample data
          msg_cov.write(sb_item); //functional coverage
          packet++;
          
          //Perform self-checking
          if(sb_item.reset == 1) begin 

            //Encrypted Data MATCHES Plaintext message
            if(sb_item.message == sb_item.decrypted_msg) begin
            `uvm_info(get_type_name(),$sformatf("------ :: DATA Match :: ------"),UVM_LOW)
              `uvm_info(get_type_name(),$sformatf("Expected Data: %0d\tActual Data: %0d",sb_item.message, sb_item.decrypted_msg),UVM_LOW)
            `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
              data_match += 1;
            end

            //else Encrypted Data DOES NOT MATCH Plaintext Message
            else begin
            `uvm_error(get_type_name(),"------ :: DATA MisMatch :: ------")
            `uvm_info(get_type_name(),$sformatf("Expected Data: %0d\tActual Data: %0d",sb_item.message, sb_item.decrypted_msg),UVM_LOW)
            `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
              data_mismatch += 1;
            end
          end
          
           phase.drop_objection(this);

    end
  endtask: run_phase

  
  //--------------------------------------------------------
  //Report Phase
  //--------------------------------------------------------  
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(),$sformatf("------ :: Final Score :: ------"), UVM_LOW);
    `uvm_info(get_type_name(), $sformatf("Total Comparisons: %0d\t Number of Correct: %0d\t Number of Incorrect: %0d", packet, data_match, data_mismatch), UVM_LOW)
  
  endfunction: report_phase 
  
endclass: rsa_scoreboard