library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ADD is
port(alu_a,
     alu_b:in std_logic_vector(15 downto 0);
     alu_out:out std_logic_vector(15 downto 0));
 end ADD;

architecture behave of ADD is
begin
	process(alu_a,alu_b)
	variable temp1,temp2 : std_logic_vector(15 downto 0) ;
	begin
		temp1 := alu_b+alu_a;
		alu_out <= temp1;
		
	end process;
end behave;