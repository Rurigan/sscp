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

entity Io is

	generic
	(
		PRINT_PORT		: positive := 15;
		TEST_PORT		: positive := 11;
		TRIGGER_PORT	: positive := 14;
		TRIGGER_VECT	: positive := 4
	);

	port
	(
		SysCtrl			: in	SystemCtrlRec;
		IoCtrl			: in	IoCtrlRec;
		IoOut			: out	InOutRec
	);

end entity;

architecture RTL of Io is


	signal PrtOut		: InOutRec;
	signal TestOut		: InOutRec;
	signal TriggerOut	: InOutRec;

begin

	din : for i in 0 to 7 generate
	
		IoOut.Data(i) <=  PrtOut.Data(i) or TestOut.Data(i) or TriggerOut.Data(i);
	
	end generate;
	
	IoOut.BitData	<= PrtOut.BitData or TestOut.BitData or TriggerOut.BitData;
	
	IoOut.IntReq	<= TriggerOut.IntReq;
	IoOut.IntVect	<= TriggerOut.IntVect;

	PRT : entity work.EmuPrint

		generic map
		(
			PORT_ADDR	=>	to_unsigned(PRINT_PORT, IoAddrWidth)
		)

		port map
		(
			SysCtrl		=>	SysCtrl,
			IoCtrl		=>	IoCtrl,
			IoOut		=>	PrtOut
		);

		
	TEST : entity work.EmuTest

		generic map
		(
			PORT_ADDR	=>	to_unsigned(TEST_PORT, IoAddrWidth)
		)

		port map
		(
			SysCtrl		=>	SysCtrl,
			IoCtrl		=>	IoCtrl,
			IoOut		=>	TestOut
		);

		
	TRIG : entity work.EmuTrigger 
	
		generic map
		(
			PORT_ADDR	=>	to_unsigned(TRIGGER_PORT, IoAddrWidth),
			INT_VECTOR	=>	to_unsigned(TRIGGER_VECT, InterruptVectorWidth),
			COUNT_INIT	=>	to_unsigned(10000, 16)
		)

		port map
		(
			SysCtrl		=>	SysCtrl,
			IoCtrl		=>	IoCtrl,
			IoOut		=>	TriggerOut
		);
	
		
end architecture;