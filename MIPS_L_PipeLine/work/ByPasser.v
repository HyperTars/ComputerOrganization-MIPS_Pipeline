`include "ctrl_encode_def.v"
`include "instruction_def.v"

module byPasser ( clk, rst,
	WriteDst_EX_MEM, WriteDst_MEM_WB,
	rs_ID_EX_r, rt_ID_EX_r,
	MEM_ctrl_RegWr, WB_ctrl_RegWr,
	byPasserSelA, byPasserSelB
	);

	input	clk, rst;
	input	[4:0]	WriteDst_EX_MEM;
	input	[4:0]	WriteDst_MEM_WB;
	input	[4:0]	rs_ID_EX_r;
	input	[4:0]	rt_ID_EX_r;
	input			MEM_ctrl_RegWr;
	input			WB_ctrl_RegWr;
	
	output	[1:0]	byPasserSelA;
	output	[1:0]	byPasserSelB;

	reg [1:0]	byPasserSelA;
	reg	[1:0]	byPasserSelB;
  	
	always @(*) begin
	byPasserSelA = 2'b00;
	byPasserSelB = 2'b00;
	
	//MEM
	if (WB_ctrl_RegWr && WriteDst_MEM_WB != 0)
		begin
		if (rs_ID_EX_r == WriteDst_MEM_WB)
			byPasserSelA = 2'b01;
		
		if (rt_ID_EX_r == WriteDst_MEM_WB)
			byPasserSelB = 2'b01;
		end
	//EX
	if (MEM_ctrl_RegWr && WriteDst_EX_MEM != 0)
		begin
		if (rs_ID_EX_r == WriteDst_EX_MEM)
			byPasserSelA = 2'b10;

		if (rt_ID_EX_r == WriteDst_EX_MEM)
			byPasserSelB = 2'b10;
		end

	end
endmodule
