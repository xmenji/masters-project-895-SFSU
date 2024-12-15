//Interface connects with the Design Under Test
interface dut_if(input logic clk);
  //declare logic
  logic reset;
  logic [63:0] message;

  logic [63:0] decrypted_msg;
  
  //Clocking Block: DRIVER
  clocking drive_cb @(posedge clk);
    default input #1 output #0;
    
    output reset;
    output message;
    input decrypted_msg;
  endclocking: drive_cb
  
  //Clocking Block: MONITOR
  clocking mon_cb @(posedge clk);
    default input #1 output #0;
    
    input reset;
    input message;
    input decrypted_msg;
  endclocking: mon_cb
  
  modport DRIV (clocking drive_cb); // to dut
  modport MON (clocking mon_cb);//into monitor from dut
  
endinterface: dut_if