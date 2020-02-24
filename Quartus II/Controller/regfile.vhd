
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity regfile is
Port (  RD_Address1: 		in std_logic_vector(1 downto 0); 
		RD_Address2: 		in std_logic_vector(1 downto 0);  
		WR_Address:         in std_logic_vector(1 downto 0);
		WR_DATA: 	in  std_logic_vector(15 downto 0);
		Reg_Wr:   	in std_logic;                           
		clk: 		in std_logic;
		reset:  	in std_logic;	
		RD_DATA1:	out std_logic_vector(15 downto 0);        
		RD_DATA2:  	out std_logic_vector(15 downto 0)   
	  );
end regfile;


architecture struct of regfile is
-- components
-- 16 bit Register for register file
component reg
port	(
		clr: 	in	std_logic;
		D: 		in	std_logic_vector(15 downto 0);
		clock: 	in	std_logic;
		write:  in	std_logic;
	    sel: 	in	std_logic;
		Q: 		out std_logic_vector(15 downto 0)
		);
end component;

-- 2 to 4 Decoder
component  decoder_2_to_4 
    port(
		sel: 	in  std_logic_vector(1 downto 0);
		sel00: 	out std_logic;
		sel01: 	out std_logic;
		sel02: 	out std_logic;
		sel03: 	out std_logic
		);
end component;

-- 4 to 1 line multiplexer
component mux_4_to_1
port (
	input0,
	input1,
	input2,
	input3:  in std_logic_vector(15 downto 0);
	sel:	 in std_logic_vector(1 downto 0);
	out_put: out std_logic_vector(15 downto 0));
end component;


signal reg00, reg01, reg02, reg03 
            :std_logic_vector(15 downto 0);
 
signal sel00 ,sel01 ,sel02 ,sel03
            : std_logic;

begin
Areg00: reg port map(
		clr			=>  reset,
		D			=>	WR_DATA ,
		clock		=>	clk ,		
		write		=>	Reg_Wr ,
	    sel			=>	sel00 ,	
		Q			=>  reg00
		);

Areg01: reg port map(
		clr			=>  reset,
		D			=>	WR_DATA ,
		clock		=>	clk ,		
		write		=>	Reg_Wr ,
	    sel			=>	sel01 ,	
		Q			=>  reg01	
		);

Areg02: reg port map(
		clr			=>  reset,
		D			=>  WR_DATA ,
		clock		=>	clk ,		
		write		=>	Reg_Wr ,
	    sel			=>	sel02 ,	
		Q			=>  reg02
		);

Areg03: reg port map(
		clr			=>  reset,
		D			=>	WR_DATA ,
		clock		=>	clk ,		
		write		=>	Reg_Wr ,
	    sel			=>	sel03 ,	
		Q			=>  reg03
		);

-- decoder
des_decoder: decoder_2_to_4 port map
		(
		sel 	=> WR_Address,
    	sel00 	=> sel00 ,
		sel01 	=> sel01 ,
		sel02 	=> sel02 ,
		sel03 	=> sel03 
		);

mux1: mux_4_to_1 PORT MAP(
	Input0 => reg00 ,
    Input1 => reg01 ,
	Input2 => reg02 ,
	Input3 => reg03 ,
	sel => RD_Address1,
	out_put => RD_data1
	);
	
mux2: mux_4_to_1 PORT MAP(
	input0 	=> reg00 ,
    input1 	=> reg01 ,
	input2 	=> reg02 ,
	input3 	=> reg03 ,
	sel 	=> RD_Address2 ,
	out_put => RD_data2
	);
	

end struct;