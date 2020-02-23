library verilog;
use verilog.vl_types.all;
entity Reg_EX_MEM is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        EX_instr        : in     vl_logic_vector(31 downto 0);
        EX_MEM_instr    : out    vl_logic_vector(31 downto 0);
        ALUOut          : in     vl_logic_vector(31 downto 0);
        ALUSource_B     : in     vl_logic_vector(31 downto 0);
        WriteDst        : in     vl_logic_vector(4 downto 0);
        ALUOut_EX_MEM_r : out    vl_logic_vector(31 downto 0);
        ALUSource_B_EX_MEM_r: out    vl_logic_vector(31 downto 0);
        WriteDst_EX_MEM_r: out    vl_logic_vector(4 downto 0);
        B_Reg           : in     vl_logic_vector(31 downto 0);
        B_Reg_r         : out    vl_logic_vector(31 downto 0);
        ID_EX_PC_r      : in     vl_logic_vector(29 downto 0);
        EX_MEM_PC_r     : out    vl_logic_vector(29 downto 0)
    );
end Reg_EX_MEM;
