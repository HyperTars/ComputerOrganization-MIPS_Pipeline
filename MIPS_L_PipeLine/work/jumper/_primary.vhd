library verilog;
use verilog.vl_types.all;
entity jumper is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        Op              : in     vl_logic_vector(5 downto 0);
        Funct           : in     vl_logic_vector(5 downto 0);
        InstrAddr       : in     vl_logic_vector(25 downto 0);
        PC              : in     vl_logic_vector(31 downto 0);
        jmpSign         : out    vl_logic
    );
end jumper;
