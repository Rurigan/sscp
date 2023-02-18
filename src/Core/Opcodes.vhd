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

use work.CoreTypes.OpcodeWord;

package Opcodes is


--  ALU opcodes

   constant OpADC    :  OpcodeWord := "000111----------";   -- ADC Rd, Rr
   constant OpADD    :  OpcodeWord := "000011----------";   -- ADD Rd, Rr
   constant OpADIW   :  OpcodeWord := "10010110--------";   -- ADIW Rdl, K
   constant OpAND    :  OpcodeWord := "001000----------";   -- AND Rd, Rr
   constant OpANDI   :  OpcodeWord := "0111------------";   -- ANDI Rd, K
   constant OpASR    :  OpcodeWord := "1001010-----0101";   -- ASR Rd
   constant OpBCLR   :  OpcodeWord := "100101001---1000";   -- BCLR s
   constant OpBLD    :  OpcodeWord := "1111100-----0---";   -- BLD Rd, b
   constant OpBSET   :  OpcodeWord := "100101000---1000";   -- BSET s
   constant OpBST    :  OpcodeWord := "1111101---------";   -- BST Rr, b
   constant OpCOM    :  OpcodeWord := "1001010-----0000";   -- COM Rd
   constant OpCP     :  OpcodeWord := "000101----------";   -- CP Rd, Rr
   constant OpCPC    :  OpcodeWord := "000001----------";   -- CPC Rd, Rr
   constant OpCPI    :  OpcodeWord := "0011------------";   -- CPI Rd, K
   constant OpDEC    :  OpcodeWord := "1001010-----1010";   -- DEC Rd
   constant OpEOR    :  OpcodeWord := "001001----------";   -- EOR Rd, Rr
   constant OpFMUL   :  OpcodeWord := "000000110---1---";   -- FMUL Rd, Rr
   constant OpFMULS  :  OpcodeWord := "000000111---0---";   -- FMULS Rd, Rr
   constant OpFMULSU :  OpcodeWord := "000000111---1---";   -- FMULSU Rd, Rr
   constant OpINC    :  OpcodeWord := "1001010-----0011";   -- INC Rd
   constant OpLSR    :  OpcodeWord := "1001010-----0110";   -- LSR Rd
   constant OpMUL    :  OpcodeWord := "100111----------";   -- MUL Rd, Rr
   constant OpMULS   :  OpcodeWord := "00000010--------";   -- MULS Rd, Rr
   constant OpMULSU  :  OpcodeWord := "000000110---0---";   -- MULSU Rd, Rr
   constant OpNEG    :  OpcodeWord := "1001010-----0001";   -- NEG Rd
   constant OpOR     :  OpcodeWord := "001010----------";   -- OR Rd, Rr
   constant OpORI    :  OpcodeWord := "0110------------";   -- ORI Rd, K
   constant OpROR    :  OpcodeWord := "1001010-----0111";   -- ROR Rd
   constant OpSBC    :  OpcodeWord := "000010----------";   -- SBC Rd, Rr
   constant OpSBCI   :  OpcodeWord := "0100------------";   -- SBCI Rd, K
   constant OpSBIW   :  OpcodeWord := "10010111--------";   -- SBIW Rdl, K
   constant OpSUB    :  OpcodeWord := "000110----------";   -- SUB Rd, Rr
   constant OpSUBI   :  OpcodeWord := "0101------------";   -- SUBI Rd, K
   constant OpSWAP   :  OpcodeWord := "1001010-----0010";   -- SWAP Rd

