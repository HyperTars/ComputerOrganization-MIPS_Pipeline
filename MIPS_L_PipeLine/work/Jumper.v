`include "instruction_def.v"
`include "ctrl_encode_def.v"
module jumper(clk, rst, Op, Funct, InstrAddr, PC, 
	jmpSign);
	input			clk, rst;
	input	[5:0]	Op;
	input	[5:0]	Funct;
	input	[25:0]	InstrAddr;		//Addr in Instruction
	input	[31:0]	PC;				//PC
	output			jmpSign;		//whether happens jump

	reg   jmpSign;
	initial jmpSign = 0; //Set jmpSign Default As 0
	always @(*) begin
		if ( Op == `INSTR_J_OP || Op == `INSTR_JAL_OP )
			jmpSign = 1;
	
		if ( Op == `INSTR_RTYPE_OP && Funct == `INSTR_JR_FUNCT)
			jmpSign = 1;
	end
endmodule
