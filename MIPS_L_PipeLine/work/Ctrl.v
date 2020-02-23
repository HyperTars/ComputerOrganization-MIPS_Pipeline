`include "ctrl_encode_def.v"
`include "instruction_def.v"
module ctrl(clk, rst, instr, step,
		EXTOp, brSignal, jmpSignal, jmpRSignal,
		control_EX_MemRead, ASel, BSel, ALUOp, WriteDstSel, EX_ctrl_regWr,
		MEM_ctrl_regWr, be, DMWr,
		WB_ctrl_regWr, WriteContentSel,
	);
           


	/********************************************/
	/*		Control Signal Defination Start		*/
	/********************************************/
	input 			clk, rst;
	input	[1:0]	step;
	input	[31:0]	instr;

	//Control Signal in Step2:ID
	//step = 2'b00
	output	[1:0]	EXTOp;
	output			brSignal;
	output			jmpSignal;
	output			jmpRSignal;

	//Control Signal in Step3:EX
	//step = 2'b01
	output			EX_ctrl_regWr;
	output			control_EX_MemRead;
	output	[1:0]	ASel;			//from reg | 5'b10000(Lui) | shamt (Shift)
	output			BSel;			//from reg(R-Type)、sw | ImmExt_r(I-Type)
	output	[4:0]	ALUOp;
	output			WriteDstSel;	//from rt(I-Type) | rd(R-Type)

	//Control Signal in Step4:MEM
	//step = 2'b10
	output			MEM_ctrl_regWr;
	output	[1:0]	be;				//control Memory Word Type b(00), h(01), w(10)
	output			DMWr;
	
	//Control Signal in Step5:WB
	//step = 2'b11
	output			WB_ctrl_regWr;	
	output	[1:0]	WriteContentSel;	//from ALUOut | DataMem | PC(JAL)
	/********************************************/
	
	
	/********************************************/
	/*		List All MIPS Instruction Type		*/
	/********************************************/

	wire	RType;   // Type of R-Type Instruction
	wire	IType;   // Tyoe of Imm    Instruction  
	wire	BrType;  // Type of Branch Instruction
	wire	JType;   // Type of Jump   Instruction
	wire	LdType;  // Type of Load   Instruction
	wire	StType;  // Type of Store  Instruction
	wire	MemType; // Type pf Memory Instruction(Load/Store)
	
	wire	[5:0]	Op;
	wire	[5:0]	Funct;
	wire	[4:0]	rs;
	wire	[4:0]	rt;
	wire	[4:0]	rd;
	wire	[15:0]	Imm16;
	wire	[25:0]	IMM;
	wire	[31:0]	shamt;
	
	assign	Op = instr[31:26];
	assign	Funct = instr[5:0];
	assign	rs = instr[25:21];
	assign	rt = instr[20:16];
	assign	rd = instr[15:11];
	assign	Imm16 = instr[15:0];			//I-Type
	assign	IMM = instr[25:0];				//J-Type
	assign	shamt = {32'b0, instr[10:6]};	//R-Type
	
	//Complete All Type, set XType 1 if instrucion belongs to XType
	assign RType   = (Op == `INSTR_RTYPE_OP);
	assign IType   = (Op == `INSTR_ADDI_OP || Op == `INSTR_ADDIU_OP || Op == `INSTR_ANDI_OP || Op == `INSTR_ORI_OP || Op == `INSTR_XORI_OP || Op == `INSTR_LUI_OP || Op == `INSTR_SLTI_OP || Op == `INSTR_SLTIU_OP);
	assign BrType  = (Op == `INSTR_BEQ_OP || Op == `INSTR_BNE_OP || Op == `INSTR_BGEZ_OP || Op == `INSTR_BGTZ_OP || Op == `INSTR_BLEZ_OP || Op == `INSTR_BLTZ_OP);
	assign JType   = (Op == `INSTR_J_OP || Op == `INSTR_JAL_OP);
	assign LdType  = (Op == `INSTR_LW_OP || Op == `INSTR_LB_OP || Op == `INSTR_LH_OP || Op == `INSTR_LBU_OP || Op == `INSTR_LHU_OP);
	assign StType  = (Op == `INSTR_SW_OP || Op == `INSTR_SB_OP || Op == `INSTR_SH_OP);
	assign MemType = LdType || StType;
	/********************************************/

    
	/****************************************/
	/*			Control		Signal			*/
	/****************************************/
	reg	[1:0]	EXTOp;
	reg  brSignal;
	reg  jmpSignal;
	reg  jmpRSignal;

	reg			EX_ctrl_regWr;
	reg			control_EX_MemRead;
	reg	[1:0]	ASel;
	reg			BSel;
	reg	[4:0]	ALUOp;
	reg			WriteDstSel;

	reg			MEM_ctrl_regWr;
	reg	[1:0]	be;
	reg			DMWr;
	
	reg			WB_ctrl_regWr;
	reg	[1:0]	WriteContentSel;
	
	initial
	begin
		EX_ctrl_regWr = 0;
		brSignal = 0;
		jmpSignal = 0;
		jmpRSignal = 0;
		EXTOp = `EXT_SIGNED;
	 
		EX_ctrl_regWr = 0;
		control_EX_MemRead = 0;
		ASel = 2'b00;
		BSel = 1'b0;
		ALUOp = 0;
		WriteDstSel = 0;

		MEM_ctrl_regWr = 1'b0;
		be = `BE_SW;
		DMWr = 1'b0;

		WB_ctrl_regWr = 1'b0;
		WriteContentSel = 2'b00;
	end

 	always @(*) begin
	/****************************************/
	/*		Step2: Instruction Decode		*/
	/****************************************/
	//Set Valid
	if (IType)
		EXTOp = `EXT_UNSIGNED;
	if (RType && (Funct == `INSTR_JR_FUNCT || Funct == `INSTR_JALR_FUNCT))
	begin
		EXTOp = `EXT_SIGNED;
		jmpRSignal = 1;
		end
	if (BrType)
		EXTOp = `EXT_SIGNED;
	if (JType)
	begin
		EXTOp = `EXT_SIGNED;
		jmpSignal = 1;
	end
	if (StType)
		EXTOp = `EXT_SIGNED;
	/****************************************/

	/****************************************/
	/*				Step3: EXE				*/
	/****************************************/
	//Set Valid
	control_EX_MemRead = 0;
	EX_ctrl_regWr = 1'b0;
	if (RType || IType || LdType)
		EX_ctrl_regWr = 1'b1;

	if (LdType || StType)
	begin
		ASel = 2'b00;
		BSel = 1'b1;
		control_EX_MemRead = 1;
		ALUOp = `ALUOp_ADD;
		WriteDstSel = 1'b0;
	end

	if (RType)
	begin
		ASel = 2'b00;
		BSel = 1'b0;
		WriteDstSel = 1'b1;
		case (Funct)
			`INSTR_ADD_FUNCT: ALUOp = `ALUOp_ADD;
            `INSTR_ADDU_FUNCT: ALUOp = `ALUOp_ADDU;
            `INSTR_SUB_FUNCT: ALUOp = `ALUOp_SUB;
            `INSTR_SUBU_FUNCT: ALUOp = `ALUOp_SUBU;
			`INSTR_AND_FUNCT: ALUOp = `ALUOp_AND;
            `INSTR_NOR_FUNCT: ALUOp = `ALUOp_NOR;
            `INSTR_OR_FUNCT: ALUOp = `ALUOp_OR;
            `INSTR_XOR_FUNCT: ALUOp = `ALUOp_XOR;
            `INSTR_SLT_FUNCT: ALUOp = `ALUOp_SLT;
            `INSTR_SLTU_FUNCT: ALUOp = `ALUOp_SLTU;
			`INSTR_SLL_FUNCT:
			begin
				ALUOp = `ALUOp_SLL;
				ASel = 2'b10;
			end
			`INSTR_SRL_FUNCT: 
            begin
                ALUOp = `ALUOp_SRL;
                ASel = 2'b10;
            end  
            `INSTR_SRA_FUNCT:
            begin
				ALUOp = `ALUOp_SRA;
				ASel = 2'b10;
            end
            `INSTR_SLLV_FUNCT:
            begin
                ALUOp = `ALUOp_SLL;
                ASel = 2'b10;
                BSel = 1'b0;
            end
			`INSTR_SRLV_FUNCT:
            begin
                ALUOp = `ALUOp_SRL;
                ASel = 2'b10;
			end
            `INSTR_SRAV_FUNCT:
            begin
                ALUOp = `ALUOp_SRA;
                ASel = 2'b10;
            end
			
			/*Remain To Be Done*/
			/*
			`INSTR_JR_FUNCT:
			begin
				PCWr = 1'b1;
				jmpRSignal = 1;
				EXTOp = `EXT_SIGNED;
			end
			*/
		   default:;
	   endcase
	end

	if (IType)
	begin
		ASel = 2'b00;
		BSel = 1'b1;
		WriteDstSel = 1'b0;
		if (Op == `INSTR_ADDI_OP)
			ALUOp = `ALUOp_ADD;
		if (Op == `INSTR_ADDIU_OP)
			ALUOp = `ALUOp_ADD;
		if (Op == `INSTR_ANDI_OP)
			ALUOp = `ALUOp_AND;
		if (Op == `INSTR_ORI_OP)
			ALUOp = `ALUOp_OR;
		if (Op == `INSTR_XORI_OP)
			ALUOp = `ALUOp_XOR;
		if (Op == `INSTR_LUI_OP)
		begin
			ASel = 2'b01;
			ALUOp = `ALUOp_SLL;
		end
		if (Op == `INSTR_SLTI_OP)
			ALUOp = `ALUOp_SLT;
		if (Op == `INSTR_SLTIU_OP)
			ALUOp = `ALUOp_SLT;
	end
    /****************************************/

	/****************************************/
	/*				Step4: MEM				*/
	/****************************************/
	//Set Valid
	if (RType || IType || LdType)
		MEM_ctrl_regWr = 1'b1;
	if (MemType)
	begin
		if (Op == `INSTR_LW_OP || Op == `INSTR_SW_OP)
			be = `BE_SW;
		if (Op == `INSTR_LH_OP || Op == `INSTR_SH_OP)
			be = `BE_SH;
		if (Op == `INSTR_LB_OP || Op == `INSTR_SB_OP)
			be = `BE_SB;
	end
	if (StType)
		DMWr = 1'b1;
	else
		DMWr = 1'b0;
	/****************************************/


	/****************************************/
	/*				Step5: WB				*/
	/****************************************/
	WB_ctrl_regWr = 1'b0;
	if (RType || IType || LdType)
		WB_ctrl_regWr = 1'b1;
	if (LdType)
		WriteContentSel = 2'b01;
	if (Op == `INSTR_JAL_OP)
		WriteContentSel = 2'b10;
	/****************************************/
	end
endmodule
