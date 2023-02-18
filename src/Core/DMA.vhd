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

entity DataMemoryAccess is

	port 
	(
		SysCtrl			: in	SystemCtrlRec;
		Ctrl			: in	DmaCtrlRec;
		OutRec			: out	DmaOutRec;
		ToReg			: out	DmaToRegRec;
		ToIoa			: out	DmaToIoaRec;
		ToMem			: out 	DataMemoryCtrlRec;
		FromReg			: in	RegOutRec;
		FromIoa			: in	IoaToDmaRec;
		FromPma			: in	PmaOutRec;
		FromMem			: in 	DataMemoryOutRec
	);

end entity;

architecture RTL of DataMemoryAccess is

	signal HitReg		: std_logic;
	signal HitIo		: std_logic;
	signal HitMem		: std_logic;
	signal CS			: std_logic;
	
	signal AddrBase		: SRamAddr;
	signal Addr			: SRamAddr;
	
	signal DataOut		: DataWord;
	
	signal eaddr		: SramAddr;
	
begin
	
	CS				<= Ctrl.RD or Ctrl.WR;
	HitReg 			<= '1' when (Addr < x"20") and (CS = '1') else '0';
	HitIo			<= '1' when (Addr < x"100") and (HitReg = '0') and (CS = '1') else '0';
	HitMem			<= not (HitReg or HitIO) and CS;
	
	AddrBase		<=  FromPma.DPTR when Ctrl.UseDPTR	
							else FromReg.X when Ctrl.UseX
							else FromReg.Y when Ctrl.UseY
							else FromReg.Z when Ctrl.UseZ
							else FromReg.SP when Ctrl.UseSP
							else (others => '0');
	
	Addr			<= std_logic_vector(signed(AddrBase) + signed(Ctrl.AddrOffset));
	
	DataOut			<=	FromPma.RetAddr(15 downto 8) when Ctrl.UseRetH
							else FromPma.RetAddr(7 downto 0) when Ctrl.UseRetL
							else FromReg.A when CS 
							else (others => '0');
	
	OutRec.Data		<= FromReg.DMA when HitReg and Ctrl.RD
							else FromIoa.Data when HitIo and Ctrl.RD 
							else FromMem.Data when HitMem and Ctrl.RD
							else (others => '0');
						
	ToReg.Addr		<= Addr(ToReg.Addr'range);
	ToReg.RD		<= HitReg and Ctrl.RD;
	ToReg.WR		<= HitReg and Ctrl.WR;
	ToReg.Data		<= DataOut;
					
	eaddr			<= Addr - x"0020"; 
	ToIoa.Addr		<= eaddr(ToIoa.Addr'range);
	ToIoa.RD		<= HitIo and Ctrl.RD;
	ToIoa.WR		<= HitIo and Ctrl.WR;
	ToIoa.Data		<= DataOut;
					
	ToMem.Addr		<= Addr;
	ToMem.Bank		<= (others => '0');
	ToMem.RD		<= HitMem and Ctrl.RD;
	ToMem.WR		<= HitMem and Ctrl.WR;
	ToMem.Data		<= DataOut;					
					
end architecture;
