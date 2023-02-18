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

entity EmuTrigger is

	generic
	(
		PORT_ADDR		: unsigned(IoAddrWidth - 1 downto 0);
		INT_VECTOR		: unsigned(InterruptVectorWidth - 1 downto 0);
		COUNT_INIT		: unsigned(15 downto 0)
	);

	port
	(
		SysCtrl			: in	SystemCtrlRec;
		IoCtrl			: in	IoCtrlRec;
		IoOut			: out	InOutRec
	);

end entity;


architecture RTL of EmuTrigger is

	type StateType is (sCounting, sInterrupting);
	
	signal State	: StateType;
	signal Count	: std_logic_vector(15 downto 0);
	signal Trig 	: std_logic;
	signal Hit		: std_logic;
	signal Reg		: DataWord;
	
	alias  Enabled	: std_logic is Reg(0);

begin
	Hit	<= '1' when IoCtrl.Addr = std_logic_vector(PORT_ADDR) else '0';

	IoOut.IntReq	<= Trig;
	IoOut.IntVect	<= std_logic_vector(INT_VECTOR) when Trig else (others => '1');
	IoOut.Data		<= Reg when Hit and IoCtrl.RD else (others => '0');
	IoOut.BitData	<= Reg(to_integer(unsigned(IoCtrl.BitAddr))) when Hit and IoCtrl.RD else '0';

	process(SysCtrl) begin
	
		if not SysCtrl.nReset then
		
			Trig 	<= '0';
			State	<= sCounting;
			Count	<= std_logic_vector(COUNT_INIT);
			Reg		<= (others => '0');
		
		else
	
			if rising_edge(SysCtrl.Clock) then
					
				if Hit and IoCtrl.WR then
				
					if IoCtrl.BOP then
					
						Reg(to_integer(unsigned(IoCtrl.BitAddr))) <= IoCtrl.BitData;
					
					else
					
						Reg <= IoCtrl.Data;
					
					end if;
				
				end if;
		
				case State is
				
					when sCounting =>
					
						Count <= Count - 1;
					
						if Count = 0 then
						
							Count 	<= std_logic_vector(COUNT_INIT);
							
							if Enabled then
							
								Trig	<= '1';
								State	<= sInterrupting;
								
							end if;
						
						end if;
						
					
					when sInterrupting =>
					
						if IoCtrl.IntAck then
						
							Trig 	<= '0';
							State	<= sCounting;
						
						end if;
					
				end case;
		
			end if;
		
		end if;
	
	end process;	
	


end architecture;