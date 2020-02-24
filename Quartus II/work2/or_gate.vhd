library ieee;
use ieee.std_logic_1164.all;

entity or_gate is
	port(a1,a2: in std_logic;
	b1: out std_logic
	);
end or_gate;

architecture behav of or_gate is 
	begin
		b1<=a1 or a2;
end behav;