--  Load and Store Opcodes

   constant OpELPM   :  OpcodeWord := "1001010111011000";   -- ELPM
   constant OpELPMZ  :  OpcodeWord := "1001000-----0110";   -- ELPM Rd, Z
   constant OpELPMZI :  OpcodeWord := "1001000-----0111";   -- ELPM Rd, Z+
   constant OpLDX    :  OpcodeWord := "1001000-----1100";   -- LD Rd, X
   constant OpLDXI   :  OpcodeWord := "1001000-----1101";   -- LD Rd, X+
   constant OpLDXD   :  OpcodeWord := "1001000-----1110";   -- LD Rd, -X
   constant OpLDYI   :  OpcodeWord := "1001000-----1001";   -- LD Rd, Y+
   constant OpLDYD   :  OpcodeWord := "1001000-----1010";   -- LD Rd, -Y
   constant OpLDDY   :  OpcodeWord := "10-0--0-----1---";   -- LDD Rd, Y + q
   constant OpLDZI   :  OpcodeWord := "1001000-----0001";   -- LD Rd, Z+
   constant OpLDZD   :  OpcodeWord := "1001000-----0010";   -- LD Rd, -Z
   constant OpLDDZ   :  OpcodeWord := "10-0--0-----0---";   -- LDD Rd, Z + q
   constant OpLDI    :  OpcodeWord := "1110------------";   -- LDI Rd, k
   constant OpLDS    :  OpcodeWord := "1001000-----0000";   -- LDS Rd, m
   constant OpLPM    :  OpcodeWord := "1001010111001000";   -- LPM
   constant OpLPMZ   :  OpcodeWord := "1001000-----0100";   -- LPM Rd, Z
   constant OpLPMZI  :  OpcodeWord := "1001000-----0101";   -- LPM Rd, Z+
   constant OpMOV    :  OpcodeWord := "001011----------";   -- MOV Rd, Rr
   constant OpMOVW   :  OpcodeWord := "00000001--------";   -- MOVW Rd, Rr
   constant OpSPM    :  OpcodeWord := "1001010111101000";   -- SPM
   constant OpSTX    :  OpcodeWord := "1001001-----1100";   -- ST X, Rr
   constant OpSTXI   :  OpcodeWord := "1001001-----1101";   -- ST X+, Rr
   constant OpSTXD   :  OpcodeWord := "1001001-----1110";   -- ST -X, Rr
   constant OpSTYI   :  OpcodeWord := "1001001-----1001";   -- ST Y+, Rr
   constant OpSTYD   :  OpcodeWord := "1001001-----1010";   -- ST -Y, Rr
   constant OpSTDY   :  OpcodeWord := "10-0--1-----1---";   -- STD Y + q, Rr
   constant OpSTZI   :  OpcodeWord := "1001001-----0001";   -- ST Z+, Rr
   constant OpSTZD   :  OpcodeWord := "1001001-----0010";   -- ST -Z, Rr
   constant OpSTDZ   :  OpcodeWord := "10-0--1-----0---";   -- STD Z + q, Rr
   constant OpSTS    :  OpcodeWord := "1001001-----0000";   -- STS m, Rr

--  Push and Pop Opcodes

   constant OpPOP    :  OpcodeWord := "1001000-----1111";   -- POP Rd
   constant OpPUSH   :  OpcodeWord := "1001001-----1111";   -- PUSH Rd

--  Unconditional Branches

   constant OpEICALL :  OpcodeWord := "1001010100011001";   -- EICALL
   constant OpEIJMP  :  OpcodeWord := "1001010000011001";   -- EIJMP
   constant OpJMP    :  OpcodeWord := "1001010-----110-";   -- JMP a
   constant OpRJMP   :  OpcodeWord := "1100------------";   -- RJMP j
   constant OpIJMP   :  OpcodeWord := "1001010000001001";   -- IJMP
   constant OpCALL   :  OpcodeWord := "1001010-----111-";   -- CALL a
   constant OpRCALL  :  OpcodeWord := "1101------------";   -- RCALL j
   constant OpICALL  :  OpcodeWord := "1001010100001001";   -- ICALL
   constant OpRET    :  OpcodeWord := "1001010100001000";   -- RET
   constant OpRETI   :  OpcodeWord := "1001010100011000";   -- RETI

--  Conditional Branches

   constant OpBRBC   :  OpcodeWord := "111101----------";   -- BRBC s, r
   constant OpBRBS   :  OpcodeWord := "111100----------";   -- BRBS s, r

--  Skip Instructions

   constant OpCPSE   :  OpcodeWord := "000100----------";   -- CPSE Rd, Rr
   constant OpSBIC   :  OpcodeWord := "10011001--------";   -- SBIC p, b
   constant OpSBIS   :  OpcodeWord := "10011011--------";   -- SBIS p, b
   constant OpSBRC   :  OpcodeWord := "1111110---------";   -- SBRC Rr, b
   constant OpSBRS   :  OpcodeWord := "1111111---------";   -- SBRS Rr, b

--  I/O Instructions

   constant OpCBI    :  OpcodeWord := "10011000--------";   -- CBI p, b
   constant OpIN     :  OpcodeWord := "10110-----------";   -- IN Rd, p
   constant OpOUT    :  OpcodeWord := "10111-----------";   -- OUT p, Rr
   constant OpSBI    :  OpcodeWord := "10011010--------";   -- SBI p, b

--  Miscellaneous Instructions

   constant OpBREAK  :  OpcodeWord := "1001010110011000";   -- BREAK
   constant OpNOP    :  OpcodeWord := "0000000000000000";   -- NOP
   constant OpSLP    :  OpcodeWord := "10010101100-1000";   -- SLEEP
   constant OpWDR    :  OpcodeWord := "10010101101-1000";   -- WDR 


end package;
