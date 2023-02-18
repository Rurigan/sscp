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

entity IntControl is

	port
	(
		SysCtrl			: in 		SystemCtrlRec;
		Cycle			: in		CycleOutRec;
		NewInstr		: in		std_logic;
		IntReq			: in		std_logic;
		IntAllowed		: in		std_logic;
		IntAck			: buffer	std_logic;		
		InInt			: buffer	std_logic
	);

end entity;

architecture RTL of IntControl is
begin

	IntAck	<= (Cycle.c3 and InInt);

	process(SysCtrl, IntReq, IntAck) begin
		
		if not SysCtrl.nReset then
		
			InInt	<= '0';
		
		else
		
			if rising_edge(SysCtrl.Clock) then
		
				if InInt then
				
					if Cycle.c3 then
				
						InInt	<= '0';
						
					end if;
					
				else
		
					if NewInstr and IntReq and IntAllowed then
				
						InInt	<= '1';
						
					end if;
				
				end if;
				
			end if;
		
		end if;
		
	end process;
	

end architecture;
