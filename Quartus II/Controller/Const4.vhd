library ieee;
use ieee.std_logic_1164.all;

entity Const4 is
	port(
	     clk: 	in std_logic;
	     q:			out std_logic_vector(15 downto 0));
end Const4;

architecture behave of Const4 is
begin
	process(clk)
	begin
		if clk'event and clk = '1' then            
          q <= "0000000000000010";
        
        end if;
	end process;
end behave;