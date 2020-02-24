library ieee;
use ieee.std_logic_1164.all;

entity COUNTER is 
  port(clk:in std_logic;
		rs:in std_logic;
		count_out:out std_logic_vector(2 downto 0)
      );
end COUNTER;

architecture behav of COUNTER is 
	signal next_counter:std_logic_vector(2 downto 0);
	begin 
		process(rs,clk)
			begin
				if rs='0' then next_counter<="000";
				elsif(clk'event and clk='1') then 
					case next_counter is 
						when "000"=>next_counter<="001";
						when "001"=>next_counter<="011";
						when "011"=>next_counter<="111";
						when "111"=>next_counter<="110";
						when "110"=>next_counter<="100";
						when "100"=>next_counter<="000";
						when others=>next_counter<="XXX";
					end case;
				end if;
				count_out<=next_counter;
				end process;
			end behav;