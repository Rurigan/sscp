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

entity IoaControl is

	port
	(
		DS			: in	DecoderOutRec;
		Cycle		: in	CycleOutRec;
		IR			: in	OpcodeWord;
		IoBit		: in	std_logic;
		IntAck		: in	std_logic;
		IoaCtrl		: out	IoaCtrlRec;
		IoSkip		: out	std_logic
	);

end entity;

architecture RTL of IoaControl is

begin

	IoaCtrl.IntAck	<= IntAck;
						
						
	IoaCtrl.RD		<= 	(
							DS.OpIN 
							or DS.OpSBIC 
							or DS.OpSBIS
						);
	 
	 
	IoaCtrl.WR		<= 	(
							DS.OpOUT 
							or DS.OpCBI 
							or DS.OpSBI
						);
	
	
	IoaCtrl.Addr	<=	"000" & IR(7 downto 3) when 
								(
									DS.OpCBI 
									or DS.OpSBI 
									or DS.OpSBIC 
									or DS.OpSBIS
								)
							else "00" & IR(10 downto 9) & IR(3 downto 0);
	
	
	IoaCtrl.BOP		<= 	(
							DS.OpCBI 
							or DS.OpSBI 
							or DS.OpSBIC 
							or DS.OpSBIS
						);
	
	
	IoaCtrl.BitAddr	<= 	IR(2 downto 0);
	
	
	IoaCtrl.BitData	<= 	(
							DS.OpSBI
						);
						
					
	IoSkip			<=	(	
							(DS.OpSBIC and not IoBit) 
							or (DS.OpSBIS and IoBit) 
						);
		
end architecture;