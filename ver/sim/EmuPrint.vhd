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

library std;
use std.textio.all;

use work.CoreTypes.all;

entity EmuPrint is

	generic
	(
		PORT_ADDR	: unsigned(IoAddrWidth - 1 downto 0)	 
	);

	port
	(
		SysCtrl			: in	SystemCtrlRec;
		IoCtrl			: in	IoCtrlRec;
		IoOut			: out	InOutRec
	);

end;

architecture RTL of EmuPrint is

	signal Hit		: std_logic;

begin

	Hit	<= '1' when IoCtrl.Addr = std_logic_vector(PORT_ADDR) else '0';

	IoOut.Data		<= (others => '0');
	IoOut.BitData	<= '0';
	IoOut.IntReq	<= '0';
	IoOut.IntVect	<= (others => '0');
	 
	process(SysCtrl) 
	
		variable ln			: line;
		file 	 textout 	: text open write_mode is "output.txt";
	
	begin
	
		if rising_edge(SysCtrl.Clock) then
		
			if Hit and IoCtrl.WR then
			
				if character'val(to_integer(unsigned(IoCtrl.Data))) = LF then
			
					writeline(textout, ln);
			
				else
				
					write(ln, character'val(to_integer(unsigned(IoCtrl.Data))));			
				
				end if;
			
			end if;
		
		end if;
	
	end process;
	 
end;