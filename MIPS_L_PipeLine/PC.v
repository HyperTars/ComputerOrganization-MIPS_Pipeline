module PC( clk, rst, NPC, PC );
           
	input         clk;
	input         rst;
	input  [31:2] NPC;
	output [31:2] PC;
   
	reg [31:2] PC;
	reg [1:0] tmp;
	//initial tmp = 2'b00;

	always @(posedge clk or posedge rst) begin
		if ( rst ) 
			{PC, tmp} <= 32'h0000_3000;   
		else 
			PC <= NPC;
	end // end always
           
endmodule
