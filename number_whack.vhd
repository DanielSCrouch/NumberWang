-- 6CCS3HAD
-- Author: Daniel Stuart Crouch 
-- K-number: k1763455
-- Date: 04/04/2020

library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity number_whack is 
	port (
	 		clk				: in std_logic;
			rst				: in std_logic;
			pad_row			: in std_logic_vector(3 downto 0);
			--
			second			: out std_logic;
			pad_key_show   : out std_logic_vector(3 downto 0) := "1111";
			--
			pad_pwr			: out std_logic_vector(3 downto 0);
			disp_countdown	: out std_logic_vector(6 downto 0);
			disp_score		: out std_logic_vector(6 downto 0);
			disp_lives		: out std_logic_vector(6 downto 0);
			disp_level		: out std_logic_vector(6 downto 0);
			disp_number		: out std_logic_vector(6 downto 0);
			disp_key			: out std_logic_vector(6 downto 0)
			);
end entity number_whack;


architecture behaviour of number_whack is

	-- components -----------------------------------------
	
	component clock
		port( 
			  clk				: in std_logic;
			  rst				: in std_logic;
			  --
			  clk_out		: out std_logic
			  );
	end component;
	
	component disp_encoder
		port(
			  binary_num	: in 	std_logic_vector(3 downto 0);
			  --
			  disp_code		: out std_logic_vector(6 downto 0)
			  );
	end component;
	
	component keypad
		port(
			  clk				: in  std_logic;
			  pad_row		: in  std_logic_vector(3 downto 0);
		     --
		     pad_pwr		: out std_logic_vector(3 downto 0);
		     pad_key	   : out std_logic_vector(3 downto 0)
		     );
	end component;
	
	component generator
		port(
			  clk				: in  std_logic;
		     --
		     number			: out std_logic_vector(3 downto 0)
		     );
	end component;
	
	component countdown
		port(
			  clk 			 : in std_logic;
			  rst				 : in std_logic;
			  start_count   : in integer range 0 to 10;
			  --
			  count		 	 : out std_logic_vector(3 downto 0)
		     );
	end component;
	
	-- signals -------------------------------------------- 
	
	signal clk_out			: std_logic;
	signal csecond			: std_logic := '0'; -- LED seconds tick 
	signal pad_rst			: std_logic := '0';
	signal pad_out 		: std_logic_vector(3 downto 0);
	signal pad_key		 	: std_logic_vector(3 downto 0);
	signal number		 	: std_logic_vector(3 downto 0);
	signal fib_number		: std_logic_vector(3 downto 0);
	--
	signal count_rst     : std_logic;
	signal count_sta     : integer range 0 to 10 := 9;
	signal count    		: std_logic_vector(3 downto 0) := "1001";
	--
	signal score 			: integer range 0 to 5  := 0;
	signal lives			: integer range 0 to 3  := 3;
	signal level			: integer range 0 to 9  := 0;
	--
	signal engaged 		: std_logic;
	signal p_pad_key     : std_logic_vector(3 downto 0);
	
	
	-- behaviour ------------------------------------------
	
	begin 
		
		-- clock -------------------------------------------
		
		C1: clock port map (clk, rst, clk_out);
		process(clk_out)
			begin 
			if rising_edge(clk_out) then 
				second 	<= csecond; -- second can't be read directly 
				csecond 	<= not csecond;
			end if;
		end process; 
		
		-- keypad ------------------------------------------
		
		K1: keypad port map (clk, pad_row, pad_pwr, pad_key);		
		D1: disp_encoder port map (pad_key, disp_key);
--		process(pad_key)
--			begin 
--				pad_key_show <= pad_key;
--		end process;

		-- generator ---------------------------------------
		
		K2: generator port map (clk_out, number);		
		D2: disp_encoder port map (fib_number, disp_number);
		
		-- countdown ---------------------------------------
		
		K3: countdown port map (clk_out, count_rst, count_sta, count);		
		D3: disp_encoder port map (count, disp_countdown);
		
		
		-- display -----------------------------------------
		
		D4: disp_encoder port map (std_logic_vector(to_unsigned(score, 4)), disp_score);
		D5: disp_encoder port map (std_logic_vector(to_unsigned(lives, 4)), disp_lives);
		D6: disp_encoder port map (std_logic_vector(to_unsigned(level, 4)), disp_level);

		-- game logic --------------------------------------
		
		process(clk)
		
			variable v_score : integer range 10 downto 0 := score; 
			variable v_lives : integer range 10 downto 0 := lives; 
			variable v_level : integer range 10 downto 0 := level; 
			
			begin 
			
			if rising_edge(clk) and engaged /= '1' then
			
			-- check thread --------------------------
			
			engaged <= '1';
			
			-- check reset ---------------------------
			
			if rst = '1' then
			
				count_sta <= 9; 
				count_rst <= '1';
				v_score      := 0;
				v_lives		 := 3;
				v_level		 := 0;
				--
				fib_number <= number;
			
			-- check game state ----------------------
			
			elsif rst = '0' then 
								
				-- count down -------------------------
				
				count_rst <= '0';
				
				if count = "0000" and lives > 0 then 
					count_rst <= '1';
					v_lives := v_lives - 1; 
				end if; 
				
				-- check new button press  ------------
				
				if pad_key /= p_pad_key then  
					p_pad_key <= pad_key;
				
					if pad_key = fib_number then 
						v_score := v_score + 1;
						fib_number <= number;
						
						-- level  -----------------------
						
						if v_score = 6 then 
						
							v_level := v_level + 1;
							v_score := 0;
							count_sta <= count_sta - 1;
							count_rst <= '1';
						
						end if;
					
					-- wrong button --------------------
						
					else
						v_lives := v_lives - 1; 
					end if; 
				
				elsif pad_key = fib_number then
					fib_number <= number; 
				
				end if; 						
				
				-- game over  -------------------
				
				if v_lives = 0 then 

					count_sta <= 9; 
					count_rst <= '1';
					v_score   := 0;
					v_lives	 := 3;
					v_level	 := 0;
					
				end if; 
				
			
			end if;
			
			------------------------------------------
			
			engaged <= '0';
			
			end if; 
			
			score <= transport v_score after 10ns; 
			lives <= transport v_lives after 10ns; 
			level <= transport v_level after 10ns; 
				
		end process; 
		
end behaviour;
		
		
		
	
		
	
			
	