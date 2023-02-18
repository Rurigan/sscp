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

entity RegisterFile is

	port
	(
		SysCtrl			: in	SystemCtrlRec;
		RegCtrl			: in	RegCtrlRec;
		AluOut			: in	AluOutRec;
		PmaOut			: in	PmaOutRec;
		DmaOut			: in	DmaOutRec;
		IoaOut			: in 	IoaOutRec;
		FromDma			: in	DmaToRegRec;
		FromIoa			: in  	IoaToRegRec;
		RegOut			: out	RegOutRec
	);

end entity;

architecture RTL of RegisterFile is

	type RegisterArray is array(0 to 31) of DataWord;
	
	signal Registers	: RegisterArray;
	signal SP			: SRamAddr;
	signal Akk			: DataWord;
	signal Input		: DataWord;

	alias  XL			: DataWord is Registers(26);
	alias  XH			: DataWord is Registers(27);
	alias  YL			: DataWord is Registers(28);
	alias  YH			: DataWord is Registers(29);
	alias  ZL			: DataWord is Registers(30);
	alias  ZH			: DataWord is Registers(31);
	
	signal Xplus		: SRamAddr;
	signal Xminus		: SRamAddr;
	signal Yplus		: SRamAddr;
	signal Yminus		: SRamAddr;
	signal Zplus		: SRamAddr;	
	signal Zminus		: SRamAddr;
	
begin
	RegOut.A		<= Akk;
	RegOut.B		<= Registers(to_integer(unsigned(RegCtrl.SelB)));
	RegOut.SP		<= SP;
	RegOut.X		<= XH & XL;
	RegOut.Y		<= YH & YL;
	RegOut.Z		<= ZH & ZL;
	RegOut.DMA 		<= Registers(to_integer(unsigned(FromDma.Addr)));
	
	Xplus			<= (XH & XL) + 1;
	Xminus			<= (XH & XL) - 1;
	Yplus			<= (YH & YL) + 1;
	Yminus			<= (YH & YL) - 1;
	Zplus			<= (ZH & ZL) + 1;
	Zminus			<= (ZH & ZL) - 1;	
	
	Akk				<= Registers(to_integer(unsigned(RegCtrl.SelA)));
	
	Input			<= Akk when RegCtrl.UseAkk
						else RegCtrl.Immediate when RegCtrl.UseImm
						else DmaOut.Data when RegCtrl.DmaRD
						else AluOut.Result;

	process(SysCtrl) begin
	
		if not SysCtrl.nReset then
		 
			for i in 0 to 31 loop
			
				Registers(i) 	<= (others => '1');
			
			end loop;
		
			SP				<= (others => '1');
		
		else
		
			if rising_edge(SysCtrl.Clock) then
			
				if FromIoa.SetSPL then
				
					SP(7 downto 0) <= Akk; 
				
				end if;
				
				if FromIoa.SetSPH then
				
					SP(15 downto 8) <= Akk; 
					
				end if;
				
				if RegCtrl.IncSP then
				
					SP <= SP + 1;
				
				end if;
				
				if RegCtrl.DecSP then
				
					SP <= SP - 1;
				
				end if;
				
				if RegCtrl.IncX then
				
					XH <= Xplus(15 downto 8);
					XL <= Xplus(7 downto 0);
				
				end if;

				if RegCtrl.DecX then
				
					XH <= Xminus(15 downto 8);
					XL <= Xminus(7 downto 0);
				
				end if;
				
				if RegCtrl.IncY then
				
					YH <= Yplus(15 downto 8);
					YL <= Yplus(7 downto 0);
				
				end if;
				
				if RegCtrl.DecY then
				
					YH <= Yminus(15 downto 8);
					YL <= Yminus(7 downto 0);
				
				end if;
			
				if RegCtrl.IncZ then
				
					ZH 		<= Zplus(15 downto 8);
					ZL 		<= Zplus(7 downto 0);
				
				end if;
			
				if RegCtrl.DecZ then
				
					ZH 		<= Zminus(15 downto 8);
					ZL 		<= Zminus(7 downto 0);
					
				end if;
				
				if RegCtrl.LpmIn then
				
					Registers(to_integer(unsigned(RegCtrl.SelIn))) <= PmaOut.LpmOut;
					
				elsif RegCtrl.SetRetL then

					RegOut.RET(7 downto 0) <= DmaOut.Data;

				elsif RegCtrl.SetRetH then
			
					RegOut.RET(15 downto 8) <= DmaOut.Data;					
				
				elsif RegCtrl.DmaRD then
			
					Registers(to_integer(unsigned(RegCtrl.SelIn))) <= DmaOut.Data;
					
				elsif RegCtrl.IoRD then
			
					Registers(to_integer(unsigned(RegCtrl.SelIn))) <= FromIoa.Data;
					
				elsif RegCtrl.EnableIn then
				
					Registers(to_integer(unsigned(RegCtrl.SelIn))) <= Input;
				
				elsif RegCtrl.CopyPair then
				
					Registers(to_integer(unsigned(RegCtrl.SelA))) <= Registers(to_integer(unsigned(RegCtrl.SelB)));
					Registers(to_integer(unsigned(RegCtrl.SelA) + 1)) <= Registers(to_integer(unsigned(RegCtrl.SelB) + 1));					
			
				elsif FromDma.WR then
				
					Registers(to_integer(unsigned(FromDma.Addr))) <= FromDma.Data;			
					
				end if;
			
			end if;
		
		end if;
	
	end process;

end;