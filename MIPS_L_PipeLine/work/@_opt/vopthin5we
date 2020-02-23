library verilog;
use verilog.vl_types.all;
entity byPasser is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        WriteDst_EX_MEM : in     vl_logic_vector(4 downto 0);
        WriteDst_MEM_WB : in     vl_logic_vector(4 downto 0);
        rs_ID_EX_r      : in     vl_logic_vector(4 downto 0);
        rt_ID_EX_r      : in     vl_logic_vector(4 downto 0);
        MEM_ctrl_RegWr  : in     vl_logic;
        WB_ctrl_RegWr   : in     vl_logic;
        byPasserSelA    : out    vl_logic_vector(1 downto 0);
        byPasserSelB    : out    vl_logic_vector(1 downto 0)
    );
end byPasser;
