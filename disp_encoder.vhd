library IEEE;
use IEEE.std_logic_1164.all;

entity disp_encoder is 
	port(
		  binary_num	: in 	std_logic_vector(3 downto 0);
		  --
		  disp_code		: out std_logic_vector(6 downto 0)
		  );
end entity disp_encoder;


architecture dataflow of disp_encoder is
	
	begin 
	
	disp_code <= "1000000" when binary_num = "0000" else
					 "1111001" when binary_num = "0001" else
					 "0100100" when binary_num = "0010" else
					 "0110000" when binary_num = "0011" else
					 "0011001" when binary_num = "0100" else
					 "0010010" when binary_num = "0101" else
					 "0000010" when binary_num = "0110" else
					 "1111000" when binary_num = "0111" else
					 "0000000" when binary_num = "1000" else
					 "0011000" when binary_num = "1001" else
					 "0111111";

end architecture dataflow;
			
		