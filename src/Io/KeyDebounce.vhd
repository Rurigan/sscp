--
-- Copyright (c) 2023 Charlie Amtorp
--
-- Permission is hereby granted, free of charge, to any person
-- obtaining a copy of this software and associated documentation
-- files (the "Software"), to deal in the Software without
-- restriction, including without limitation the rights to use,
-- copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the
-- Software is furnished to do so, subject to the following
-- conditions:
--
-- The above copyright notice and this permission notice shall be
-- included in all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
-- OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-- NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
-- HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
-- WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
-- OTHER DEALINGS IN THE SOFTWARE.
--

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use ieee.std_logic_unsigned.all;

entity KeyDebounce is

	generic 
	(
		BTN_ACTIVE	: std_logic := '1';
		COUNT_MAX 	: positive	:= 40
	);

    port
	(   
		clock 		: in std_logic;
        nReset 		: in std_logic;
		button_in	: in std_logic		:= not BTN_ACTIVE;
		pulse_out 	: out std_logic
	);
		
end KeyDebounce;

architecture behav of KeyDebounce is

	signal count : std_logic_vector(11 downto 0);
	
	type state_type is (power_on, idle, wait_time); --state machine
	
	signal state : state_type := idle;

begin
  
	process(nReset, clock) begin
	
		if not nReset then		
			
			state 		<= power_on;
			count		<= (others => '0');
			pulse_out	<= not BTN_ACTIVE;
						
		elsif rising_edge(clock) then
		
			case state is
			
				when power_on =>
				
					if button_in = BTN_ACTIVE then
					
						pulse_out	<= BTN_ACTIVE;
						count 		<= std_logic_vector(to_unsigned(COUNT_MAX, count'length));
						state		<= wait_time;
						
					else
					
						state 		<= idle;
					
					end if;
				
			
				when idle =>
					
					if button_in = BTN_ACTIVE then  
					
						state <= wait_time;
						
					else
					
						state <= idle;
						
					end if;
					
					pulse_out 	<= not BTN_ACTIVE;
					count 		<= (others => '0');
					
				when wait_time =>
				
					if count = COUNT_MAX then
					
						if button_in = BTN_ACTIVE then
						
							pulse_out <= BTN_ACTIVE;
							
						else

							state <= idle; 

						end if;
												
					else
					
						count <= count + 1;
						
					end if; 
					
			end case;       
			
		end if;        
		
	end process;                  
                                                                                
end architecture behav;
