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

entity PmaControl is

	port
	(
		DS			: in	DecoderOutRec;
		Cycle		: in	CycleOutRec;
		InInt		: in	std_logic;
		IR			: in	OpcodeWord;
		NextIsTw	: in	std_logic;
		IoSkip		: in	std_logic;
		AluOut		: in 	AluOutRec;
		PmaCtrl		: out	PmaCtrlRec
	);

end entity;

architecture RTL of PmaControl is

	signal ZeroAluResult 	: std_logic;	
	signal TestBit			: std_logic;

begin
	ZeroAluResult		<= 	'1' when AluOut.RESULT = 0 else '0';
	
	
	TestBit				<=	'1' when 
									(
										(AluOut.RESULT(conv_integer(IR(2 downto 0))) = IR(9)) 
										and (DS.OpSBRC = '1' or DS.OpSBRS = '1')
									)
								else '1' when 
									(
										(IR(10) xor AluOut.STATUS(to_integer(unsigned(IR(2 downto 0))))) 
										and (DS.OpBRBC or DS.OpBRBS)
									)
								else '0';

								
	PmaCtrl.NewInstr	<=  not 
							(
								(
									Cycle.C0 and 
									(
										InInt
										or DS.OpADIW
										or DS.OpCALL
										or DS.OpICALL
										or DS.OpIJMP
										or DS.OpJMP
										or DS.OpLDS
										or DS.OpLDXD
										or DS.OpLDXI
										or DS.OpLDYD
										or DS.OpLDYI
										or DS.OpLDZD
										or DS.OpLDZI
										or DS.OpLPM
										or DS.OpLPMZ
										or DS.OpLPMZI
										or DS.OpMUL
										or DS.OpPOP
										or DS.OpPUSH
										or DS.OpRCALL
										or DS.OpRET
										or DS.OpRETI
										or DS.OpRJMP
										or DS.OpSBIW
										or DS.OpSTS
										or DS.OpSTXD
										or DS.OpSTXI
										or DS.OpSTYD
										or DS.OpSTYI
										or DS.OpSTZD
										or DS.OpSTZI
										or (DS.OpCPSE and ZeroAluResult)
										or ((DS.OpBRBC or DS.OpBRBS) and TestBit)
										or ((DS.OpSBRC or DS.OpSBRS) and TestBit)
										or IoSkip
									)
								)
								or
								(
									Cycle.C1 and 
									(
										InInt 
										or DS.OpCALL
										or DS.OpICALL
										or DS.OpJMP
										or DS.OpLDXD
										or DS.OpLDYD
										or DS.OpLDZD
										or DS.OpLPMZ
										or DS.OpLPMZI
										or DS.OpRCALL
										or DS.OpRET
										or DS.OpRETI
										or (DS.OpCPSE and ZeroAluResult and NextIsTw)
										or ((DS.OpSBRC or DS.OpSBRS) and TestBit and NextIsTw)
										or (IoSkip and NextIsTw)
									)
								)
								or
								(
									Cycle.C2 and 
									(
										InInt 
										or DS.OpCALL
										or DS.OpRET
										or DS.OPRETI
									)
								)
							);
							
	
	PmaCtrl.PcOffset	<= (others => '0') when
								(
									Cycle.c0 and
									(
										InInt
										or DS.OpADIW
										or DS.OpCALL
										or DS.OpICALL
										or DS.OpJMP
										or DS.OpLDXD
										or DS.OpLDXI
										or DS.OpLDYD
										or DS.OpLDYI
										or DS.OpLDZD
										or DS.OpLDZI
										or DS.OpLPM
										or DS.OpLPMZ
										or DS.OpLPMZI
										or DS.OpMUL
										or DS.OpPOP
										or DS.OpPUSH
										or DS.OpRCALL
										or DS.OpRET
										or DS.OpRETI
										or DS.OpSBIW
										or DS.OpSTXD
										or DS.OpSTXI
										or DS.OpSTYD
										or DS.OpSTYI
										or DS.OpSTZD
										or DS.OpSTZI
									)
								)
								or
								(
									Cycle.c1 and 
									(
										InInt
										or DS.OpCALL
										or DS.OpLDXD
										or DS.OpLDYD
										or DS.OpLDZD
										or DS.OpLPMZ
										or DS.OpLPMZI
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
								)				
							else IR(11 downto 0) when 
								(
									Cycle.c0 and 
									(
										DS.OpRJMP
									)
								)
								or 		
								(
									Cycle.c1 and
									(
										DS.OpRCALL
									)
								)		
							else std_logic_vector(to_signed(to_integer(signed(IR(9 downto 3))), 12)) when 
								(
									Cycle.c0 and TestBit and (DS.OpBRBC or DS.OpBRBS)
								)
							else std_logic_vector(to_signed(1, ProgramOffsetWidth));

								
	PmaCtrl.UseCurrent	<=	(
								Cycle.c0 and
								(
									InInt
								)
							)
							or
							(
								Cycle.c1 and
								(
									InInt
								)
							);
				
				
	PmaCtrl.AdjRet(0)	<=  (
								DS.OpCALL
							);
	
	
	PmaCtrl.LpmRead		<= 	(	
								Cycle.c0 and
								(
									DS.OpLPM
									or DS.OpLPMZ
									or DS.OpLPMZI
								)
							)
							or
							(
								Cycle.c1 and
								(
									DS.OpLPM
									or DS.OpLPMZ
									or DS.OpLPMZI
								)
							);
	
	

	PmaCtrl.LoadDPTR	<=  (
								Cycle.c0 and
								(
									DS.OpLDS
									or DS.OpSTS
								)
							);
	
	
	PmaCtrl.UseZ		<= 	(
								Cycle.c0 and
								(
									DS.OpIJMP
								)
							)
							or
							(
								Cycle.c1 and
								(
									DS.OpICALL
								)
							);
							
	
	PmaCtrl.UseRetVect	<=	(
								Cycle.c3 and
								(
									DS.OpRET
									or DS.OpRETI
								)
							);

							
	PmaCtrl.UseImmVect	<= (
								Cycle.c1 and 
								(
									DS.OpJMP
								)
							)
							or
							(
								Cycle.c2 and
								(
									DS.OpCALL
								)
							);
					
					
	PmaCtrl.UseIntVect	<=	(
								Cycle.c2 and
								(
									InInt
								)
							);
							
end architecture;