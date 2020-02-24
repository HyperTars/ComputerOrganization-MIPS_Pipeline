library ieee;
use ieee.std_logic_1164.all;

entity and_gate is
	port(a1,a2: in std_logic;
	b1:out std_logic
	);
end and_gate;

architecture behav of and_gate is
	begin
		b1 <= a1 and a2;
end behav;