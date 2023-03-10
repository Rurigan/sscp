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

entity ProcessorUnit is

	generic 
	(
		ProgramFile : string := "(none)"
	);

	port
	(
		SysCtrl		: in	SystemCtrlRec;
		SysInfo		: out	SystemInfoRec;
		FromIo		: in	InOutRec;
		ToIo		: out	IoCtrlRec
	);

end entity;	


architecture RTL of ProcessorUnit is

	signal CpuToPrg		: PrgMemoryCtrlRec;
	signal CpuToData	: DataMemoryCtrlRec;
	signal PrgToCpu		: PrgMemoryOutRec;
	signal DataToCpu	: DataMemoryOutRec;

begin

	CPU : component CentralProcessingUnit

		port map
		(
			SysCtrl			=>	SysCtrl,
			SysInfo			=>	SysInfo,
			FromPrgMem		=>	PrgToCpu,
			FromDataMem		=>	DataToCpu,
			FromIo			=>	FromIo,
			ToPrgMem		=>	CpuToPrg,
			ToDataMem		=>	CpuToData,
			ToIo			=>	ToIo
		);
		
		
	MEM : component ProcessorMemory 

		generic map
		(
			ProgramFile 	=>	ProgramFile
		)

		port map
		(
			SysCtrl			=>	SysCtrl,
			ToPrgMem		=>	CpuToPrg,
			ToDataMem		=>	CpuToData,
			FromPrgMem		=>	PrgToCpu,
			FromDataMem		=>	DataToCpu
		);
		
end;