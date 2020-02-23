module mips( clk, rst );
	//clock signal
	input   clk;
	input   rst;
   
	//instr devided
	wire	[29:0]	PC;
	wire	[29:0]	NPC;
	wire	[29:0]	IF_ID_PC_r;
	wire	[29:0]	ID_EX_PC_r;
	wire	[29:0]	EX_MEM_PC_r;
	wire	[29:0]	MEM_WB_PC_r;
	wire	[31:0]	im_dout;	//instruction Memory Fetch instr
	wire	[31:0]	dm_dout;	//data Memory Fetch Data
	wire	[31:0]	DataMem_r;
	wire	[31:0]	ID_instr;
	wire	[31:0]	EX_instr;
	wire	[31:0]	MEM_instr;
	wire	[31:0]	WB_instr;
	wire	[4:0]	WriteReg;
	wire	[31:0]	WriteData;
	wire	[31:0]	RD1;
	wire	[31:0]	RD1_r;
	wire	[31:0]	RD2;
	wire	[31:0]	RD2_r;
	wire	[31:0]	Imm32;
	wire	[31:0]	ImmExt_r;
	wire	[31:0]	ALUOut_C;
	wire	[31:0]	ALUOut_C_r;
	wire	[31:0]	ALUOut_C_MEM_WB_r;
	wire	[31:0]	A_Reg;
	wire	[31:0]	B_Reg;
	wire	[31:0]	B_Reg_r;
	wire	[31:0]	ALUSource_A;
	wire	[31:0]	ALUSource_B;
	wire	[31:0]	ALUSource_B_r;
	wire	[4:0]	WriteDst_EX;
	wire	[4:0]	WriteDst_MEM;
	wire	[4:0]	WriteDst_WB;
		

	//Control Signal
	wire			jmpSignal;
	wire			brSignal;
	wire			brSignal_r;
	wire			jmpRSignal;
	wire			stallSignal;
	
	wire	[1:0]	EXTOp;
	wire			control_EX_MemRead;

	wire	[1:0]	ASel;
	wire			BSel;
	wire	[4:0]	ALUOp;
	wire			WriteDstSel;
	wire	[1:0]	byPasserSelA;
	wire	[1:0]	byPasserSelB;
	wire			EX_ctrl_RegWr;

	
	wire			MEM_ctrl_RegWr;
	wire	[1:0]	be;
	wire			DMWr;

	wire	[1:0]	WriteContentSel;
	wire			WB_ctrl_RegWr;
	wire			WriteDstRegSel;

   
	/*********************************************/
	/*			Step 1:	Instruction Fetch		 */
	/*********************************************/
	//(IF) define PC
	PC U_PC (
      .clk(clk), .rst(rst), .NPC(NPC), 
	    .PC(PC)
	); 

	//Instruction Jr will use the RD1_r transferred to NPC, (Attention) PC is 30-bit in NPC
	NPC U_NPC (
		.PC(PC), .Imm(ID_instr[25:0]), .jmpReg(RD1), 
		.jmpSignal(jmpSignal), .brSignal(brSignal), .jmpRSignal(jmpRSignal), .stallSignal(stallSignal), 		.NPC(NPC)
	);
   
	//(IF) define Instruction Register to Fetch Instructions in Memory
	im_4k U_IM ( 
      .addr(PC[9:0]) , .dout(im_dout)
	);
   
	//(IF) define IF/ID Register
	Reg_IF_ID U_Reg_IF_ID (
		.stallSignal(stallSignal), .jmpSignal(jmpSignal), .jmpRSignal(jmpRSignal),
		.clk(clk), .rst(rst), 
		.PC(PC), .IF_ID_PC_r(IF_ID_PC_r),
		.instr(im_dout), .instr_IF_ID_r(ID_instr)
	);
   
	/*********************************************/
	/*	  Step 2: Register File & Jump & Branch	 */
	/*********************************************/

	//(RF) define Mux of A3 Port for Register File
	ctrl ID_ctrl(
		.clk(clk), .rst(rst), .instr(ID_instr), .step(2'b00),
		.EXTOp(EXTOp), .jmpSignal(jmpSignal), .jmpRSignal(jmpRSignal)
	);

	//(RF) define the hazard detector
	//(Hazard Detector is for Load Word to write RegisterFile, have to wait for one clock)
	//Line1:Base
	//Line2 & 3:input(judge source in IF/ID and ID/EX)
	//Line4:output(control)	
	HazardDetector U_HazardDetector (
	   .rs_ID(ID_instr[25:21]), .rt_ID(ID_instr[20:16]), 
	   .MemRead_EX(control_EX_MemRead), .WriteDst_EX(WriteDst_EX), 
	   .brSignal(brSignal), .EX_ctrl_regWr(EX_ctrl_RegWr),
	   .stallSignal(stallSignal)
	);
      
	//(RF) define Register File
		RF U_RF (
		.clk(clk), .RFWr(WB_ctrl_RegWr),
		.A1(ID_instr[25:21]), .A2(ID_instr[20:16]), .A3(WriteReg), .WD(WriteData), 
		.RD1(RD1), .RD2(RD2)
	);
   
	//(RF) define 16-to-32 Extender
	//EXTOp Decide : ZERO / SIGNED / HIGHPOS
	EXT U_EXT ( 
      .Imm16(ID_instr[15:0]), .EXTOp(EXTOp), 
	   .Imm32(Imm32) 
	);
	
	//(RF) define branch judge and branch
	brancher U_brancher (
		.clk(clk), .rst(rst),
		.Op(ID_instr[31:26]), .rs(ID_instr[25:21]), .rt(ID_instr[20:16]), .Imm(ID_instr[15:0]),
		.brSignal(brSignal),
		.WriteDst_EX(WriteDst_EX), .WriteDst_MEM(WriteDst_MEM),
		.RD1(RD1), .RD2(RD2), .ALUOut_C(ALUOut_C), .dm_dout(dm_dout),
		.EX_ctrl_RegWr(EX_ctrl_RegWr), .MEM_ctrl_RegWr(MEM_ctrl_RegWr)
		);

	//(RF) define ID/EX Register
	Reg_ID_EX U_Reg_ID_EX(
		.clk(clk), .rst(rst), .stallSignal(stallSignal), 
		.ID_instr_r(ID_instr), .ID_EX_instr(EX_instr), 
		.RD1(RD1), .RD2(RD2), .ImmExt(Imm32),
		.RD1_ID_EX_r(RD1_r), .RD2_ID_EX_r(RD2_r), .ImmExt_r(ImmExt_r),
		.brSignal(brSignal), .brSignal_r(brSignal_r),
		.IF_ID_PC_r(IF_ID_PC_r), .ID_EX_PC_r(ID_EX_PC_r)
		);

	/*********************************************/
	/*			 Step 3:	Execution			 */
	/*********************************************/

	//(EXE) define Next PC Calculator
	ctrl EX_ctrl (
		.clk(clk), .rst(rst), .instr(EX_instr), .step(2'b01),
		.control_EX_MemRead(control_EX_MemRead), .ASel(ASel), .BSel(BSel), .ALUOp(ALUOp), .WriteDstSel(WriteDstSel), .EX_ctrl_regWr(EX_ctrl_RegWr)
		);

	//(EXE) define byPasser Unit
	byPasser U_byPasser (
		.clk(clk), .rst(rst),
		.WriteDst_MEM(WriteDst_MEM), .WriteDst_WB(WriteReg),
		.rs_EX(EX_instr[25:21]), .rt_EX(EX_instr[20:16]),
		.MEM_ctrl_RegWr(MEM_ctrl_RegWr), .WB_ctrl_RegWr(WB_ctrl_RegWr),
		.byPasserSelA(byPasserSelA), .byPasserSelB(byPasserSelB)
	);

	//(EXE) define Mux of A Port from Register RD1 ( Control by byPasser )
	mux4 #(.WIDTH(32)) A_Reg_Mux (
		.d0(RD1_r), .d1(WriteData), .d2(ALUOut_C_r), .d3(0), .s(byPasserSelA), .y(A_Reg)
	);

	//If it is from A_Reg, it won't affect this mux
	//(EXE) define Mux of A Port for ALU_in (only for setting LUI's 16)
	mux4 #(.WIDTH(32)) A_Mux (
		.d0(A_Reg), .d1(5'b10000), .d2({27'b0, EX_instr[10:6]}), .d3(0), .s(ASel), .y(ALUSource_A)
	);
   
	//(EXE) define Mux of B Port from Register RD2 ( Control by byPasser )
	mux4 #(.WIDTH(32)) B_Reg_Mux (
		.d0(RD2_r), .d1(WriteData), .d2(ALUOut_C_r), .d3(0), .s(byPasserSelB), .y(B_Reg)
	);

	//(EXE) define Mux of B Port for ALU_in
	mux2 #(.WIDTH(32)) B_Mux (
		.d0(B_Reg), .d1(ImmExt_r), .s(BSel), .y(ALUSource_B)
	);
   
	//(EXE) define ALU
	alu U_ALU ( 
		.A(ALUSource_A), .B(ALUSource_B), .ALUOp(ALUOp), .C(ALUOut_C)
	);
   
	//(EXE) define Write Destination Register
	mux2 #(.WIDTH(5)) RegDst_Mux (
		.d0(EX_instr[20:16]), .d1(EX_instr[15:11]), .s(WriteDstSel), .y(WriteDst_EX)
	);


	//(EXE) define Reg-Locker for ALU_Out
	Reg_EX_MEM U_Reg_EX_MEM (
	   .clk(clk), .rst(rst), 
	   .EX_instr(EX_instr), .EX_MEM_instr(MEM_instr),
	   .ALUOut(ALUOut_C), .ALUSource_B(ALUSource_B), .WriteDst(WriteDst_EX),
	   .ALUOut_EX_MEM_r(ALUOut_C_r), .ALUSource_B_EX_MEM_r(ALUSource_B_r), .WriteDst_EX_MEM_r(WriteDst_MEM),
	   .B_Reg(B_Reg), .B_Reg_r(B_Reg_r),
	   .ID_EX_PC_r(ID_EX_PC_r), .EX_MEM_PC_r(EX_MEM_PC_r)
   );

	/*********************************************/
	/*			Step 4:	Memory Read & Write		 */
	/*********************************************/

	//(MEM) define Data-to-Memory Saver (Save Data to Mem)
	ctrl MEM_ctrl (
		.clk(clk), .rst(rst), .instr(MEM_instr), .step(2'b10),
		.MEM_ctrl_regWr(MEM_ctrl_RegWr), .be(be), .DMWr(DMWr)
	);

	//'be' defines store word/byte/H?, for all test instructions are in Word, I set it 4'b1111
	//Store Word will store ALUSource_B_r To ALUOut_C_r
	//Load Word will load ALUOut_C_r to dm_dout
	dm_4k U_DM ( 
		.addr(ALUOut_C_r[11:2]), .din(B_Reg_r), 
		.be(4'b1111), .DMWr(DMWr), 
		.clk(clk), .dout(dm_dout)
	);
   
	//(MEM) define Reg
	Reg_MEM_WB U_Reg_MEM_WB (
		.clk(clk), .rst(rst), 
		.MEM_instr(MEM_instr), .MEM_WB_instr(WB_instr),
		.DataMem(dm_dout), .DataMem_MEM_WB_r(DataMem_r),
		.ALUOut(ALUOut_C_r), .ALUOut_MEM_WB_r(ALUOut_C_MEM_WB_r),
		.WriteDst(WriteDst_MEM), .WriteDst_MEM_WB_r(WriteDst_WB),
		.EX_MEM_PC_r(EX_MEM_PC_r), .MEM_WB_PC_r(MEM_WB_PC_r)
	);

	/*********************************************/
	/*			 Step 5:	Write Back			 */
	/*********************************************/

	//(WB) define Mux of Write Data Port for Register File
	ctrl WB_ctrl (
		.clk(clk), .rst(rst), .instr(WB_instr), .step(2'b11),
		.WB_ctrl_regWr(WB_ctrl_RegWr), .WriteContentSel(WriteContentSel), .WriteDstRegSel(WriteDstRegSel)
	);
	
	mux2 #(.WIDTH(5)) WriteDstReg (
		.d0(WriteDst_WB), .d1(5'd31), .s(WriteDstRegSel), .y(WriteReg)
	);
	
	//PC(30) need to be left-shift 2 bits to extend to 32 (for JAL)
	mux4 #(.WIDTH(32)) WriteContent_MUX (
		.d0(ALUOut_C_MEM_WB_r), .d1(DataMem_r), .d2({MEM_WB_PC_r+1, 2'b00}), .d3(0), 
		.s(WriteContentSel), .y(WriteData)
	);
endmodule
