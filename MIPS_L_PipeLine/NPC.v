`include "ctrl_encode_def.v"
module NPC( 
		PC, jmpReg, Imm,
		jmpSignal, brSignal, jmpRSignal, stallSignal,
		NPC
	);
	
	//input Addr (can be 32 except PC)
	input	[31:2]	PC;
	input	[25:0]	Imm;
	input	[31:0]	jmpReg;

	//input Signal
	input	jmpSignal;
	input	brSignal;
	input	jmpRSignal;
	input	stallSignal;
 
	output [31:2] NPC;   //(Attetion) the output of NPC is 30-bit, which causes a lot speciality
   
	reg [31:2] NPC;		//declare a reg to save NPC
   
	always @(*) begin
		  NPC = PC + 1;
			if (stallSignal)
				NPC = PC;
			if (brSignal == 1)
				NPC = PC + {{14{Imm[15]}}, Imm[15:0]};
			if (jmpSignal == 1)
				NPC = {PC[31:28], Imm[25:0]};
			if (jmpRSignal == 1)
				NPC = jmpReg[31:2];
	end // end always
endmodule
