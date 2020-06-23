library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clock is 
	port(
		  clk		: in 	std_logic;
		  rst 	: in 	std_logic;
		  --
		  clk_out: out std_logic
		  );
end entity clock;


architecture behaviour of clock is

	-- prescaler (clockspeed/desired_clock_speed)/2 i.e. ((1/50,000,000)/1)/2
	signal prescaler 	: integer 	:= 25000000; --25000000;
	signal counter		: integer 	:= 0;
	signal state		: std_logic := '0';
	
	begin 
	
	process (clk, rst)
		begin 
		clk_out <= state;
		if rst = '1' then 
			-- zero counter and state 
			counter <= 0;
			state   <= '0';
		elsif rising_edge(clk) then
			-- incremenet counter each tick 
			counter <= counter + 1;
			-- update state if counter greater than prescaler 
			if (counter > prescaler) then
				counter <= 0;
				state <= (not state);
			end if;
		end if;
	end process;

end behaviour;
			
		