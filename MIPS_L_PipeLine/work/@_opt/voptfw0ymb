library verilog;
use verilog.vl_types.all;
entity ctrl is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        instr           : in     vl_logic_vector(31 downto 0);
        step            : in     vl_logic_vector(1 downto 0);
        EXTOp           : out    vl_logic_vector(1 downto 0);
        brSignal        : out    vl_logic;
        jmpSignal       : out    vl_logic;
        jmpRSignal      : out    vl_logic;
        control_EX_MemRead: out    vl_logic;
        ASel            : out    vl_logic_vector(1 downto 0);
        BSel            : out    vl_logic;
        ALUOp           : out    vl_logic_vector(4 downto 0);
        WriteDstSel     : out    vl_logic;
        EX_ctrl_regWr   : out    vl_logic;
        MEM_ctrl_regWr  : out    vl_logic;
        be              : out    vl_logic_vector(1 downto 0);
        DMWr            : out    vl_logic;
        WB_ctrl_regWr   : out    vl_logic;
        WriteContentSel : out    vl_logic_vector(1 downto 0);
        WriteDstRegSel  : out    vl_logic
    );
end ctrl;
