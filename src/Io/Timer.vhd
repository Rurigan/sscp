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

entity Timer is

	--
	-- Generate interupt after (Count + 1) * (Mulitplier + 1) of ExtCLock rising edges
	--
	-- 2 MHz external clock, 49.999 count, 39 multiblier should give a one second resolution	
	--
	-- offset   bits   	rd/wr  
	-- ------	-----	----- 
	--	0				RD/WR	Count low byte		 
	--  1				RD/WR	Count high byte
	--  2				RD/WR	Mulitplier
	--
	
	generic
	(
		PortAddr	: IoAddr			:= x"55";
		IntVect		: InterruptVector	:= "10101"
	);
	
	port
	(
		SysCtrl		: in 	SystemCtrlRec;
		FromCpu		: in	IoCtrlRec;
		ToCpu		: out	InOutRec;
		IntAck		: in	std_logic;
		Enable		: in	std_logic;
		ExtClock	: in	std_logic
	);

end entity;

architecture RTL of Timer is

	signal CountReg			: DoubleWord;
	alias  CountRegL		: DataWord is CountReg(7 downto 0);
	alias  CountRegH		: DataWord is CountReg(15 downto 8);
	signal MultiplierReg	: DataWord;
	
	signal IntReq			: std_logic;
	signal Trig				: std_logic;
	signal TrigAck			: std_logic;

	signal IntClock			: std_logic;
	signal Multiplier		: DataWord;
	signal Count			: DoubleWord;
	signal TmpMultiplier	: DataWord;
	signal TmpCount			: DoubleWord;
	
	signal HitCtrl			: std_logic;
	signal HitCountL		: std_logic;
	signal HitCountH		: std_logic;
	signal HitMult			: std_logic;

	signal BitInx 			: integer range 0 to 7;
	alias  RD				: std_logic is FromCpu.RD;
	alias  WR				: std_logic is FromCpu.WR;

begin

	HitCountL	<= '1' when FromCpu.Addr = PortAddr + 0 else '0';
	HitCountH	<= '1' when FromCpu.Addr = PortAddr + 1 else '0';
	HitMult		<= '1' when FromCpu.Addr = PortAddr + 2 else '0';
	BitInx		<= to_integer(unsigned(FromCpu.BitAddr));
	
	
	ToCpu.IntReq	<= IntReq;
	ToCpu.IntVect	<= IntVect when IntReq else (others => '0');

	ToCpu.BitData	<= CountRegL(BitInx) when HitCountL and RD 
							else CountRegH(BitInx) when HitCountH and RD 
							else MultiplierReg(BitInx) when HitMult and RD
							else '0';
							
	ToCpu.Data		<= CountRegL when HitCountL and RD
							else CountRegH when HitCountH and RD
							else MultiplierReg when HitMult and RD
							else (others => '0');
							
		
	process(SysCtrl, TmpCount, TmpMultiplier) begin
	
		if not SysCtrl.nReset then
		
			CountRegL		<= (others => '1');
			CountRegH		<= (others => '1');
			MultiplierReg	<= (others => '1');
			Count			<= (others => '0');
			Multiplier		<= (others => '0');
			IntReq			<= '0';
			TrigAck			<= '0';
			
		else 
		
			if rising_edge(SysCtrl.Clock) then
			
				Count 		<= TmpCount;
				Multiplier	<= TmpMultiplier;
				
				if Trig then
				
					if not TrigAck then
				
						IntReq	<= '1';
						TrigAck	<= '1';
					
					end if;
					
				else
				
					TrigAck <= '0';
					
				end if;
			
				if HitCountL and WR then 
				
					CountRegL <= FromCpu.Data;
				
				end if;
			
				if HitCountH and WR then 
				
					CountRegH <= FromCpu.Data;
				
				end if;
			
				if HitMult and WR then
				
					MultiplierReg <= FromCpu.Data;
					
				end if;
				
				if IntAck and IntReq then
				
					IntReq	<= '0';
				
				end if;
			
			end if;
		
		end if;
	
	end process;
	
	
	process(ExtClock, Enable, Count, Multiplier, TrigAck) begin

		if rising_edge(ExtClock) then
		
			if Enable then
			
				TmpCount 		<= Count + 1;
				TmpMultiplier	<= Multiplier;

				if TmpCount = CountReg then
				
					TmpCount 		<= (others => '0');
					TmpMultiplier	<= TmpMultiplier + 1;
					
					if TmpMultiplier = MultiplierReg then
					
						TmpMultiplier	<= (others => '0');
						Trig			<= '1';
					
					end if;
					
				end if;
					
				if TrigAck then
				
					Trig	<= '0';
				
				end if;
				
			else
			
				Trig			<= '0';
				TmpCount		<= (others => '0');
				TmpMultiplier	<= (others => '0');
				
			end if;
		
		end if;
	
	end process;
	
end;