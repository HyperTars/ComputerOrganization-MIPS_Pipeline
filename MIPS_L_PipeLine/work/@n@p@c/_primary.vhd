library verilog;
use verilog.vl_types.all;
entity NPC is
    port(
        PC              : in     vl_logic_vector(31 downto 2);
        jmpReg          : in     vl_logic_vector(31 downto 0);
        Imm             : in     vl_logic_vector(25 downto 0);
        PC_r            : in     vl_logic_vector(29 downto 0);
        jmpSignal       : in     vl_logic;
        brSignal        : in     vl_logic;
        jmpRSignal      : in     vl_logic;
        stallSignal     : in     vl_logic;
        brSignal_r      : in     vl_logic;
        NPC             : out    vl_logic_vector(31 downto 2)
    );
end NPC;
