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

entity Cycler is

	port
	(
		SysCtrl		: in 		SystemCtrlRec;
		NewInstr	: in 		std_logic;
		CycleRec	: out	 	CycleOutRec
	);
	
end entity;

architecture RTL of Cycler is

	signal Count		: std_logic_vector(2 downto 0);

begin
	CycleRec.Count	<= Count;
	CycleRec.c0 	<= '1' when std_match(Count, "000") else '0';
	CycleRec.c1 	<= '1' when std_match(Count, "001") else '0';
	CycleRec.c2 	<= '1' when std_match(Count, "010") else '0';
	CycleRec.c3 	<= '1' when std_match(Count, "011") else '0';
	CycleRec.c4 	<= '1' when std_match(Count, "100") else '0';	

	process(SysCtrl) begin
	
		if not SysCtrl.nReset then
		
			Count <= (others => '0');
		
		else
		
			if rising_edge(SysCtrl.Clock) then
			
				if NewInstr then
				
					Count <= (others => '0');
					
				else
				
					Count <= Count + 1;
					
				end if;			
			
			end if;
		
		end if;
	
	end process;

end architecture;

