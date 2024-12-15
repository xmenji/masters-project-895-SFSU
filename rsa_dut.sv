/*
`include "RSA_decryptor.v"
`include "RSA_encryptor.v"
`include "pt_exp.v"
`include "primality_tester.v"
`include "multiply.v"
`include "modexp1.v"
`include "lfsr.v"
`include "gcd.v"
`include "fifo.v"
`include "euclidean_loop.v"
`include "encryption_key.v"
*/
// RTL goes here
module rsa(input clk, 
           input reset, 
           input [63:0] message, 
           /*output [63:0] n,*/ 
           /*output [63:0] encrypted_msg,*/ 
           output [63:0] decrypted_msg);
  

  wire [63:0]	encrypted_msg;
  wire [63:0]	n;
  wire [63:0]	encrypt_key;
  
  RSA_decryptor decrypt(.clk(clk),
				.rst(reset),
				.encrypted_message(encrypted_msg),
				.msg_received_sig(done_encrypt),
				.n(n),
				.decrypted_message(decrypted_msg),
				.donegcd(donegcd),
				.encrypt_key(encrypt_key)
			);

  RSA_encryptor encrypt(.clk(clk),
                      .rst(reset),
                      .Message(message),
                      .encrypted_msg(encrypted_msg),
                      .n(n),
                      .exponent(encrypt_key),
                      .public_key_rcvd(donegcd),
                      .done_encrypt(done_encrypt));

  
endmodule