library ieee;
use ieee.std_logic_1164.all;

entity PC is
	port(d:            in std_logic_vector(15 downto 0);
	     clk,reset: in std_logic;
	     q:out std_logic_vector(15 downto 0));
end PC;

architecture behave of PC is
begin
	process(clk,reset)
	begin
		if reset = '0' then            
          q <= "0000000000000000";
        elsif clk'event and clk = '1' then
          
			q <= d;
		  
        end if;
	end process;
end behave;