`include "flopr.v"
module Reg_ID_EX ( clk, rst, stallSignal, 
	ID_instr_r, ID_EX_instr,
	RD1, RD2, ImmExt,
	RD1_ID_EX_r, RD2_ID_EX_r, ImmExt_r,
	brSignal, brSignal_r,
	IF_ID_PC_r, ID_EX_PC_r
	);

	input clk, rst;
	input	[31:0]	ID_instr_r;
	input	[31:0]	RD1;
	input	[31:0]	RD2;
	input	[31:0]	ImmExt;
	input			brSignal;
	input   stallSignal;
	input	[29:0]	IF_ID_PC_r;
	
	output	[31:0]	ID_EX_instr;
	output	[31:0]	RD1_ID_EX_r;
	output	[31:0]	RD2_ID_EX_r;
	output	[31:0]	ImmExt_r;
	output			brSignal_r;
	output	[29:0]	ID_EX_PC_r;

  reg [31:0]  reg_ID_instr_r;
  reg [31:0]  reg_RD1;
  reg [31:0]  reg_RD2;
  reg [31:0]  reg_ImmExt;
  reg [31:0]  reg_brSignal;
  
  wire  [31:0]  wire_ID_instr_r;
  wire  [31:0]  wire_RD1;
  wire  [31:0]  wire_RD2;
  wire  [31:0]  wire_ImmExt;
  wire  [31:0]  wire_brSignal;
  
  always @(*) begin
    reg_ID_instr_r = ID_instr_r;
    reg_RD1 = RD1;
    reg_RD2 = RD2;
    reg_ImmExt = ImmExt;
    reg_brSignal = brSignal;
	//New: jmpSignal & jmpRSignal
    if (stallSignal || brSignal_r)
      begin
        reg_ID_instr_r = 0;
        reg_RD1 = 0;
        reg_RD2 = 0;
        reg_ImmExt = 0;
        reg_brSignal = 0;
      end
    end
    
  assign wire_ID_instr_r = reg_ID_instr_r;
  assign wire_RD1 = reg_RD1;
  assign wire_RD2 = reg_RD2;
  assign wire_ImmExt = ImmExt;
  assign wire_brSignal = brSignal;
  
	flopr #(.WIDTH(32)) instr_r(
		.clk(clk), .rst(rst), .d(wire_ID_instr_r), .q(ID_EX_instr)
	);

	flopr #(.WIDTH(32)) RD1_r (
		.clk(clk), .rst(rst), .d(wire_RD1), .q(RD1_ID_EX_r)
	);

	flopr #(.WIDTH(32)) RD2_r (
		.clk(clk), .rst(rst), .d(wire_RD2), .q(RD2_ID_EX_r)
	);

	flopr #(.WIDTH(32)) SignExtImm_r (
		.clk(clk), .rst(rst), .d(wire_ImmExt), .q(ImmExt_r)
	);

	flopr #(.WIDTH(1)) brSignal_reg (
		.clk(clk), .rst(rst), .d(wire_brSignal), .q(brSignal_r)
	);

	flopr #(.WIDTH(30)) PC_reg (
		.clk(clk), .rst(rst), .d(IF_ID_PC_r), .q(ID_EX_PC_r)
	);


endmodule
