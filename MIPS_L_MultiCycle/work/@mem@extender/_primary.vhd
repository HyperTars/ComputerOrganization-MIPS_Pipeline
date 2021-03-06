library verilog;
use verilog.vl_types.all;
entity MemExtender is
    port(
        ALUOut          : in     vl_logic_vector(1 downto 0);
        op              : in     vl_logic_vector(2 downto 0);
        din             : in     vl_logic_vector(31 downto 0);
        dout            : out    vl_logic_vector(31 downto 0)
    );
end MemExtender;
