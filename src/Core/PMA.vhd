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
use work.Opcodes.OpSTS;
use work.Opcodes.OpLDS;
use work.Opcodes.OpJMP;
use work.Opcodes.OpCALL;

entity ProgramMemoryAccess is

	port 
	(
		SysCtrl			: in	SystemCtrlRec;
		Ctrl			: in	PmaCtrlRec;
		IntVect			: in	InterruptVector;
		RegOut			: in	RegOutRec;
		OutRec			: out	PmaOutRec;
		FromMem			: in	PrgMemoryOutRec;
		ToMem			: out	PrgMemoryCtrlRec
	);

end entity;

architecture RTL of ProgramMemoryAccess is

	signal IR			: OpcodeWord;
	signal PC			: ProgramAddr;
	signal NextPC		: ProgramAddr;
	signal IntJmp		: ProgramAddr;
	
	signal PC2			: ProgramAddr;	-- use for debugging
	signal IR2			: OpcodeWord;	-- use for debugging
	
begin
	PC2	<= PC(14 downto 0) & "0"; 				-- use for debugging
	IR2 <= IR(7 downto 0) & IR(15 downto 8);	-- use for debugging 

	OutRec.IR		<= IR;
	OutRec.PC		<= PC;
	OutRec.LpmOut	<= FromMem.Data(15 downto 8) when RegOut.Z(0) else FromMem.Data(7 downto 0);
	OutRec.RetAddr	<= PC - 1 when Ctrl.UseCurrent else std_logic_vector(unsigned(PC) + to_unsigned(conv_integer(Ctrl.AdjRet),16));
	
	OutRec.NextIsTw	<=	'1' when
								(	
									std_match(FromMem.Data, OpCALL)
									or std_match(FromMem.Data, OpJMP)
									or std_match(FromMem.Data, OpLDS)
									or std_match(FromMem.Data, OpSTS)
								)
							else '0';
	
	ToMem.Addr		<= "0" & RegOut.Z(15 downto 1) when 
								(
									Ctrl.LpmRead
								)
							else RegOut.RET when 
								(
									Ctrl.UseRetVect
								)
							else PC;
	
	NextPC			<=  RegOut.RET when 
								(
									Ctrl.UseRetVect
								)
							else std_logic_vector(signed(PC) + signed(Ctrl.PcOffset));
						
	IntJmp			<= "0000000000" & IntVect & "0";	
	
	
	process(SysCtrl) begin
	
		if not SysCtrl.nReset then
		
			PC <= (others => '0');
			IR <= (others => '0');
		
		else
		
			if rising_edge(SysCtrl.Clock) then
			
				if Ctrl.NewInstr then
				
					IR	<= FromMem.Data;
				
				end if;
				
				if Ctrl.LoadDPTR then
				
					OutRec.DPTR <= FromMem.Data;
				
				end if;
			
				if Ctrl.UseIntVect then
				
					PC <= IntJmp;
				
				elsif Ctrl.UseRetVect then
				
					PC <= RegOut.RET + 1;
					
				elsif Ctrl.UseImmVect then
				
					PC <= FromMem.Data;
					
				elsif Ctrl.UseZ then
				
					PC <= RegOut.Z;
			
				else
				
					PC <= NextPC;
					
				end if;
				
			end if;
		
		end if;
	
	end process;

end architecture;
