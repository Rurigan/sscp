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

entity CentralProcessingUnit is

	port
	(
		SysCtrl			: in	SystemCtrlRec;
		SysInfo			: out	SystemInfoRec;
		FromPrgMem		: in 	PrgMemoryOutRec;
		FromDataMem		: in 	DataMemoryOutRec;
		FromIo			: in	InOutRec;
		ToPrgMem		: out 	PrgMemoryCtrlRec;
		ToDataMem		: out 	DataMemoryCtrlRec;
		ToIo			: out	IoCtrlRec
	);

end entity;	

architecture RTL of CentralProcessingUnit is

	signal RegCtrl		: RegCtrlRec;
	signal PmaCtrl		: PmaCtrlRec;
	signal DmaCtrl		: DmaCtrlRec;
	signal IoaCtrl		: IoaCtrlRec;
	signal AluCtrl		: AluCtrlRec;
	signal RegOut		: RegOutRec;
	signal AluOut		: AluOutRec;
	signal PmaOut		: PmaOutRec;
	signal DmaOut		: DmaOutRec;
	signal IoaOut		: IoaOutRec;
	signal DmaToReg		: DmaToRegRec;
	signal DmaToIoa		: DmaToIoaRec;
	signal IoaToDma		: IoaToDmaRec;
	signal IoaToReg		: IoaToRegRec;

begin

	IOA : component InputOutputAccess

		port map
		(
			SysCtrl		=>	SysCtrl,
			Ctrl		=>	IoaCtrl,
			OutRec		=>	IoaOut,
			FromDma		=>	DmaToIoa,
			ToDma		=>	IoaToDma,
			FromReg		=>	RegOut,
			ToReg		=>	IoaToReg,
			FromIo		=>	FromIo,
			ToIo		=>	ToIo,
			FromAlu		=> 	AluOut
		);
	

	DMA : component DataMemoryAccess

		port map
		(
			SysCtrl		=>	SysCtrl,
			Ctrl		=>	DmaCtrl,
			OutRec		=>	DmaOut,
			ToReg		=>	DmaToReg,
			ToIoa		=>	DmaToIoa,
			ToMem		=>	ToDataMem,
			FromReg		=>	RegOut,
			FromIoa		=>	IoaToDma,	
			FromPma		=>	PmaOut,
			FromMem		=>	FromDataMem
		);
	

	PMA : component ProgramMemoryAccess

		port map
		(
			SysCtrl		=>	SysCtrl,
			Ctrl		=>	PmaCtrl,
			IntVect		=>	FromIo.IntVect,
			RegOut		=> 	RegOut,
			OutRec		=>	PmaOut,
			FromMem		=>	FromPrgMem,		
			ToMem		=>	ToPrgMem
		);
	

	REG : component RegisterFile 

		port map
		(
			SysCtrl		=>	SysCtrl,
			RegCtrl		=>	RegCtrl,
			RegOut		=>	RegOut,
			AluOut		=>	AluOut,
			PmaOut		=> 	PmaOut,
			DmaOut		=>	DmaOut,
			IoaOut		=>	IoaOut,
			FromDma		=>	DmaToReg,
			FromIoa		=>	IoaToReg
		);

		
	ALU : component ArithmeticLogicUnit 

		port map
		(
			SysCtrl		=>	SysCtrl,
			AluCtrl		=>	AluCtrl,
			RegOut		=> 	RegOut,
			Immediate	=>	RegCtrl.Immediate,
			AluOut		=>	AluOut,		
			SetSREG		=> IoaToReg.SetSREG
		);

		
	SEQ : component Sequncer 

		port map
		(
			SysCtrl		=>	SysCtrl,
			AluCtrl		=>	AluCtrl,
			RegCtrl		=>	RegCtrl,
			PmaCtrl		=>	PmaCtrl,
			DmaCtrl		=>	DmaCtrl,
			IoaCtrl		=>	IoaCtrl,
			RegOut		=>	RegOut,
			PmaOut		=>	PmaOut,
			DmaOut		=>	DmaOut,
			IoaOut		=>	IoaOut,
			AluOut		=>	AluOut,
			IntReq		=>	FromIo.IntReq,
			NewInstr	=> 	SysInfo.NewInstr,
			ValidInstr	=> 	SysInfo.ValidInstr
		);

end architecture;
