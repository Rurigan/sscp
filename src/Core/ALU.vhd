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

entity ArithmeticLogicUnit is

	port
	(
		SysCtrl			: in	SystemCtrlRec;
		AluCtrl			: in	AluCtrlRec;
		RegOut			: in	RegOutRec;
		Immediate		: in 	DataWord;
		AluOut			: out	AluOutRec;		
		SetSREG			: in	std_logic
	);

end entity;

architecture RTL of ArithmeticLogicUnit is

	signal AbResult	: DataWord;
	signal AbStatus	: DataWord;

	alias  FlagC	: std_logic is AluOut.STATUS(0); 
	alias  FlagZ	: std_logic is AluOut.STATUS(1); 
	alias  FlagN	: std_logic is AluOut.STATUS(2); 
	alias  FlagV	: std_logic is AluOut.STATUS(3); 
	alias  FlagS	: std_logic is AluOut.STATUS(4); 
	alias  FlagH	: std_logic is AluOut.STATUS(5); 
	alias  FlagT	: std_logic is AluOut.STATUS(6); 
	alias  FlagI	: std_logic is AluOut.STATUS(7); 
	
	alias  MaskC	: std_logic is AluCtrl.StatusMask(0); 
	alias  MaskZ	: std_logic is AluCtrl.StatusMask(1); 
	alias  MaskN	: std_logic is AluCtrl.StatusMask(2); 
	alias  MaskV	: std_logic is AluCtrl.StatusMask(3); 
	alias  MaskS	: std_logic is AluCtrl.StatusMask(4); 
	alias  MaskH	: std_logic is AluCtrl.StatusMask(5); 
	alias  MaskT	: std_logic is AluCtrl.StatusMask(6); 
	alias  MaskI	: std_logic is AluCtrl.StatusMask(7); 
	
	signal opB		: DataWord;

	signal NewRes	: DataWord;
	signal NewH		: std_logic;
	signal NewV		: std_logic;
	signal NewC		: std_logic;
	
	signal addRes	: DataWord;
    signal addH 	: std_logic;
    signal addV 	: std_logic;
    signal addC		: std_logic;
	
	signal logRes	: DataWord;
	
	signal sftRes	: DataWord;
    signal sftV 	: std_logic;
    signal sftC		: std_logic;
	
	signal mulRes	: DataWord;
    signal mulC		: std_logic;
		
	signal TmpRes	: DataWord;
	signal TmpStat	: DataWord;
	alias  TmpC		: std_logic is TmpStat(0); 
	alias  TmpZ		: std_logic is TmpStat(1); 
	alias  TmpN		: std_logic is TmpStat(2); 
	alias  TmpV		: std_logic is TmpStat(3); 
	alias  TmpS		: std_logic is TmpStat(4); 
	alias  TmpH		: std_logic is TmpStat(5); 
	alias  TmpT		: std_logic is TmpStat(6); 
	alias  TmpI		: std_logic is TmpStat(7); 
	
	signal SaveStat	: DataWord;
	alias  SaveC	: std_logic is SaveStat(0);
	alias  SaveZ	: std_logic is SaveStat(1);
	alias  SaveT	: std_logic is SaveStat(6);

