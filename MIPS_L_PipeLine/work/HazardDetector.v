module HazardDetector ( clk, rst, 
	rs_ID, rt_ID, 
	MemRead_EX, WriteDst_EX,
	PC_Write, Reg_ID_EX_Control_Mux,
	brSignal, EX_ctrl_regWr,
	stallSignal
	);
	//Rt As Load Word - Write Destination
	
	input	clk, rst;
	input	[4:0]	rs_ID;
	input	[4:0]	rt_ID;
	input			MemRead_EX;
	input	[4:0]	WriteDst_EX;
	input    brSignal;
	input    EX_ctrl_regWr;

	output			PC_Write;
	output			stallSignal;
	output			Reg_ID_EX_Control_Mux;

	wire	[4:0]	WriteDst_EX;
	wire	[4:0]	rt_ID;
	wire	[4:0]	rs_ID;
	wire			MemRead_EX;
  
	reg PC_Write;
	reg	stallSignal;
	reg Reg_ID_EX_Control_Mux;
	reg lwH;
	reg	brH;
  
	always @(*) begin
		stallSignal = 0;
		Reg_ID_EX_Control_Mux = 0;		//From Control Decode Unit
		PC_Write = 1;
		
		lwH = MemRead_EX & ((WriteDst_EX == rt_ID) || WriteDst_EX == rs_ID) & !((WriteDst_EX == 0) || (rt_ID == 0) || (rs_ID == 0));
		brH = brSignal & EX_ctrl_regWr & ((WriteDst_EX == rt_ID) || (WriteDst_EX == rs_ID));
		if (lwH || brH)
		begin
		//PC_Write = 0;
		stallSignal = 1;
		Reg_ID_EX_Control_Mux = 1;	//From Zero (Flush All)
		end
	end
endmodule
