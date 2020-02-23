library verilog;
use verilog.vl_types.all;
entity Reg_MEM_WB is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        MEM_instr       : in     vl_logic_vector(31 downto 0);
        MEM_WB_instr    : out    vl_logic_vector(31 downto 0);
        DataMem         : in     vl_logic_vector(31 downto 0);
        DataMem_MEM_WB_r: out    vl_logic_vector(31 downto 0);
        ALUOut          : in     vl_logic_vector(31 downto 0);
        ALUOut_MEM_WB_r : out    vl_logic_vector(31 downto 0);
        WriteDst        : in     vl_logic_vector(4 downto 0);
        WriteDst_MEM_WB_r: out    vl_logic_vector(4 downto 0);
        EX_MEM_PC_r     : in     vl_logic_vector(29 downto 0);
        MEM_WB_PC_r     : out    vl_logic_vector(29 downto 0)
    );
end Reg_MEM_WB;
