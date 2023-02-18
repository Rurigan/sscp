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
	
entity SerialTransmitter is

	port
	(
		Clock		: in	std_logic;
		nReset		: in	std_logic;
		BitTicks	: in	std_logic_vector(15 downto 0);
		Data		: in	std_logic_vector(7 downto 0);
		Send		: in	std_logic;
		Wire		: out	std_logic;
		Busy		: out	std_logic;
		Done		: out	std_logic
	);
	
end entity;

architecture RTL of SerialTransmitter is

	type StateType	is (sInit, sFlush, sIdle, sStartBit, sSendData, sStop);

	signal State 		: StateType;
	signal ClockCount	: std_logic_vector(15 downto 0);
	signal BitCount		: integer range 0 to 15;
	
begin

	SM : process(Clock, nReset, BitTicks, Send, Data, State, ClockCount, BitCount) begin
	
		if not nReset then
		
			Wire	<= '1';
			Done	<= '0';
			Busy	<= '1';
			State	<= sInit;
		
		else
	
			if rising_edge(Clock) then
		
				case State is
				
					when sInit =>
				
						Wire		<= '1';
						Done		<= '0';
						Busy		<= '1';
						ClockCount 	<= BitTicks - 1;
						BitCount	<= 0;
						State		<= sFlush;
						
					when sFlush	=>
					
						State		<= sFlush;
						ClockCount 	<= ClockCount - 1;
						
						if ClockCount = 0 then
						
							BitCount 	<= BitCount + 1;
						
							if BitCount = 2 then
							
								State <= sIdle;
								
							else
							
								ClockCount 	<= BitTicks - 1;
							
							end if;
						
						end if;
						
			
					when sIdle =>

						State	<= sIdle;
						Wire	<= '1';
						Busy	<= '0';
						Done	<= '0';
								
						if Send then 

							Busy 		<= '1';
							Wire		<= '0';
							ClockCount 	<= BitTicks - 1;
							State		<= sStartBit;
			
						end if;
						
					when sStartBit => 
					
						State		<= sStartBit;
						ClockCount 	<= ClockCount - 1;

						if ClockCount = 0 then
						
							Bitcount	<= 0;
							ClockCount	<= BitTicks - 1;
							State		<= sSendData;
							
						end if;
						
					when sSendData => 
											
						State		<= sSendData;
						ClockCount	<= ClockCount - 1;
						Wire		<= Data(BitCount);
							
						if ClockCount = 0 then
						
							ClockCount 	<= BitTicks - 1;
							BitCount 	<= BitCount + 1;
							Wire		<= Data(BitCount);
							
							if BitCount = Data'length - 1 then
							
								State	<= sStop;
								
							end if;
							
						end if;
						
					when sStop => 
						
						State		<= sStop;
						ClockCount	<= ClockCount - 1;
						Wire	<= '1';
						
						if ClockCount = 0 then 
						
							Done	<= '1';
							State	<= sIdle;
						
						end if;
									
					when others =>
				
						State <= sInit;

				end case;
			
			end if;
			
		end if;
			
	
	end process;
	

end architecture;