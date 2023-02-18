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

entity AluControl is

	port
	(
		DS			: in	DecoderOutRec;
		Cycle		: in	CycleOutRec;
		IR			: in	OpcodeWord;
		InInt		: in	std_logic;
		AluCtrl		: out	AluCtrlRec
	);

end entity;

architecture RTL of AluControl is

	signal BitMask	: DataWord;
	signal IntClr	: std_logic;
	signal IntSet	: std_logic;
	
	alias FlagC		: std_logic is AluCtrl.StatusMask(0); 
	alias FlagZ		: std_logic is AluCtrl.StatusMask(1); 
	alias FlagN		: std_logic is AluCtrl.StatusMask(2); 
	alias FlagV		: std_logic is AluCtrl.StatusMask(3); 
	alias FlagS		: std_logic is AluCtrl.StatusMask(4); 
	alias FlagH		: std_logic is AluCtrl.StatusMask(5); 
	alias FlagT		: std_logic is AluCtrl.StatusMask(6); 
	alias FlagI		: std_logic is AluCtrl.StatusMask(7); 

begin
	
	IntSet				<= 	(
								Cycle.c3 and 
								(
									DS.OpRETI
								)
							);

	
	IntClr				<= 	(
								Cycle.c0 and 
								(
									InInt
								)
							);
	
	
	AluCtrl.BitOp		<=	(
								DS.OpBLD
								or DS.OpBST
							);
							

	AluCtrl.BitClrSet	<= 	(
								IntSet
								or DS.OpBSET
							);
							

	AluCtrl.Zmod		<= 	(
								DS.OpCPC
								or DS.OpSBC
								or DS.OpSBCI
							)
							or
							(
								Cycle.c1 and
								(
									DS.OpADIW
									or DS.OpMUL
									or DS.OpSBIW
								)
							);
							

	AluCtrl.Op2Sel		<= 	(
								IntClr
								or IntSet
								or DS.OpADIW
								or DS.OpANDI
								or DS.OpBCLR
								or DS.OpBLD
								or DS.OPBSET
								or DS.OpBST
								or DS.OpCPI
								or DS.OpORI
								or DS.OpDEC
								or DS.OpINC
								or DS.OpSBCI
								or DS.OpSBIW
								or DS.OpSUBI
							)
							or
							(
								Cycle.c0 and
								(
									DS.OpSBRC
									or DS.OpSBRS
								)
							);
	
	
	AluCtrl.BitChange	<= 	(
								IntClr
								or IntSet
								or DS.OpBCLR
								or DS.OpBSET
								or DS.OpBST
							);
	
	
	FlagC				<=	(
								DS.OpMUL
								or DS.OpADIW
								or DS.OpASR
								or DS.OpCOM
								or DS.OpLSR				
								or DS.OpROR
								or DS.OpSBIW
								or DS.OpADC
								or DS.OpADD
								or DS.OpCP
								or DS.OpCPC 
								or DS.OpCPI
								or DS.OpNEG
								or DS.OpSBC
								or DS.OpSBCI
								or DS.OpSUB
								or DS.OpSUBI
								or DS.OpSBIW
							)
							or 
							(
								not InInt and not IR(2) and not IR(1) and not IR(0) and	-- 000
								(
									DS.OpBST or DS.OpBLD							
								)
							)
							or 
							(
								not InInt and not IR(6) and not IR(5) and not IR(4) and	-- 000
								(
									DS.OpBCLR or DS.OpBSET								
								)
							);
	
	
	FlagZ				<=	(
								DS.OpMUL
								or DS.OpAND
								or DS.OpANDI
								or DS.OpDEC
								or DS.OpEOR
								or DS.OpINC
								or DS.OpOR
								or DS.OpORI
								or DS.OpADIW
								or DS.OpASR
								or DS.OpCOM
								or DS.OpLSR				
								or DS.OpROR
								or DS.OpSBIW
								or DS.OpADC
								or DS.OpADD
								or DS.OpCP
								or DS.OpCPC 
								or DS.OpCPI
								or DS.OpSBC
								or DS.OpNEG
								or DS.OpSBCI
								or DS.OpSUB
								or DS.OpSUBI
								or DS.OpSBIW
							)
							or 
							(
								not InInt and not IR(2) and not IR(1) and IR(0) and	-- 001
								(
									DS.OpBST or DS.OpBLD							
								)
							)
							or 
							(
								not InInt and not IR(6) and not IR(5) and IR(4) and	-- 001
								(
									DS.OpBCLR or DS.OpBSET								
								)
							);
	
	
	FlagN				<=	(
								DS.OpAND
								or DS.OpANDI
								or DS.OpDEC
								or DS.OpEOR
								or DS.OpINC
								or DS.OpOR
								or DS.OpORI
								or DS.OpADIW
								or DS.OpASR
								or DS.OpCOM
								or DS.OpLSR				
								or DS.OpROR
								or DS.OpSBIW
								or DS.OpADC
								or DS.OpADD
								or DS.OpCP
								or DS.OpCPC 
								or DS.OpCPI
								or DS.OpNEG
								or DS.OpSBC
								or DS.OpSBCI
								or DS.OpSUB
								or DS.OpSUBI
								or DS.OpSBIW
							)
							or 
							(
								not InInt and not IR(2) and IR(1) and not IR(0) and	--010
								(
									DS.OpBST or DS.OpBLD							
								)
							)
							or 
							(
								not InInt and not IR(6) and IR(5) and not IR(4) and	--010
								(
									DS.OpBCLR or DS.OpBSET								
								)
							);
	
	
	FlagV				<=	(
								DS.OpAND
								or DS.OpANDI
								or DS.OpDEC
								or DS.OpEOR
								or DS.OpINC
								or DS.OpOR
								or DS.OpORI
								or DS.OpADIW
								or DS.OpASR
								or DS.OpCOM
								or DS.OpLSR				
								or DS.OpROR
								or DS.OpADC
								or DS.OpSBIW
								or DS.OpADD
								or DS.OpCP
								or DS.OpCPC 
								or DS.OpCPI
								or DS.OpNEG
								or DS.OpSBC
								or DS.OpSBCI
								or DS.OpSUB
								or DS.OpSBIW
								or DS.OpSUBI
							)
							or 
							(
								not InInt and not IR(2) and IR(1) and IR(0) and	-- 011
								(
									DS.OpBST or DS.OpBLD							
								)
							)
							or 
							(
								not InInt and not IR(6) and IR(5) and IR(4) and	-- 011
								(
									DS.OpBCLR or DS.OpBSET								
								)
							);
	
	
	FlagS				<=	(
								DS.OpAND
								or DS.OpANDI
								or DS.OpDEC
								or DS.OpEOR
								or DS.OpINC
								or DS.OpOR
								or DS.OpORI
								or DS.OpADIW
								or DS.OpASR
								or DS.OpROR
								or DS.OpLSR				
								or DS.OpCOM
								or DS.OpADC
								or DS.OpADD
								or DS.OpSBIW
								or DS.OpCP
								or DS.OpCPC 
								or DS.OpCPI
								or DS.OpNEG
								or DS.OpSBC
								or DS.OpSBCI
								or DS.OpSUB
								or DS.OpSUBI
								or DS.OpSBIW
							)
							or 
							(
								not InInt and IR(2) and not IR(1) and not IR(0) and	--100
								(
									DS.OpBST or DS.OpBLD							
								)
							)
							or 
							(
								not InInt and IR(6) and not IR(5) and not IR(4) and	--100
								(
									DS.OpBCLR or DS.OpBSET								
								)
							);
	

	FlagH				<=	(
								DS.OpADC
								or DS.OpADD
								or DS.OpCP
								or DS.OpCPC 
								or DS.OpCPI
								or DS.OpNEG
								or DS.OpSBC
								or DS.OpSBCI
								or DS.OpSUB
								or DS.OpSUBI
							)
							or 
							(
								not InInt and IR(2) and not IR(1) and IR(0) and	--101
								(
									DS.OpBST or DS.OpBLD							
								)
							)
							or 
							(
								not InInt and IR(6) and not IR(5) and IR(4) and	--101
								(
									DS.OpBCLR or DS.OpBSET								
								)
							);
	

	FlagT				<=	(
								not InInt and IR(2) and IR(1) and not IR(0) and	-- 110
								(
									DS.OpBST or DS.OpBLD							
								)
							)
							or
							(
								not InInt and IR(6) and IR(5) and not IR(4) and	-- 110
								(
									DS.OpBCLR or DS.OpBSET								
								)
							);

	
	FlagI				<=	(
								IntClr
								or IntSet
							)
							or 
							(
								not InInt and IR(2) and IR(1) and IR(0) and	--111
								(
									DS.OpBST or DS.OpBLD							
								)
							)
							or 
							(
								not InInt and IR(6) and IR(5) and IR(4) and	--111
								(
									DS.OpBCLR or DS.OpBSET								
								)
							);
								
							
	AluCtrl.InstADD			<=	(
									DS.OpADD
									or DS.OpINC
								)
								or
								(
									Cycle.c0 and
									(
										DS.OpADIW
									)
								);
								
								
	AluCtrl.InstADC			<= 	(
									DS.OpADC
								)
								or
								(
									Cycle.c1 and
									(
										DS.OpADIW
									)
								);
								
								
	AluCtrl.InstSUB			<= 	(
									DS.OpCP
									or DS.OpCPI
									or DS.OpDEC
									or DS.OpSUB 
									or DS.OpSUBI
								)
								or
								(
									Cycle.c0 and
									(
										DS.OpCPSE
										or DS.OpSBIW
									)
								);
								
								
	AluCtrl.InstSBC			<= 	(
									DS.OpCPC
									or DS.OpSBC
									or DS.OpSBCI
								)
								or
								(
									Cycle.c1 and
									(
										DS.OpSBIW
									)
								);
								
								
	AluCtrl.InstNEG			<= 	(
									DS.OpNEG
								);
								
	
	AluCtrl.InstAND 		<= 	(
									DS.OpAND 
									or DS.OpANDI
								);
								
								
	AluCtrl.InstCOM			<= 	(
									DS.OpCOM
								);
								
								
	AluCtrl.InstEOR			<= 	(
									DS.OpEOR
								);
								
								
	AluCtrl.InstOR			<= 	(
									IntClr
									or IntSet
									or DS.OpBCLR
									or DS.OpBSET
									or DS.OpOR 
									or DS.OpORI
									or DS.OpBLD
									or DS.OpBST
								)
								or
								(
									Cycle.c0 and
									(
										DS.OpSBRC
										or DS.OpSBRS
									)
								);

								
	AluCtrl.InstSWAP		<=	(
									DS.OpSWAP
								);

								
	AluCtrl.InstLSR			<=	(
									DS.OpLSR
								);
								
								
	AluCtrl.InstASR			<=	(
									DS.OpASR
								);
								
								
	AluCtrl.InstROR			<=	(
									DS.OpROR
								);
								
								
	AluCtrl.InstMUL			<=	(
									DS.OpMUL
								);
								
	AluCtrl.MulHigh			<=	(
									Cycle.c1 and
									(
										DS.OpMUL
									)
								);
												
end architecture;