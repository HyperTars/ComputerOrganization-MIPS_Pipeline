`include "ctrl_encode_def.v"
`include "instruction_def.v"

module byPasser ( WriteDst_MEM, WriteDst_WB,
	rs_EX, rt_EX,
	MEM_ctrl_RegWr, WB_ctrl_RegWr,
	byPasserSelA, byPasserSelB
	);

	input	[4:0]	WriteDst_MEM;
	input	[4:0]	WriteDst_WB;
	input	[4:0]	rs_EX;
	input	[4:0]	rt_EX;
	input			MEM_ctrl_RegWr;
	input			WB_ctrl_RegWr;
	
	output	[1:0]	byPasserSelA;
	output	[1:0]	byPasserSelB;

	reg [1:0]	byPasserSelA;
	reg	[1:0]	byPasserSelB;
  	
	always @(*) begin
	byPasserSelA = 2'b00;
	byPasserSelB = 2'b00;
	
	//WB
	if (WB_ctrl_RegWr && WriteDst_WB != 0)
		begin
		if (rs_EX == WriteDst_WB)
			byPasserSelA = 2'b01;
		
		if (rt_EX == WriteDst_WB)
			byPasserSelB = 2'b01;
		end
	//MEM
	if (MEM_ctrl_RegWr && WriteDst_MEM != 0)
		begin
		if (rs_EX == WriteDst_MEM)
			byPasserSelA = 2'b10;

		if (rt_EX == WriteDst_MEM)
			byPasserSelB = 2'b10;
		end

	end
endmodule
