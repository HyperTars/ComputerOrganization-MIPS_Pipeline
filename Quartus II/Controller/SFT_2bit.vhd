

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY SFT_2bit IS
	PORT (
	       data_in   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  --���������
	       data_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)  --��λ�Ľ��
	     );
END SFT_2bit;
	     
ARCHITECTURE behav of SFT_2bit IS
  BEGIN
    PROCESS (data_in)  
           
      BEGIN
       data_out <= data_in(13 DOWNTO 0) & '0' & '0';   
        
      END PROCESS;
  END behav;      
            