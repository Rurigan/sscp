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
use work.Opcodes.all;

entity Decoder is

	port
	(
		IR			: in	OpcodeWord;
		Disable		: in	std_logic;
		DecoderRec 	: out 	DecoderOutRec
	);

end entity;

architecture behav of Decoder is

	signal DS : DecoderOutRec;

begin

	DecoderRec	<= DS;

	
	DS.Valid	<= 	(
						Disable
						or DS.OpADC 
						or DS.OpADD 
						or DS.OpADIW
						or DS.OpAND 
						or DS.OpANDI 
						or DS.OpASR 
						
						or DS.OpBCLR
						or DS.OpBLD
						or DS.OpBRBC 
						or DS.OpBRBS 
						or DS.OpBSET 
						or DS.OpBST
						
						or DS.OpCALL
						or DS.OpCBI
						or DS.OpCOM 
						or DS.OpCP
						or DS.OpCPC 
						or DS.OpCPI 
						or DS.OpCPSE	
						
						or DS.OpDEC					
						
						or DS.OpEOR 
					
						or DS.OpICALL
						or DS.OpIJMP
						or DS.OpIN 
						or DS.OpINC 
						
						or DS.OpJMP
						
						or DS.OpLDDY 
						or DS.OpLDDZ 
						or DS.OpLDI
						or DS.OpLDS
						or DS.OpLDX
						or DS.OpLDXD
						or DS.OpLDXI
						or DS.OpLDYD
						or DS.OpLDYI
						or DS.OpLDZD
						or DS.OpLDZI
						or DS.OpLPM
						or DS.OpLPMZ
						or DS.OpLPMZI 
						or DS.OpLSR
						
						or DS.OpMOV
						or DS.OpMOVW 
						or DS.OpMUL 
						
						or DS.OpNEG
						or DS.OpNOP
						
						or DS.OpOR
						or DS.OpORI 
						or DS.OpOUT 
						
						or DS.OpPOP 
						or DS.OpPUSH 
						
						or DS.OpRCALL 
						or DS.OpRET
						or DS.OpRETI
						or DS.OpRJMP 
						or DS.OpROR
						
						or DS.OpSBC
						or DS.OpSBCI
						or DS.OpSBI
						or DS.OpSBIC
						or DS.OpSBIS
						or DS.OpSBIW
						or DS.OpSBRC
						or DS.OpSBRS
						or DS.OpSTDY 
						or DS.OpSTDZ
						or DS.OpSTX 
						or DS.OpSTXD 
						or DS.OpSTXI 
						or DS.OpSTYD 
						or DS.OpSTYI 
						or DS.OpSTZD 
						or DS.OpSTZI 
						or DS.OpSTS
						or DS.OpSUB
						or DS.OPSUBI
						or DS.OpSWAP
					);
					
					
	DS.OpADC	<= '1' when std_match(IR, OpADC) 	and (Disable = '0') else '0';
	DS.OpADD	<= '1' when std_match(IR, OpADD)  	and (Disable = '0') else '0';	
	DS.OpADIW	<= '1' when std_match(IR, OpADIW) 	and (Disable = '0') else '0';	
	DS.OpANDI	<= '1' when std_match(IR, OpANDI) 	and (Disable = '0') else '0';
	DS.OpAND	<= '1' when std_match(IR, OpAND)  	and (Disable = '0') else '0';
	DS.OpASR	<= '1' when std_match(IR, OpASR)  	and (Disable = '0') else '0';

	DS.OpBCLR	<= '1' when std_match(IR, OpBCLR) 	and (Disable = '0') else '0';
	DS.OpBLD	<= '1' when std_match(IR, OpBLD)  	and (Disable = '0') else '0';
	DS.OpBRBC	<= '1' when std_match(IR, OpBRBC) 	and (Disable = '0') else '0';
	DS.OpBRBS	<= '1' when std_match(IR, OpBRBS) 	and (Disable = '0') else '0';
	DS.OpBSET	<= '1' when std_match(IR, OpBSET) 	and (Disable = '0') else '0';
	DS.OpBST	<= '1' when std_match(IR, OpBST)  	and (Disable = '0') else '0';
		
	DS.OpCALL	<= '1' when std_match(IR, OpCALL) 	and (Disable = '0') else '0';
	DS.OpCBI	<= '1' when std_match(IR, OpCBI) 	and (Disable = '0') else '0';
	DS.OpCOM	<= '1' when std_match(IR, OpCOM) 	and (Disable = '0') else '0';
	DS.OpCP		<= '1' when std_match(IR, OpCP)   	and (Disable = '0') else '0';
	DS.OpCPC	<= '1' when std_match(IR, OpCPC)  	and (Disable = '0') else '0';
	DS.OpCPI	<= '1' when std_match(IR, OpCPI)  	and (Disable = '0') else '0';
	DS.OpCPSE	<= '1' when std_match(IR, OpCPSE) 	and (Disable = '0') else '0';

	DS.OpDEC	<= '1' when std_match(IR, OpDEC)	and (Disable = '0') else '0';

	DS.OpELPMZI	<= '1' when std_match(IR, OpELPMZI) and (Disable = '0') else '0';
	DS.OpEOR	<= '1' when std_match(IR, OpEOR)  	and (Disable = '0') else '0';
	
	DS.OpICALL	<= '1' when std_match(IR, OpICALL)	and (Disable = '0') else '0';
	DS.OpIJMP	<= '1' when std_match(IR, OpIJMP) 	and (Disable = '0') else '0';
	DS.OpIN		<= '1' when std_match(IR, OpIN)   	and (Disable = '0') else '0';
	DS.OpINC	<= '1' when std_match(IR, OpINC)  	and (Disable = '0') else '0';

	DS.OpJMP	<= '1' when std_match(IR, OpJMP)  	and (Disable = '0') else '0';

	DS.OpLDDY	<= '1' when std_match(IR, OpLDDY) 	and (Disable = '0') else '0';
	DS.OpLDDZ	<= '1' when std_match(IR, OpLDDZ) 	and (Disable = '0') else '0';
	DS.OpLDI	<= '1' when std_match(IR, OpLDI)  	and (Disable = '0') else '0';
	DS.OpLDS	<= '1' when std_match(IR, OpLDS)  	and (Disable = '0') else '0';
	DS.OpLDX	<= '1' when std_match(IR, OpLDX)  	and (Disable = '0') else '0';
	DS.OpLDXD	<= '1' when std_match(IR, OpLDXD) 	and (Disable = '0') else '0';
	DS.OpLDXI	<= '1' when std_match(IR, OpLDXI) 	and (Disable = '0') else '0';
	DS.OpLDYD	<= '1' when std_match(IR, OpLDYD) 	and (Disable = '0') else '0';
	DS.OpLDYI	<= '1' when std_match(IR, OpLDYI) 	and (Disable = '0') else '0';
	DS.OpLDZD	<= '1' when std_match(IR, OpLDZD) 	and (Disable = '0') else '0';
	DS.OpLDZI	<= '1' when std_match(IR, OpLDZI) 	and (Disable = '0') else '0';
	DS.OpLPM	<= '1' when std_match(IR, OpLPM)  	and (Disable = '0') else '0';
	DS.OpLPMZ	<= '1' when std_match(IR, OpLPMZ) 	and (Disable = '0') else '0';
	DS.OpLPMZI	<= '1' when std_match(IR, OpLPMZI)	and (Disable = '0') else '0';
	DS.OpLSR	<= '1' when std_match(IR, OpLSR)  	and (Disable = '0') else '0';

	DS.OpMOV	<= '1' when std_match(IR, OpMOV)  	and (Disable = '0') else '0';
	DS.OpMOVW	<= '1' when std_match(IR, OpMOVW) 	and (Disable = '0') else '0';
	DS.OpMUL	<= '1' when std_match(IR, OpMUL)  	and (Disable = '0') else '0';
	DS.OpMULS	<= '1' when std_match(IR, OpMULS)  	and (Disable = '0') else '0';

	DS.OpNEG 	<= '1' when std_match(IR, OpNEG)  	and (Disable = '0') else '0';
	DS.OpNOP 	<= '1' when std_match(IR, OpNOP)  	and (Disable = '0') else '0';

	DS.OpOR		<= '1' when std_match(IR, OpOR)   	and (Disable = '0') else '0';
	DS.OpORI	<= '1' when std_match(IR, OpORI)  	and (Disable = '0') else '0';
	DS.OpOUT	<= '1' when std_match(IR, OpOUT)  	and (Disable = '0') else '0';

	DS.OpPOP	<= '1' when std_match(IR, OpPOP)  	and (Disable = '0') else '0';
	DS.OpPUSH	<= '1' when std_match(IR, OpPUSH) 	and (Disable = '0') else '0';

	DS.OpRCALL	<= '1' when std_match(IR, OpRCALL)	and (Disable = '0') else '0';
	DS.OpRET	<= '1' when std_match(IR, OpRET)  	and (Disable = '0') else '0';
	DS.OpRETI	<= '1' when std_match(IR, OpRETI) 	and (Disable = '0') else '0';
	DS.OpRJMP	<= '1' when std_match(IR, OpRJMP) 	and (Disable = '0') else '0';
	DS.OpROR	<= '1' when std_match(IR, OpROR)  	and (Disable = '0') else '0';
		
	DS.OpSBC	<= '1' when std_match(IR, OpSBC)  	and (Disable = '0') else '0';
	DS.OpSBCI	<= '1' when std_match(IR, OpSBCI) 	and (Disable = '0') else '0';
	DS.OpSBI	<= '1' when std_match(IR, OpSBI)  	and (Disable = '0') else '0';
	DS.OpSBIC	<= '1' when std_match(IR, OpSBIC) 	and (Disable = '0') else '0';
	DS.OpSBIS	<= '1' when std_match(IR, OpSBIS) 	and (Disable = '0') else '0';
	DS.OpSBIW	<= '1' when std_match(IR, OpSBIW) 	and (Disable = '0') else '0';
	DS.OpSBRC	<= '1' when std_match(IR, OpSBRC) 	and (Disable = '0') else '0';
	DS.OpSBRS	<= '1' when std_match(IR, OpSBRS) 	and (Disable = '0') else '0';
	DS.OpSTDY	<= '1' when std_match(IR, OpSTDY) 	and (Disable = '0') else '0';
	DS.OpSTDZ	<= '1' when std_match(IR, OpSTDZ) 	and (Disable = '0') else '0';
	DS.OpSTX	<= '1' when std_match(IR, OpSTX)  	and (Disable = '0') else '0';
	DS.OpSTXD	<= '1' when std_match(IR, OpSTXD) 	and (Disable = '0') else '0';
	DS.OpSTXI	<= '1' when std_match(IR, OpSTXI) 	and (Disable = '0') else '0';
	DS.OpSTYD	<= '1' when std_match(IR, OpSTYD) 	and (Disable = '0') else '0';
	DS.OpSTYI	<= '1' when std_match(IR, OpSTYI) 	and (Disable = '0') else '0';
	DS.OpSTZD	<= '1' when std_match(IR, OpSTZD) 	and (Disable = '0') else '0';
	DS.OpSTZI	<= '1' when std_match(IR, OpSTZI) 	and (Disable = '0') else '0';
	DS.OpSTS	<= '1' when std_match(IR, OpSTS)  	and (Disable = '0') else '0';
	DS.OpSUB	<= '1' when std_match(IR, OpSUB)  	and (Disable = '0') else '0';
	DS.OpSUBI	<= '1' when std_match(IR, OpSUBI) 	and (Disable = '0') else '0';
	DS.OpSWAP	<= '1' when std_match(IR, OpSWAP) 	and (Disable = '0') else '0';

end architecture;

	