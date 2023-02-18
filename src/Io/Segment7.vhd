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

use work.CoreTypes.all;

entity Segment7 is

	--
	-- Drives 7 segment display
	--
	-- offset   bits   	rd/wr  
	-- ------	-----	----- 
	-- 0      	3-0		WR		: 4 bit hexadecimal value converetd to hex digit on segment display
	--			4		WR		: high to enable segment
	--
	
	generic
	(
		PortAddr	: IoAddr;
		PortDef		: DataWord	:= x"80"	
	);
	
	port
	(
		SysCtrl		: in 	SystemCtrlRec;
		FromCpu		: in	IoCtrlRec;
		ToSegment	: out 	std_logic_vector(6 downto 0)
	);

end entity;

architecture RTL of Segment7 is

	signal Hit		: std_logic;
	signal Reg		: DataWord;
	
begin
	Hit	<= '1' when FromCpu.Addr = PortAddr and FromCpu.WR = '1' else '0';

	ToSegment	<=  "1111111" when Reg(7) = '1'
					else "1000000" when Reg(3 downto 0) = "0000"
					else "1111001" when Reg(3 downto 0) = "0001"
					else "0100100" when Reg(3 downto 0) = "0010"
					else "0110000" when Reg(3 downto 0) = "0011"
					else "0011001" when Reg(3 downto 0) = "0100"
					else "0010010" when Reg(3 downto 0) = "0101"
					else "0000010" when Reg(3 downto 0) = "0110"
					else "1111000" when Reg(3 downto 0) = "0111"
					else "0000000" when Reg(3 downto 0) = "1000"
					else "0011000" when Reg(3 downto 0) = "1001"
					else "0001000" when Reg(3 downto 0) = "1010"
					else "0000011" when Reg(3 downto 0) = "1011"
					else "1000110" when Reg(3 downto 0) = "1100"
					else "0100001" when Reg(3 downto 0) = "1101"
					else "0000110" when Reg(3 downto 0) = "1110"
					else "0001110";
				
				
	store : process(SysCtrl, Hit) begin
	
		if not SYsCtrl.nReset then
		
			Reg <= PortDef;
		
		else
		
			if rising_edge(SysCtrl.Clock) then
			
				if Hit then
				
					if FromCpu.BOP then
					
						Reg(to_integer(unsigned("0" & FromCpu.BitAddr))) <= FromCpu.BitData;
					
					else
					
						Reg <= FromCpu.Data;
					
					end if;
			
				end if;
			
			end if;
		
		end if;
	
	end process;

end architecture;