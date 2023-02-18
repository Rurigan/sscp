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

entity DmaControl is

	port
	(
		DS			: in	DecoderOutRec;
		Cycle		: in	CycleOutRec;
		InInt		: in	std_logic;
		IR			: in	OpcodeWord;
		DmaCtrl		: out	DmaCtrlRec
	);

end entity;

architecture RTL of DmaControl is

begin

	DmaCtrl.RD			<= 	(
								Cycle.c0 and
								(
									DS.OpLDDY
									or DS.OpLDDZ
									or DS.OpLDX
									or DS.OpLDXI
									or DS.OpLDYI
									or DS.OpLDZI
								)
							)
							or 
							(
								Cycle.c1 and
								(
									DS.OpLDS
									or DS.OpLDXD
									or DS.OpLDYD
									or DS.OpLDZD
									or DS.OpPOP
									or DS.OpRET
									or DS.OpRETI
								)
							)
							or 
							(
								Cycle.c2 and
								(
									DS.OpRET
									or DS.OpReTI
								)
							);
	
	
	DmaCtrl.WR		<=	(
								Cycle.c0 and
								(
									InInt
									or DS.OpCALL
									or DS.OpICALL
									or DS.OpPUSH
									or DS.OpRCALL
									or DS.OpSTDY
									or DS.OpSTDZ
									or DS.OpSTZI
									or DS.OpSTX
									or DS.OpSTXI
									or DS.OpSTYI
								)
							)
							or 
							(
								Cycle.c1 and
								(
									InInt
									or DS.OpCALL
									or DS.OpICALL
									or DS.OpRCALL
									or DS.OpSTS
									or DS.OpSTXD
									or DS.OpSTYD
									or DS.OPSTZD
								)
							);
						

	DmaCtrl.UseSP		<=	(
								Cycle.c0 and
								(
									InInt
									or DS.OpCALL
									or DS.OpICALL
									or DS.OpPUSH
									or DS.OpRCALL
								)
							)
							or 
							(
								Cycle.c1 and
								(
									InInt
									or DS.OpCALL
									or DS.OpICALL
									or DS.OpPOP
									or DS.OpRCALL
									or DS.OpRET
									or DS.OpRETI
								)
							)
							or 
							(
								Cycle.c2 and
								(
									DS.OpRET
									or DS.OpRETI
								)
							);
	
	
	DmaCtrl.UseDPTR		<=	(
								Cycle.c1 and
								(
									DS.OpLDS
									or DS.OpSTS
								)
							);
						
						
	DmaCtrl.UseRetL		<=	(
								Cycle.c0 and
								(
									InInt
									or DS.OpCALL
									or DS.OpICALL
									or DS.OpRCALL
								)
							);
	
	
	DmaCtrl.UseRetH		<=	(
								Cycle.c1 and
								(
									InInt
									or DS.OpCALL
									or DS.OpICALL
									or DS.OpRCALL
								)
							);
						
				
	DmaCtrl.UseX		<=	(
								Cycle.c0 and
								(
									DS.OpLDX
									or DS.OpLDXI
									or DS.OpSTX
									or DS.OpSTXI
								)
							)
							or
							(
								Cycle.c1 and
								(
									DS.OpLDXD
									or DS.OpSTXD
								)
							);
				
				
	DmaCtrl.UseY		<=	(
								Cycle.c0 and
								(
									DS.OpLDDY
									or DS.OpLDYI
									or DS.OpSTDY
									or DS.OpSTYI
								)
							)
							or
							(
								Cycle.c1 and
								(
									DS.OpLDYD
									or DS.OpSTYD
								)
							);
				
				
	DmaCtrl.UseZ		<=	(
								Cycle.c0 and
								(
									DS.OpLDZI
									or DS.OpLDDZ
									or DS.OpSTDZ
									or DS.OpSTZI
								)
							)
							or
							(
								Cycle.c1 and
								(
									DS.OpLDZD
									or DS.OpSTZD
								)
							);
				
				
	DmaCtrl.AddrOffset	<= 	std_logic_vector(to_signed(0,10)) & IR(13) & IR(11 downto 10) & IR(2 downto 0) when 
									(
										Cycle.c0 and
										(
											DS.OpLDDY
											or DS.OpLDDZ
											or DS.OpSTDY
											or DS.OpSTDZ
										)
									)
								else (others => '0');
	
end architecture;