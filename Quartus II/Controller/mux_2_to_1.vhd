library ieee;
use ieee.std_logic_1164.all;

entity mux_2_to_1 is
port (
	input0,
	input1: 	in std_logic_vector(15 downto 0);
	sel: 		in	std_logic;
	out_put: 	out std_logic_vector(15 downto 0));
end mux_2_to_1;

architecture behav of mux_2_to_1 is
begin
mux: process(sel, input0, input1)
begin
	case sel is 
		when '0' => 
			out_put <= input0;
		when '1' => 
			out_put <= input1;
		end case;
end process;
end behav;
