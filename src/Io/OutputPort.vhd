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

entity OutputPort is

	generic
	(
		PortAddr	: IoAddr;
		PortDef		: DataWord	:= x"00"	
	);
	
	port
	(
		SysCtrl		: in 	SystemCtrlRec;
		FromCpu		: in	IoCtrlRec;
		ToCpu		: out	InOutRec;
		Output		: out	DataWord
	);
	
end entity;


architecture RTL of OutputPort is

	signal Hit		: std_logic;
	signal HitRD	: std_logic;
	signal HitWR	: std_logic;
	signal Reg		: DataWord;
	
begin
	Output			<= Reg;
	
	Hit				<= '1' when FromCpu.Addr = PortAddr else '0';
	HitRD			<= Hit and FromCpu.RD;
	HitWR			<= Hit and FromCpu.WR;
	
	ToCpu.BitData	<= Reg(to_integer(unsigned("0" & FromCpu.BitAddr))) when HitRD else '0';
	ToCpu.Data		<= Reg when HitRD else (others => '0');
	ToCpu.IntReq	<= '0';
	ToCpu.IntVect	<= (others => '0');

	process(SysCtrl, HitWR) begin
	
		if not SysCtrl.nReset then
		
			Reg <= PortDef;
		
		else
		
			if rising_edge(SysCtrl.Clock) then
			
				if HitWR then
				
					if FromCpu.BOP then
					
						Reg(to_integer(unsigned(FromCpu.BitAddr))) <= FromCpu.BitData;					
					
					else
					
						Reg <= FromCpu.Data;
					
					end if;
				
				end if;
			
			end if;
		
		end if;
	
	end process;
	
end;

