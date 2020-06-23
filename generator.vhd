library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity generator is 
	port(
		  clk				: in  std_logic;
		  --
		  number			: out std_logic_vector(3 downto 0)
		  );
end entity generator;


architecture behaviour of generator is
	
	signal a : integer range 0 to 20 := 0;
	signal b : integer range 0 to 20 := 1;
	
	begin 
	
	process(clk)
	
	variable c : integer range 0 to 20;
	
	begin
	
		if rising_edge(clk) then
			if b > 9 then 
				a <= 0; 
				b <= 1;
				number <= std_logic_vector(to_unsigned(0, 4)); 
			else 
				c := b + a;
				a <= b;
				b <= c;			
				number <= std_logic_vector(to_unsigned(b, 4)); 
			end if; 
			
		end if; 
	
	end process; 

end behaviour;
			
		
		



