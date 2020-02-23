`include "ctrl_encode_def.v"
module NPC( 
		PC, jmpReg, Imm, PC_r,
		jmpSignal, brSignal, jmpRSignal, stallSignal, brSignal_r,
		NPC, nonSeq
	);
	
	//input Addr (can be 32 except PC)
	input	[31:2]	PC;
	input	[25:0]	Imm;
	input	[31:0]	jmpReg;
	input	[29:0]	PC_r;

	//input Signal
	input	jmpSignal;
	input	brSignal;
	input	jmpRSignal;
	input	stallSignal;
	output nonSeq;
 
	output [31:2] NPC;   //(Attetion) the output of NPC is 30-bit, which causes a lot speciality
   
	reg [31:2] NPC;		//declare a reg to save NPC
	reg  nonSeq;
   
	always @(*) begin
	    nonSeq = 0;
		  NPC = PC + 1;
			if (stallSignal)
				NPC = PC;
			if (brSignal == 1)
				NPC = PC + {{14{Imm[15]}}, Imm[15:0]};
			if (jmpSignal == 1)
				NPC = {PC[31:28], Imm[25:0]};
			if (jmpRSignal == 1)
				NPC = jmpReg[31:2];
			if (stallSignal || brSignal_r || jmpSignal || jmpRSignal)
			  nonSeq = 1;
			   end // end always
endmodule
