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

entity InputPort is

	--
	-- Drives 7 segment display
	--
	-- offset   bits   	rd/wr  
	-- ------	-----	----- 
	-- 0		7-0		RD		: input to port
	--					WR		: interupt mask - only bits set to high will generate interrupt 
	--					 
	--
	
	generic
	(
		PortAddr	: IoAddr;
		IntVect		: InterruptVector	
	);
	
	port
	(
		SysCtrl		: in 	SystemCtrlRec;
		FromCpu		: in	IoCtrlRec;
		IntAck		: in	std_logic;
		ToCpu		: out	InOutRec;
		Input		: in	DataWord
	);

end entity;

architecture RTL of InputPort is
	
	signal Hit		: std_logic;
	signal HitRD	: std_logic;
	signal HitWR	: std_logic;

	signal Mask		: DataWord;
	signal OrgState	: DataWord;
	signal Changed	: DataWord;
	signal Trig		: std_logic;
	signal IntReq	: Std_logic;
	
begin

	Hit				<= '1' when FromCpu.Addr = PortAddr else '0';
	HitRD			<= Hit and FromCpu.RD;
	HitWR			<= Hit and FromCpu.WR;

	ToCpu.BitData	<= Input(to_integer(unsigned("0" & FromCpu.BitAddr))) when HitRD  else '0';
	ToCpu.Data		<= Input when HitRD else (others => '0');
	ToCpu.IntReq	<= IntReq;
	ToCpu.IntVect	<= IntVect when IntReq else (others => '0');

	Trig			<= Changed(0) or Changed(1) or Changed(2) or Changed(3) or Changed(4) or Changed(5) or Changed(6) or Changed(7);

	
	genchg : for i in 0 to 7 generate
	
		Changed(i)<= Mask(i) and (Input(i) xor OrgState(i));
	
	end generate;

	
	process(SysCtrl, Input, HitWR, Trig) begin
	
		if not SysCtrl.nReset then
		
			Mask		<= (others => '0');
			OrgState	<= Input;
			IntReq		<= '0';
			
		else
		
			if rising_edge(SysCtrl.Clock) then
			
				if HitWR then
				
					if FromCpu.BOP then
					
						Mask(to_integer(unsigned("0" & FromCpu.BitAddr))) <= FromCpu.BitData;
						OrgState(to_integer(unsigned("0" & FromCpu.BitAddr))) <= Input(to_integer(unsigned("0" & FromCpu.BitAddr)));
						
					else
					
						Mask 		<= FromCpu.Data;
						OrgState	<= Input;
						
					end if;
				
				else
				
					if Trig and not (IntAck or IntReq) then
					
						IntReq 	<= '1';
					
					end if;
				
				end if;
				
				if FromCpu.IntAck then
				
					OrgState	<= Input;
					IntReq		<= '0';
					
				end if;
			
			end if;
	
		end if;
		
	end process;	

end architecture;