begin
	AluOut.RESULT 	<= TmpRes;
	AluOut.STATUS 	<= SaveStat;
	
	opB		<= Immediate when AluCtrl.Op2Sel else RegOut.B;
	

	NewRes	<= LogRes when 
						(
							AluCtrl.InstAND
							or AluCtrl.InstCOM
							or AluCtrl.InstEOR
							or AluCtrl.InstOR
						)
					else sftRes when
						(
							AluCtrl.InstSWAP
							or ALuCtrl.InstLSR
							or AluCtrl.InstASR
							or AluCtrl.InstROR
						)
					else mulRes when
						(
							AluCtrl.InstMUL
						)
					else addRes;
					
					
	NewH	<= addH when 
						(
							AluCtrl.InstADD
							or AluCtrl.InstADC
							or AluCtrl.InstSUB
							or AluCtrl.InstSBC
							or AluCtrl.InstNEG
						)
					else '0';
					
					
	NewV	<= addV when 
						(
							AluCtrl.InstADD
							or AluCtrl.InstADC
							or AluCtrl.InstSUB
							or AluCtrl.InstSBC
							or AluCtrl.InstNEG
						)
					else sftV when
						(
							AluCtrl.InstLSR
							or AluCtrl.InstASR
							or AluCtrl.InstROR
						)
					else '0';
	
					
	NewC	<= addC when 
						(
							AluCtrl.InstADD
							or AluCtrl.InstADC
							or AluCtrl.InstSUB
							or AluCtrl.InstSBC
							or AluCtrl.InstNEG
						)
					else '1' when
						(
							AluCtrl.InstCOM
						)
					else sftC when
						(
							AluCtrl.InstLSR
							or AluCtrl.InstASR
							or AluCtrl.InstROR
						)
					else mulC when
						(
							AluCtrl.InstMUL
						)
					else '0';

					
	CPS : process(SysCtrl.Clock) begin
	
        if rising_edge(SysCtrl.Clock) then
		
            SaveStat <= TmpStat;
			
        end if;
		
    end process;
	
	
	STA : process(AluCtrl, RegOut, AluOut, TmpRes, NewRes, TmpStat, SaveStat, NewC, NewV, NewH, SetSREG) begin
	
		TmpStat <= SaveStat;
		TmpRes	<= NewRes;
	
		if SetSREG then
		
			TmpStat <= RegOut.A;
	
		elsif not (AluCtrl.BitOp or AluCtrl.BitChange) then
	
            if MaskC then
               
				TmpC <= NewC;
			   
            else
			
				TmpC <= FlagC;
				
            end if;
		
            if MaskZ then
			
                if ((AluCtrl.Zmod = '0') or (SaveZ = '1')) and (TmpRes = std_logic_vector(to_unsigned(0, TmpRes'length))) then
				
                    TmpZ <= '1';
					
                else
				
                    TmpZ <= '0';
					
                end if;
				
            else
			
                TmpZ <= FlagZ;
				
            end if;
		
            if MaskN then
			
                TmpN <= TmpRes(TmpRes'length - 1);
				
            else
			
                TmpN <= FlagN;
				
            end if;
            
            if MaskV then
			
                TmpV <= NewV;
				
            else
			
                TmpV <= FlagV;
				
            end if;
            
            if MaskS then
			
                TmpS <= TmpRes(TmpRes'length - 1) xor NewV;
				
            else
			
                TmpS <= FlagS;
				
            end if;
            

            if MaskH then
			
                TmpH <= NewH;
				
            else
			
                TmpH <= FlagH;
				
            end if;
			
		elsif AluCtrl.BitOp then
		
            if AluCtrl.BitChange then
			
                if ((TmpRes AND ALuctrl.StatusMask) = std_logic_vector(to_unsigned(0, TmpRes'length))) then
				
                    TmpT <= '0';
					
                else
				
                    TmpT <= '1';
					
                end if;
				
            else
			
                if SaveT then
				
                    TmpRes <= NewRes OR AluCtrl.StatusMask;
					
                else
				
                    TmpRes <= NewRes AND (not AluCtrl.StatusMask);
					
                end if;

            end if;			
		
		else
		
            if AluCtrl.BitClrSet then
			
				TmpStat <= AluOut.STATUS or AluCtrl.StatusMask;

			else

                TmpStat <= AluOut.STATUS AND (not AluCtrl.StatusMask);
				
            end if;
		
		end if;
	
	end process;
	
	
	MULBLK : component AluMulBlock

		port map
		(
			InstMUL		=>	AluCtrl.InstMUL,
			MulHigh		=>	AluCtrl.MulHigh,
			A			=>	RegOut.A,
			B			=>	opB,
			oC			=>	mulC,
			result		=>	mulRes
		);
		

	SFTBLK : component AluShiftBlock

		port map
		(
			InstSWAP	=>	AluCtrl.InstSWAP,
			InstLSR		=>	AluCtrl.InstLSR,
			InstASR		=>  AluCtrl.InstASR,
			InstROR		=>  AluCtrl.InstROR,
			A			=>	RegOut.A,
			iC			=>	SaveC,                   
			oV			=>	sftV,
			oC			=>	sftC,
			result		=>	sftRes
		);
	
	
	LOGBLK : component LogicBlock

		port map
		(
			InstAND		=>	AluCtrl.InstAND,
			InstCOM		=>	AluCtrl.InstCOM,
			InstEOR		=>	AluCtrl.InstEOR,
			InstOR		=>	AluCtrl.InstOR,
			A			=>	RegOut.A,
			B			=>	opB,
			result		=>	LogRes
		);
				
					
	ADDBLK : component AluAddBlock
	
		port map
		(
			InstADD		=>	AluCtrl.InstADD,
			InstADC		=>	AluCtrl.InstADC,
			InstSUB		=>	AluCtrl.InstSUB,
			InstSBC		=>	AluCtrl.InstSBC,
			InstNEG		=>	AluCtrl.InstNEG,
			A			=>	RegOut.A,
			B			=>	opB,
			iC			=>	SaveC,
			oH			=>	addH,
			oV			=>	addV,
			oC			=>	addC,
			result		=>	addRes
		);

end architecture;
