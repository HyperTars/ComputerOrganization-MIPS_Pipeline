 module mips_tb();
    
   reg clk, rst;
    
   mips U_MIPS(
      .clk(clk), .rst(rst)
   );
    
   initial begin
      $readmemh( "code.txt" , U_MIPS.U_IM.imem ) ;
      //$monitor("PC = 0x%8X, IR = 0x%8X, ", U_MIPS.U_PC.PC, U_MIPS.im_dout, U_MIPS.ID_instr, U_MIPS.EX_instr, U_MIPS.MEM_instr, U_MIPS.WB_instr ); 
	  $monitor("PC = 0x%8X, IF_instr = 0x%8X, ID_instr = 0x%8X, EX_instr = 0x%8X, MEM_instr = 0x%8X, WB_instr = 0x%8X", 
		  U_MIPS.U_PC.PC, U_MIPS.im_dout, U_MIPS.ID_instr, U_MIPS.EX_instr, U_MIPS.MEM_instr, U_MIPS.WB_instr );
      clk = 1 ;
      rst = 0 ;
      #5 ;
      rst = 1 ;
      #20 ;
      rst = 0 ;
   end
   
   always
	   #(50) clk = ~clk;
   
endmodule
