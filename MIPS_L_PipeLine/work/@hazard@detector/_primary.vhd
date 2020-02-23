library verilog;
use verilog.vl_types.all;
entity HazardDetector is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        rs_ID           : in     vl_logic_vector(4 downto 0);
        rt_ID           : in     vl_logic_vector(4 downto 0);
        MemRead_EX      : in     vl_logic;
        WriteDst_EX     : in     vl_logic_vector(4 downto 0);
        PC_Write        : out    vl_logic;
        Reg_ID_EX_Control_Mux: out    vl_logic;
        brSignal        : in     vl_logic;
        EX_ctrl_regWr   : in     vl_logic;
        stallSignal     : out    vl_logic
    );
end HazardDetector;
