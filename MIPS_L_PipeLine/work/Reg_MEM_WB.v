`include "flopr.v";
module Reg_MEM_WB ( clk, rst,
	MEM_instr, MEM_WB_instr,
	DataMem, DataMem_MEM_WB_r,
	ALUOut, ALUOut_MEM_WB_r,
	WriteDst, WriteDst_MEM_WB_r );

	input	clk, rst;
	input	[31:0]	MEM_instr;
	input	[31:0]	DataMem;
	input	[31:0]	ALUOut;
	input	[4:0]	WriteDst;

	output	[31:0]	MEM_WB_instr;
	output	[31:0]	DataMem_MEM_WB_r;
	output	[31:0]	ALUOut_MEM_WB_r;
	output	[4:0]	WriteDst_MEM_WB_r;

	/*
	flopr #(.WIDTH(32))	PC_Add_r(
		.clk(clk), .rst(rst), .d(EX_MEM_PC_Add_r), .q(MEM_WB_PC_Add_r)
	);*/
	
	flopr #(.WIDTH(32)) instr_r(
		.clk(clk), .rst(rst), .d(MEM_instr), .q(MEM_WB_instr)
	);
	
	flopr #(.WIDTH(32))	DataMem_r(
		.clk(clk), .rst(rst), .d(DataMem), .q(DataMem_MEM_WB_r)
	);

	flopr #(.WIDTH(32))	ALUOut_r(
		.clk(clk), .rst(rst), .d(ALUOut), .q(ALUOut_MEM_WB_r)
	);

	flopr #(.WIDTH(5))	WriteDst_r(
		.clk(clk), .rst(rst), .d(WriteDst), .q(WriteDst_MEM_WB_r)
	);

	endmodule
