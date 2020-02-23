library verilog;
use verilog.vl_types.all;
entity Reg_IF_ID is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        PC              : in     vl_logic_vector(29 downto 0);
        instr           : in     vl_logic_vector(31 downto 0);
        stallSignal     : in     vl_logic;
        brSignal        : in     vl_logic;
        jmpSignal       : in     vl_logic;
        jmpRSignal      : in     vl_logic;
        instr_IF_ID_r   : out    vl_logic_vector(31 downto 0);
        IF_ID_PC_r      : out    vl_logic_vector(29 downto 0)
    );
end Reg_IF_ID;
