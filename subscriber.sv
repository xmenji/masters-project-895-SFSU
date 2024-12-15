//Functional Coverage
class rsa_coverage extends uvm_subscriber #(transaction);
  `uvm_component_utils(rsa_coverage)
  
  transaction cov1;
  
  covergroup rsa_cov;
  //option.per_instance=1;

    //Run functional coverage on the first 60 bits of the input (plaintext message) using 2048 bins
    PLAINTEXT_0_59: coverpoint cov1.message[59:0] {
      bins plaintxt_values[2048] = {[0:576460752303423487] };
      
    }
    

  endgroup: rsa_cov
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "rsa_coverage", uvm_component parent = null);
    super.new(name, parent);
    
    rsa_cov = new();
    
  endfunction: new
  
  function void write(transaction t);
    cov1 = t;
    rsa_cov.sample();
    $display("SAMPLING TRANSACTION: %d", cov1.message);
  endfunction: write
    
    
endclass: rsa_coverage