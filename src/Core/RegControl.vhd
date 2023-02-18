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

entity RegControl is

	port
	(
		DS			: in	DecoderOutRec;
		Cycle		: in	CycleOutRec;
		IR			: in	OpcodeWord;
		InInt		: in	std_logic;
		RegCtrl		: out	RegCtrlRec
	);

end entity;

architecture RTL of RegControl is

begin

	RegCtrl.IoRD		<= 	DS.OpIN;

	
	RegCtrl.Immediate	<= 	"00000001" when 
									(
										DS.OpDEC
										or DS.OpINC
									)
								else "00" & IR(7 downto 6) & IR(3 downto 0) when 
									(
										Cycle.c0 and 
										(
											DS.OpSBIW 
											or DS.OpADIW
										)
									) 
								else (others => '0') when 
									(
										InInt 
										or DS.OpBLD 
										or DS.OpBCLR 
										or DS.OpBSET
										or DS.OpBST 
									)
									or 
									(
										Cycle.c0 and 
										(
											DS.OpSBRC 
											or DS.OpSBRS
										)
									)
									or 
									(
										Cycle.c1 and 
										(
											DS.OpADIW
											or DS.OpSBIW 
										)
									)
									or 
									(
										cycle.c3 and 
										(
											DS.OpRETI
										)
									)
								else IR(11 downto 8) & IR(3 downto 0);

								
	RegCtrl.SelA		<= 	"1" & IR(7 downto 4) when 
									(
										DS.OpANDI
										or DS.OpCPI
										or DS.OpORI
										or DS.OpSBCI
										or DS.OpSUBI
									)
								else IR(9) & IR(3 downto 0) when 
									(
										DS.OpMOV
									)
								else IR(7 downto 4) & "0" when
									(
										DS.OpMOVW
									)
								else "11" & IR(5 downto 4) & Cycle.c1 when
									(
										DS.OpADIW
										or DS.OpSBIW
									)
								else IR(8 downto 4);
						
						
	RegCtrl.SelB		<= 	IR(3 downto 0) & "0" when 
									(
										DS.OpMOVW 
									)
								else IR(9) & IR(3 downto 0);
						
						
	RegCtrl.SelIn		<= 	(others => '0') when
									(
										DS.OpLPM
									)
									or
									(
										Cycle.c0 and
										(
											DS.OpMUL
										)
									)
								else "00001" when
									(
										Cycle.c1 and
										(
											DS.OpMUL
										)
									)
								else "1" & IR(7 downto 4) when 
									(
										DS.OpANDI
										or DS.OpLDI 
										or DS.OpORI
										or DS.OpSBCI
										or DS.OpSUBI
									)
								else "11" & IR(5 downto 4) & Cycle.c1 when
									(
										DS.OpADIW
										or DS.OpSBIW
									)
								else IR(8 downto 4);

								
	RegCtrl.EnableIn	<=	not InInt and
								(
									DS.OpADC 
									or DS.OpADD 
									or DS.OpADIW
									or DS.OpAND 
									or DS.OpANDI 
									or DS.OpASR 
									or DS.OpBLD
									or DS.OpCOM
									or DS.OpDEC	
									or DS.OpEOR 
									or DS.OpINC 
									or DS.OpLDI
									or DS.OpLSR
									or DS.OpMOV
									or DS.OpMUL 
									or DS.OpNEG
									or DS.OpOR
									or DS.OpORI 
									or DS.OpROR
									or DS.OpSBC
									or DS.OpSBCI
									or DS.OpSBIW
									or DS.OpSUB
									or DS.OPSUBI
									or DS.OpSWAP
								);
	
	
	RegCtrl.UseAkk		<= 	(
								DS.OpMOV
							);

	
	RegCtrl.UseImm		<= 	(
								DS.OpLDI
							);

	
	RegCtrl.DmaRD		<= 	(
								DS.OpLDDY
								or DS.OpLDDZ
								or DS.OpLDX
							)
							or
							(
								Cycle.c0 and
								(
									DS.OpLDXI
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
								)
							);

							
	RegCtrl.IncSP		<= 	(
								Cycle.c0 and
								(
									DS.OpPOP
									or DS.OpRET
									or DS.OpRETI
								)
							)
							or
							(
								Cycle.c1 and
								(
									DS.OpRET
									or DS.OPRETI
								)
							);
	
	
	RegCtrl.DecSP		<= 	(
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
									or DS.OpRCALL
								)
							);
	
	
	RegCtrl.IncX		<=	(
								Cycle.c1 and
								(
									DS.OpLDXI
									or DS.OpSTXI
								)
							);

							
	RegCtrl.DecX		<= 	(
								Cycle.c0 and
								(
									DS.OpLDXD
									or DS.OpSTXD
								)
							);

							
	RegCtrl.IncY		<=	(
								Cycle.c1 and
								(
									DS.OpLDYI
									or DS.OpSTYI
								)
							);
	
	
	RegCtrl.DecY		<=	(
								Cycle.c0 and
								(
									DS.OpLDYD
									or DS.OpSTYD
								)
							);
	
	
	RegCtrl.IncZ		<= 	(
								Cycle.c1 and
								(
									DS.OpLDZI
									or DS.OpSTZI
								)
							)
							or 
							(
								Cycle.c2 and
								(
									DS.OpLPMZI
								)	
							);
	
	
	RegCtrl.DecZ		<= 	(
								Cycle.c0 and
								(
									DS.OpLDZD
									or DS.OpSTZD
								)
							);

							
	RegCtrl.SetRetL		<=	(
								Cycle.c2 and
								(
									DS.OpRET
									or DS.OpRETI
								)
							);
	
	
	RegCtrl.SetRetH		<=	(
								Cycle.c1 and
								(
									DS.OpRET
									or DS.OpRETI
								)
							);
	
	
	RegCtrl.LpmIn		<= 	(
								Cycle.c1 and
								(
									DS.OPLPM
									or DS.OpLPMZ
									or DS.OpLPMZI
								)
							);
	
	
	RegCtrl.CopyPair	<=	(
								DS.OpMOVW
							);
	
end architecture;