library verilog;
use verilog.vl_types.all;
entity brancher is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        Op              : in     vl_logic_vector(5 downto 0);
        rs              : in     vl_logic_vector(4 downto 0);
        rt              : in     vl_logic_vector(4 downto 0);
        Imm             : in     vl_logic_vector(15 downto 0);
        brSignal        : out    vl_logic;
        WriteDst_EX     : in     vl_logic_vector(4 downto 0);
        WriteDst_MEM    : in     vl_logic_vector(4 downto 0);
        RD1             : in     vl_logic_vector(31 downto 0);
        RD2             : in     vl_logic_vector(31 downto 0);
        ALUOut_C        : in     vl_logic_vector(31 downto 0);
        dm_dout         : in     vl_logic_vector(31 downto 0);
        EX_ctrl_RegWr   : in     vl_logic;
        MEM_ctrl_RegWr  : in     vl_logic
    );
end brancher;
