library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity countdown is 
	port(
		  clk 			 : in std_logic;
		  rst				 : in std_logic;
		  start_count   : in integer range 0 to 10;
		  --
		  count		 	 : out std_logic_vector(3 downto 0)
		  );
end entity countdown;


architecture behaviour of countdown is
	
	signal time_sig : integer range 0 to 10;
	
	begin 
	
	process(clk, rst)
	
	begin 
		
		if rst = '1' then 
		
			time_sig <= start_count;
			count    <= std_logic_vector(to_unsigned(start_count, 4));
			
		elsif rising_edge(clk) then 
		
			if time_sig > 0 then 
				time_sig <= time_sig - 1; 
			end if;
			
			count    <= std_logic_vector(to_unsigned(time_sig, 4));
		
		end if; 
		
	end process;

end behaviour;
			
		
		



