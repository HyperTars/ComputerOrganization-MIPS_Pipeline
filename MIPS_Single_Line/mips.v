module mips( clk, rst );
   input   clk;
   input   rst;
   
   wire 		     RFWr;
   wire 		     DMWr;
   wire 		     PCWr;
   wire 		     IRWr;
   wire [1:0]  EXTOp;
   wire [4:0]  ALUOp;
   wire [1:0]  NPCOp;
   wire [1:0]  GPRSel;
   wire [1:0]  WDSel;
   wire [1:0]  ASel; //New Design for LUI Instr to set ALU_Source_A: 16
   wire 		     BSel;
   wire 		     Zero;
   wire [29:0] PC, NPC;
   wire [31:0] im_dout, dm_dout, dm_dout_r;
   wire [31:0] DR_out;
   wire [31:0] instr;
   wire [4:0]  rs;
   wire [4:0]  rt;
   wire [4:0]  rd;
   wire [4:0]  shamt;
   wire [5:0]  Op;
   wire [5:0]  Funct;
   wire [15:0] Imm16; 
   wire [31:0] Imm32;
   wire [25:0] IMM;
   wire [4:0]  A3;
   wire [31:0] WD;
   wire [31:0] RD1, RD1_r, RD2, RD2_r;
   wire [31:0] A, B, C, C_r; //New Design A for LUI Instr to set Mux_A_Out
   
   assign Op = instr[31:26];
   assign Funct = instr[5:0];
   assign rs = instr[25:21];
   assign rt = instr[20:16];
   assign rd = instr[15:11];
   assign Imm16 = instr[15:0];
   assign IMM = instr[25:0];
   assign shamt = {32'b0, instr[10:6]}; //New Design to Extend shamt to Input to Mux_A
   //define Controller
   ctrl U_CTRL(
      .clk(clk),	.rst(rst), .Zero(Zero), .Op(Op), .Funct(Funct), .RFWr(RFWr), .DMWr(DMWr), .PCWr(PCWr), .IRWr(IRWr), .EXTOp(EXTOp), .ALUOp(ALUOp), .NPCOp(NPCOp), .GPRSel(GPRSel), .WDSel(WDSel), .ASel(ASel), .BSel(BSel)
   );
   
   //(IF) define PC
   PC U_PC (
      .clk(clk), .rst(rst), .PCWr(PCWr), .NPC(NPC), .PC(PC)
   ); 
   
   //(IF) define Instruction Register to Fetch Instructions in Memory
   im_4k U_IM ( 
      .addr(PC[9:0]) , .dout(im_dout)
   );
   
   //(IF) define Instruction Register
   IR U_IR ( 
      .clk(clk), .rst(rst), .IRWr(IRWr), .im_dout(im_dout), .instr(instr)
   );
   
   //(DC/RF) define Mux of A3 Port for Register File
   mux4 #(.WIDTH(5)) RF_MUX (
      .d0(rd), .d1(rt), .d2(5'd31), .s(GPRSel), .y(A3)
   );
   
   //(DCD/RF) define Register File
   RF U_RF (
      .A1(rs), .A2(rt), .A3(A3), .WD(WD), .clk(clk), 
      .RFWr(RFWr), .RD1(RD1), .RD2(RD2)
   );
   
   //(DCD/RF) define 16-to-32 Extender
   EXT U_EXT ( 
      .Imm16(Imm16), .EXTOp(EXTOp), .Imm32(Imm32) 
   );
   
   //(DCD/RF) define Reg-Locker for A
   flopr #(.WIDTH(32)) U_RD1_r (
      .clk(clk), .rst(rst), .d(RD1), .q(RD1_r)
   );
   
   //(DCD/RF) define Reg-Locker for B
   flopr #(.WIDTH(32)) U_RD2_r (
      .clk(clk), .rst(rst), .d(RD2), .q(RD2_r)
   );
   
   //(EXE) define Next PC Calculator
   //Instruction Jr will use the RD1_r transferred to NPC, (Attention) PC is 30-bit in NPC
   NPC U_NPC (
      .PC(PC), .NPCOp(NPCOp), .IMM(IMM), .NPC(NPC), .JMPR(RD1_r >> 2'b10)
   );
   
   //(EXE) define Mux of A Port for ALU_in (only for setting LUI's 16)
   mux4 #(.WIDTH(32)) A_MUX (
      .d0(RD1_r), .d1(5'b10000), .d2(shamt), .d3(1'b0), .s(ASel), .y(A)
   );
   
      
   //(EXE) define Mux of B Port for ALU_in
   mux2 #(.WIDTH(32)) B_MUX (
      .d0(RD2_r), .d1(Imm32), .s(BSel), .y(B)
   );
   
   //(EXE) define ALU
   alu U_ALU ( 
      .A(A), .B(B), .ALUOp(ALUOp), .C(C), .Compare(Zero)
   );
   
   //(EXE) define Reg-Locker for ALU_Out
   flopr #(.WIDTH(32)) U_C_r (
      .clk(clk), .rst(rst), .d(C), .q(C_r)
   );
   
   //(MEM) define Data-to-Memory Saver (Save Data to Mem)
   //'be' defines store word/byte/H?, for all test instructions are in Word, I set it 4'b1111
   dm_4k U_DM ( 
      .addr(C_r[11:2]), .din(RD2_r), .be(4'b1111), .DMWr(DMWr), .clk(clk), .dout(dm_dout)
   );
   
   //(MEM) define Reg-Locker for Data Register (using DR_out as Data Register output)
   flopr #(.WIDTH(32)) U_DM_r (
      .clk(clk), .rst(rst), .d(dm_dout), .q(DR_out)
   );
   
   //(WB) define Mux of Write Data Port for Register File
   //PC(30) need to be left-shift 2 bits to extend to 32
   mux4 #(.WIDTH(32)) WD_MUX (
      .d0(C_r), .d1(DR_out), .d2({PC, 2'b00}), .d3(0), .s(WDSel), .y(WD)
   );
endmodule