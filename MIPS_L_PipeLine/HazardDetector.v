module HazardDetector ( rs_ID, rt_ID, 
	MemRead_EX, WriteDst_EX,
	brSignal, EX_ctrl_regWr,
	stallSignal
	);
	//Rt As Load Word - Write Destination
	
	input	[4:0]	rs_ID;
	input	[4:0]	rt_ID;
	input			MemRead_EX;
	input	[4:0]	WriteDst_EX;
	input			brSignal;
	input			EX_ctrl_regWr;

	output			stallSignal;

	wire	[4:0]	WriteDst_EX;
	wire	[4:0]	rt_ID;
	wire	[4:0]	rs_ID;
	wire			MemRead_EX;
  
	reg				stallSignal;
	reg				lwH;
	reg				brH;
  
	always @(*) begin
		stallSignal = 0;		
		lwH = MemRead_EX & ((WriteDst_EX == rt_ID) || WriteDst_EX == rs_ID) & !((WriteDst_EX == 0) || (rt_ID == 0) || (rs_ID == 0));
		brH = brSignal & EX_ctrl_regWr & ((WriteDst_EX == rt_ID) || (WriteDst_EX == rs_ID));
		if (lwH || brH)
			stallSignal = 1;
	end
endmodule
