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

entity InputOutputAccess is

	generic
	(
		STATUS_REG	: unsigned	:= STATUS_REG;
		STACK_PTR	: unsigned	:= STACK_PTR
	);
			
	port 
	(
		SysCtrl			: in	SystemCtrlRec;
		Ctrl			: in	IoaCtrlRec;
		OutRec			: out	IoaOutRec;
		FromDma			: in	DmaToIoaRec;
		ToDma			: out	IoaToDmaRec;
		FromReg			: in	RegOutRec;
		ToReg			: out	IoaToRegRec;
		FromIo			: in	InOutRec;
		ToIo			: out	IoCtrlRec;
		FromAlu			: in 	AluOutRec
	);

end entity;

architecture RTL of InputOutputAccess is

	signal Addr		: IoAddr;
	signal RD		: std_logic;
	signal WR		: std_logic;
	
	signal HitSREG	: std_logic;
	signal HitSPL	: std_logic;
	signal HitSPH	: std_logic;
	
begin

	Addr			<= FromDma.Addr when FromDma.RD or FromDma.WR else Ctrl.Addr;
	RD				<= Ctrl.RD or FromDma.RD;
	WR				<= Ctrl.WR or FromDma.WR;
	
	HitSREG			<= '1' when Addr = std_logic_vector(STATUS_REG) else '0';			
	HitSPL			<= '1' when Addr = std_logic_vector(STACK_PTR) else '0';
	HitSPH			<= '1' when Addr = std_logic_vector(STACK_PTR + 1) else '0';
	
	ToReg.SetSREG	<= '1' when HitSREG and WR else '0';
	ToReg.SetSPL	<= '1' when HitSPL and WR else '0';
	ToReg.SetSPH	<= '1' when HitSPH and WR else '0';
	
	OutRec.BitData	<= FromIo.BitData;
	
	OutRec.Data		<=  FromReg.SP(7 downto 0) when HitSPL and RD
							else FromReg.SP(15 downto 8) when HitSPH and RD
							else FromAlu.STATUS  when HitSREG and RD
							else FromIo.Data;
							
						
	ToIo.Addr		<= Addr;
	ToIo.RD			<= RD;
	ToIo.WR			<= WR;
	ToIo.BOP		<= Ctrl.BOP;
	ToIo.IntAck		<= Ctrl.IntAck;
						
	ToIo.BitData	<= Ctrl.BitData;
	ToIo.BitAddr	<= Ctrl.BitAddr;
	
	ToIo.Data		<= FromDma.Data when FromDma.WR 
							else FromReg.A; 
	
	ToDma.Data		<= OutRec.Data;
	ToReg.Data		<= OutRec.Data;
	
end architecture;
