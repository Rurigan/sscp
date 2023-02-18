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

entity Sequncer is

	port
	(
		SysCtrl			: in 		SystemCtrlRec;
		RegOut			: in		RegOutRec;
		PmaOut			: in		PmaOutRec;
		DmaOut			: in		DmaOutRec;
		IoaOut			: in		IoaOutRec;
		AluOut			: in		AluOutRec;
		IntReq			: in		std_logic;
		IoaCtrl			: out		IoaCtrlRec;
		RegCtrl			: out		RegCtrlRec;
		PmaCtrl			: out		PmaCtrlRec;
		DmaCtrl			: out		DmaCtrlRec;
		AluCtrl			: out		AluCtrlRec;
		ValidInstr		: out		std_logic;
		NewInstr		: buffer	std_logic
	);

end entity;

architecture RTL of Sequncer is

	signal CycleRec		: CycleOutRec;
	signal DecoderRec	: DecoderOutRec;
	signal InInt		: std_logic;
	signal IoSkip		: std_logic;
	signal IntAck		: std_logic;
	
begin

	ValidInstr	<= DecoderRec.Valid;
	NewInstr	<= PmaCtrl.NewInstr;
	
	
	INTCTL : component IntControl

		port map
		(
			SysCtrl			=>	SysCtrl,
			Cycle			=>	CycleRec,
			NewInstr		=>	NewInstr,
			IntReq			=>	IntReq,
			IntAllowed		=>	ALuOut.STATUS(7),
			IntAck			=>	IntAck,
			InInt			=>	InInt
		);
	
	
	REGCTL : component RegControl

		port map
		(
			DS				=>	DecoderRec,
			Cycle			=>	CycleRec,
			IR				=> 	PmaOut.IR,
			InInt			=>	InInt,
			RegCtrl			=>	RegCtrl
		);



	PMACTL : component PmaControl

		port map
		(
			DS				=>	DecoderRec,
			Cycle			=>	CycleRec,	
			InInt			=>	InInt,
			IR				=>	PmaOut.IR,
			NextIsTw		=>	PmaOut.NextIsTw,
			IoSkip			=>	IoSkip,
			ALuOut			=> 	AluOut,
			PmaCtrl			=>	PmaCtrl
		);


	IOACTL : component IoaControl

		port map
		(
			DS				=>	DecoderRec,
			Cycle			=>	CycleRec,
			IR				=> 	PmaOut.IR,
			IoBit			=>  IoaOut.BitData,
			IntAck			=>	IntAck,
			IoaCtrl			=>	IoaCtrl,
			IoSkip			=>	IoSkip
		);

		
	ALUCTL : component AluControl

		port map
		(
			DS				=>	DecoderRec,
			Cycle			=>	CycleRec,
			IR				=> 	PmaOut.IR,
			InInt			=>	InInt,
			AluCtrl			=>	AluCtrl
		);


	DMACTL : component DmaControl

		port map
		(
			DS				=>	DecoderRec,
			Cycle			=>	CycleRec,
			InInt			=>	InInt,
			IR				=> 	PmaOut.IR,			
			DmaCtrl			=>	DmaCtrl
		);


	DEC : component Decoder

		port map
		(
			IR				=>	PmaOut.IR,
			Disable			=>	InInt,
			DecoderRec 		=>	DecoderRec
		);

		
	CYL : component Cycler

		port map
		(
			SysCtrl			=> 	SysCtrl,
			NewInstr		=>	NewInstr,
			CycleRec		=> 	CycleRec
		);
	

end architecture;
