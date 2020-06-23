library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity keypad is 
	port(
		  clk				: in  std_logic;
		  pad_row		: in  std_logic_vector(3 downto 0);
		  --
		  pad_pwr		: out std_logic_vector(3 downto 0);
		  pad_key	   : out std_logic_vector(3 downto 0)
		  );
end entity keypad;


architecture behaviour of keypad is
	
	signal pad_col  	 : std_logic_vector(3 downto 0) := "0111";
	signal pad_col_nxt : std_logic_vector(3 downto 0) := "0111";
	signal key_sig		 : std_logic_vector(3 downto 0) := "1111";
	signal engaged 	 : std_logic;
	signal hold			 : std_logic;
	
	begin 
	
	process(clk, pad_row)	
		
		variable v_pad_col : std_logic_vector(3 downto 0) := pad_col;	
		
		begin 
		
		if rising_edge(clk) and engaged /= '1' then 
		
		engaged <= '1';
		
		-- power pad ---------------------------
		
		if pad_row = "1111" then 
		
			case v_pad_col is
				when "0111" =>
					pad_col <= "1101";
				when "1101" =>
					pad_col <= "1011";
				when "1011" =>
					pad_col <= "0111";
				when others =>
					null;
			end case;
			
		end if;
		
		pad_pwr <= pad_col;
		
		-- read in button press ---------------------------
		
		if 	pad_col = "1101" then -- 0111
			if    pad_row = "0111" then 
					key_sig 	<= "0001";
			elsif pad_row = "1011" then 
					key_sig  <= "0100";
			elsif pad_row = "1101" then 
					key_sig  <= "0111";
			end if;

		elsif pad_col = "0111" then 
			if    pad_row = "0111" then 
					key_sig 	<= "0010";
			elsif pad_row = "1011" then 
					key_sig  <= "0101";
			elsif pad_row = "1101" then 
					key_sig  <= "1000";
			elsif pad_row = "1110" then
					key_sig  <= "0000";
			end if;
			
		elsif pad_col = "1011" then 
			if    pad_row = "0111" then 
					key_sig 	<= "0011";
			elsif pad_row = "1011" then 
					key_sig  <= "0110";
			elsif pad_row = "1101" then 
					key_sig  <= "1001";
			end if;
		end if;
		
		if (key_sig /= "1111" and key_sig /= "1111") then 
			pad_key	<= key_sig;	
		end if;
		
		---------------------------------------------------
		
		engaged <= '0';
	
		end if;
		
	end process;

end behaviour;
			
		
		