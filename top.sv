// Reference: https://www.chipverify.com/uvm/uvm-testbench-top
// UVM Testbench Top Module

`timescale 1ns/1ps;
`include "uvm_macros.svh"
  import uvm_pkg::*;


// The top module that contains the DUT and interface.
// This module starts the test.
module top;
  
  //--------------------------------------------------------
  //Clock Generation
  //--------------------------------------------------------
  bit clk;
  //bit reset;
  
  initial begin
    #40
    
    forever #20 clk = !clk; //50MHz
    
  end
  
  //--------------------------------------------------------
  //DUT & Interface Instantiation
  //--------------------------------------------------------
  //Virtual interface
  dut_if rsa_vif(clk);
  //RTL
  rsa dut(
    .clk(rsa_vif.clk),
    .reset(rsa_vif.reset),
    .message(rsa_vif.message),
    
    .decrypted_msg(rsa_vif.decrypted_msg)
  );
  
  //--------------------------------------------------------
  //Start The Test
  //--------------------------------------------------------
  
  initial begin
    /*Reference: https://www.synopsys.com/content/dam/synopsys/services/whitepapers/hierarchical-testbench-configuration-using-uvm.pdf*/
    
    uvm_config_db#(virtual dut_if)::set(uvm_root::get(), "*", "rsa_vif", rsa_vif);
    /*Calling run_test() constructs the UVM environment root component and then initiates the UVM phasing*/
    run_test("rsa_test"); 
  end
  

  
  //--------------------------------------------------------
  //Generate Waveforms
  //--------------------------------------------------------
  initial begin

    $fsdbDumpvars();

  end
 
endmodule
