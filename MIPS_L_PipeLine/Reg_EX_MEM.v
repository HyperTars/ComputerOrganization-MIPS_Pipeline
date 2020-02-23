`include "flopr.v"
module Reg_EX_MEM( clk, rst,
	EX_instr, EX_MEM_instr,
	ALUOut, ALUSource_B, WriteDst, 
	ALUOut_EX_MEM_r, ALUSource_B_EX_MEM_r, WriteDst_EX_MEM_r,
	B_Reg, B_Reg_r,
	ID_EX_PC_r, EX_MEM_PC_r
	);

	
	input clk, rst;
	//input	[31:0]	ID_EX_PC_Add_r;
	input	[31:0]	EX_instr;
	input	[31:0]	ALUOut;
	input	[31:0]	ALUSource_B;
	input	[4:0]	WriteDst;
	input	[31:0]	B_Reg;
	input	[29:0]	ID_EX_PC_r;
	
	//output	[31:0]	EX_MEM_PC_Add_r;
	output	[31:0]	EX_MEM_instr;
	output	[31:0]	ALUOut_EX_MEM_r;
	output	[31:0]	ALUSource_B_EX_MEM_r;
	output	[4:0]	WriteDst_EX_MEM_r;
	output	[31:0]	B_Reg_r;
	output	[29:0]	EX_MEM_PC_r;

	/*
	flopr #(.WIDTH(32))	PC_Add_r (
		.clk(clk), .rst(rst), .d(ID_EX_PC_Add_r), .q(EX_MEM_PC_Add_r)
	);
	*/
   
	flopr #(.WIDTH(32))	EX_MEM_instr_r (
		.clk(clk), .rst(rst), .d(EX_instr), .q(EX_MEM_instr)
	);

	flopr #(.WIDTH(32))	ALUOut_r(
		.clk(clk), .rst(rst), .d(ALUOut), .q(ALUOut_EX_MEM_r)
	);

	flopr #(.WIDTH(32))	ALUSource_B_r(
		.clk(clk), .rst(rst), .d(ALUSource_B), .q(ALUSource_B_EX_MEM_r)
	);

	flopr #(.WIDTH(5))	WriteDst_r(
		.clk(clk), .rst(rst), .d(WriteDst), .q(WriteDst_EX_MEM_r)
	);

	flopr #(.WIDTH(32)) B_r (
		.clk(clk), .rst(rst), .d(B_Reg), .q(B_Reg_r)
	);

	flopr #(.WIDTH(30)) PC_r (
		.clk(clk), .rst(rst), .d(ID_EX_PC_r), .q(EX_MEM_PC_r)
	);

endmodule
