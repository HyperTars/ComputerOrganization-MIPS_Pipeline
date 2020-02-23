`include "flopr.v"
module Reg_IF_ID ( clk, rst, PC, instr, stallSignal, brSignal,
	instr_IF_ID_r, IF_ID_PC_r);

	input clk, rst;
	input	[29:0]	PC;
	input	[31:0]	instr;
	input			stallSignal;
	input  brSignal;
	
	output	[31:0]	instr_IF_ID_r;
	output	[29:0]	IF_ID_PC_r;
  
	wire clk, rst;
	wire	[29:0]  PC;
	wire	[31:0]  instr;
	wire			stallSignal;
  
	wire	[31:0]	 instr_IF_ID_r;
	wire	[29:0]  IF_ID_PC_r;


	reg		[31:0]	reg_IF_ID_instr;
	reg		[29:0]	reg_IF_ID_PC;
	reg				    stall;
	
	wire  [31:0]  last_IF_ID_instr;
	wire  [29:0]  last_IF_ID_PC;
	
	reg   [31:0]  last_IF_ID_instr_r;
	reg   [29:0]  last_IF_ID_PC_r;
	
	always @(negedge clk or negedge rst) begin
	  last_IF_ID_instr_r = instr_IF_ID_r;
	  last_IF_ID_PC_r = IF_ID_PC_r; 
	  end
	  
	assign last_IF_ID_instr = last_IF_ID_instr_r;
	assign last_IF_ID_PC = last_IF_ID_PC_r;
	
	always @(posedge clk or posedge rst) begin
		reg_IF_ID_instr <= instr;
		reg_IF_ID_PC <= PC;
	end
	
	always @(posedge clk or posedge rst) begin
		stall = (rst || stallSignal);
		if (stall) begin
			reg_IF_ID_instr <= last_IF_ID_instr;
			reg_IF_ID_PC <= last_IF_ID_PC;
		end
	end
	
	assign instr_IF_ID_r = reg_IF_ID_instr;
	assign IF_ID_PC_r = reg_IF_ID_PC;

endmodule
