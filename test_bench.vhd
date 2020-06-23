library IEEE; 
use IEEE.std_logic_1164.all;

entity test_bench is
end entity test_bench;

architecture test of test_bench is
	
	-- signals 
	signal clk					: std_logic;
	signal rst					: std_logic;
	signal pad_row				: std_logic_vector(3 downto 0);
	--
	signal second				: std_logic;
	signal pad_key2		 	: std_logic_vector(3 downto 0);
	--
	signal pad_pwr				: std_logic_vector(3 downto 0);
	--
	signal disp_countdown	: std_logic_vector(6 downto 0);
	signal disp_score			: std_logic_vector(6 downto 0);
	signal disp_lives			: std_logic_vector(6 downto 0);
	signal disp_level			: std_logic_vector(6 downto 0);
	signal disp_number		: std_logic_vector(6 downto 0);

	begin
		
		UUT: entity work.number_whack port map(clk, rst, pad_row, second, pad_key2, pad_pwr, 
															disp_countdown, disp_score, 
															disp_lives, disp_level, disp_number);

		-- 50Hz Clock 
		process 
		begin 
			clk <= '1';
			wait for 10ns;
			clk <= '0';
			wait for 10ns;
		end process;
		
		-- Button press
		process 
		begin 
			wait for 100ns;
			pad_row <= "1000";
			wait for 100ns;
			pad_row <= "0100";
		end process; 
		
end architecture;
		

--process 
--begin 
--A <= '0'
--wait for 10ns;
--A <= '1'
--end process ;
--






--process(Reset, Clock)
--begin
--if Reset = ‘1’ then
--Q <= ‘0’;
--QB <= ‘0’;
--elsif Rising_edge(Clock) then
--Q1 <= D;
--QB <= not D;
--end if;
--end process;
