`include "ctrl_encode_def.v"
`include "instruction_def.v"
module brancher(clk, rst, Op, rs, rt, Imm,
	brSignal,
	WriteDst_EX, WriteDst_MEM,
	RD1, RD2, ALUOut_C, dm_dout,
	EX_ctrl_RegWr, MEM_ctrl_RegWr
	);

	input			clk, rst;
	input	[15:0]	Imm;
	input	[4:0]	rs;
	input	[4:0]	rt;
	input	[5:0]	Op;

	input	[4:0]	WriteDst_EX;
	input	[4:0]	WriteDst_MEM;
	
	input			EX_ctrl_RegWr;
	input			MEM_ctrl_RegWr;

	input	[31:0]	RD1;
	input	[31:0]	RD2;
	input	[31:0]	ALUOut_C;
	input	[31:0]	dm_dout;
	
	output	brSignal;
	
	reg		brSignal;
	reg		Zero;
	reg  [31:0]  R1;
	reg  [31:0]  R2;
	
	wire		[31:0]	RD1;
	wire		[31:0]	RD2;

	initial
	begin
	end

	always @(*) begin	  
	Zero = 0;
	brSignal = 0;

	  R1 = RD1;
	  R2 = RD2;
	if (EX_ctrl_RegWr && (rs == WriteDst_EX))
		R1 = ALUOut_C;
	if (EX_ctrl_RegWr && (rt == WriteDst_EX))
		R2 = ALUOut_C;
	if (MEM_ctrl_RegWr && (rs == WriteDst_MEM))
		R1 = dm_dout;
	if (MEM_ctrl_RegWr && (rt == WriteDst_MEM))
		R2 = dm_dout;

	if (R1 == R2)
		Zero = 1;
	if ( Op == `INSTR_BEQ_OP && Zero)
		brSignal = 1;
	if ( Op == `INSTR_BNE_OP && !Zero)
		brSignal = 1;
		/*
		Op == `INSTR_BNE_OP
		Op == `INSTR_BGEZ_OP
		Op == `INSTR_BGTZ_OP
		Op == `INSTR_BLEZ_OP
		Op == `INSTR_BLTZ_OP
		*/	
	end
endmodule
