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


entity SscpTop is

	port
	(
		CpuClock		: in 		std_logic;
		nCpuReset		: in 		std_logic;
		ValidInstr		: out		std_logic
	);

end entity;

architecture RTL of SscpTop is

	signal SysCtrl		: SystemCtrlRec;
	signal SysInfo		: SystemInfoRec;
	
	signal CpuToPrg		: PrgMemoryCtrlRec;
	signal CpuToData	: DataMemoryCtrlRec;
	signal CpuToIo		: IoCtrlRec;
	signal PrgToCpu		: PrgMemoryOutRec;
	signal DataToCpu	: DataMemoryOutRec;
	signal IoToCpu		: InOutRec;

begin
	SysCtrl.Clock	<= CpuClock;
	SysCtrl.nReset	<= nCPuReset;
	ValidInstr		<= SysInfo.ValidInstr;
	

	CPU : component ProcessorUnit

		port map
		(
			SysCtrl			=>	SysCtrl,
			SysInfo			=>	SysInfo,
			FromIo			=>	IoToCpu,
			ToIo			=>	CpuToIo
		);
		
		
	IO : entity work.Io
	
		port map
		(
			SysCtrl			=>	SysCtrl,
			IoCtrl			=>	CpuToIo,
			IoOut			=>	IoToCpu
		);


end architecture;
