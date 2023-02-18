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
	
entity SerialReceiver is

	port
	(
		Clock		: in	std_logic;
		nReset		: in	std_logic;
		BitTicks	: in	std_logic_vector(15 downto 0);
		Wire		: in	std_logic;
		Data		: out	std_logic_vector(7 downto 0);
		Recived		: out	std_logic;
		Busy		: out	std_logic
	);

end entity;

architecture RTL of SerialReceiver is

	type StateType	is (sIdle, sStartBit, sDataBits, sStopBit, sDone);

	signal State 		: StateType;
	signal ClockCount	: std_logic_vector(15 downto 0);
	signal BitCount		: integer range 0 to 15;
	
begin

	SM : process(Clock, nReset, State, BitTicks, ClockCount, BitCount, Wire) begin
	
		if not nReset then
		
			State 	<= sIdle;
		
		else
	
			if rising_edge(Clock) then
			
				case State is
				
					when sIdle =>
					
						State <= sIdle;
						Recived <= '0';
						Busy	<= '0';
						
						if not Wire then

							Busy		<= '1';
							BitCount	<= 0;
							ClockCount 	<= ("0" & BitTicks(15 downto 1)) - 1;
							State		<= sStartBit;
							
						end if;
						
						
					when sStartBit =>
				
						State 		<= sStartBit;
						ClockCount 	<= ClockCount - 1;
						
--						if ClockCount = 0 then
--						
--							if not Wire then
--							
--								ClockCount 	<= BitTicks - 1;
--								State		<= sDataBits;
--							
--							else
--							
--								State <= sIdle;
--							
--							end if;

						if ClockCount = 0 then
						
							ClockCount 	<= BitTicks - 1;
							State		<= sDataBits;
							
						else
							
							if Wire then
							
								State <= sIdle;
								
							end if;
								
						end if;
						
						
					when sDataBits =>
				
						State		<= SDataBits;
						ClockCount 	<= ClockCount - 1;

						if ClockCount = 0 then
						
							ClockCount 		<= BitTicks - 1;
							Data(BitCount)	<= Wire;
							
							if BitCount = 7 then
							
								ClockCount 	<= BitTicks - 1;
								State		<= sStopBit;
							
							else
								
								BitCount	<= BitCount + 1;
							
							end if;
													
						end if;
						
						
					when sStopBit =>
					
						State		<= sStopBit;
						ClockCount 	<= ClockCount - 1;

						if ClockCount = 0 then
						
							Recived	<= '1';
							State	<= sDone;
						
						end if;
						
						
					when sDone =>
					
						Recived	<= '0';
						Busy	<= '0';
						State	<= sIdle;
						
				
					when others =>
					
						State <= sIdle;
				
				end case;
			
			end if;
			
		end if;
	
	end process;


end architecture;