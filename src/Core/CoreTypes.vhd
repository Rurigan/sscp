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

package CoreTypes is	

	-----------------------------------------------------------------------------
	-- IO Addresses																-
	-----------------------------------------------------------------------------

	constant STATUS_REG : unsigned := x"3f";
	constant STACK_PTR	: unsigned := x"3d";
	
	-----------------------------------------------------------------------------
	-- Global types																-
	-----------------------------------------------------------------------------

	constant OpcodeWidth			: integer := 16;
	constant DataWidth				: integer := 8;
	constant ProgramAddrWidth		: integer := 16;
	constant ProgramOffsetWidth		: integer := 12;
	constant IoAddrWidth			: integer := 8;
	constant SRamAddrWidth			: integer := 16;
	constant SRamBankAddrWidth		: integer := 8;
	constant RegisterAddrWidth		: integer := 5;
	constant BitAddrWidth			: integer := 3;
	constant InterruptVectorWidth	: integer := 5;

	subtype	 OpcodeWord  			is std_logic_vector(OpcodeWidth - 1 downto 0);
	subtype	 DataWord				is std_logic_vector(DataWidth - 1 downto 0);
	subtype	 DoubleWord				is std_logic_vector((DataWidth * 2) - 1 downto 0);
	
	subtype	 ProgramAddr			is std_logic_vector(ProgramAddrWidth - 1 downto 0);
	subtype  ProgramOffset			is std_logic_vector(ProgramOffsetWidth -1 downto 0);
	subtype  IoAddr					is std_logic_vector(IoAddrWidth - 1 downto 0);
	subtype	 SRamAddr				is std_logic_vector(SRamAddrWidth - 1 downto 0);
	subtype	 SRamBankAddr			is std_logic_vector(SRamBankAddrWidth - 1 downto 0);
	subtype	 RegisterAddr			is std_logic_vector(RegisterAddrWidth - 1 downto 0);
	subtype  BitAddr				is std_logic_vector(BitAddrWidth - 1 downto 0);
	subtype  InterruptVector		is std_logic_vector(InterruptVectorWidth - 1 downto 0);
	
	-----------------------------------------------------------------------------
	-- Top level types and components											-
	-----------------------------------------------------------------------------
	
	type SystemCtrlRec is record

		Clock			: std_logic;
		nReset			: std_logic;

	end record;
	
	
	type SystemInfoRec is record

		NewInstr		: std_logic;
		ValidInstr		: std_logic;
	
	end record;
	
	
	type PrgMemoryCtrlRec is record
	
		Addr			: ProgramAddr;
	
	end record;
	
	
	type PrgMemoryOutRec is record
	
		Data			: OpcodeWord;
	
	end record;
	
	
	type DataMemoryCtrlRec is record
	
		RD				: std_logic;	
		WR				: std_logic;
		Addr			: SRamAddr;
		Bank			: SRamBankAddr;
		Data			: DataWord;
	
	end record;
	
	
	type DataMemoryOutRec is record
	
		Data			: DataWord;
	
	end record;
	
	
	type IoCtrlRec is record
	
		RD				: std_logic;
		WR				: std_logic;
		BOP				: std_logic;
		Addr			: IoAddr;
		BitAddr			: BitAddr;
		Data			: DataWord;
		BitData			: std_logic;
		IntAck			: std_logic;
		
	end record;
	
	
	type InOutRec is record
	
		Data			: DataWord;
		BitData			: std_logic;
		IntReq			: std_logic;
		IntVect			: InterruptVector;
	
	end record;
	
	
	component ProcessorUnit is

		generic 
		(
			ProgramFile : string := "(none)"
		);

		port
		(
			SysCtrl		: in	SystemCtrlRec;
			SysInfo		: out	SystemInfoRec;
			FromIo		: in	InOutRec;
			ToIo		: out	IoCtrlRec
		);

	end component;	

	
	component CentralProcessingUnit is

		port
		(
			SysCtrl		: in	SystemCtrlRec;
			SysInfo		: out	SystemInfoRec;
			FromPrgMem	: in 	PrgMemoryOutRec;
			FromDataMem	: in 	DataMemoryOutRec;
			FromIo		: in	InOutRec;
			ToPrgMem	: out 	PrgMemoryCtrlRec;
			ToDataMem	: out 	DataMemoryCtrlRec;
			ToIo		: out	IoCtrlRec
		);

	end component;	

	
	component ProcessorMemory is

		generic 
		(
				ProgramFile : string := "(none)"
		);

		port
		(
			SysCtrl		: in	SystemCtrlRec;
			ToPrgMem	: in 	PrgMemoryCtrlRec;
			ToDataMem	: in 	DataMemoryCtrlRec;
			FromPrgMem	: out 	PrgMemoryOutRec;
			FromDataMem	: out	DataMemoryOutRec
		);

	end component;	
	
	
	component DataMemory is

		port
		(
			SysCtrl		: in	SystemCtrlRec;
			FromCpu		: in  	DataMemoryCtrlRec;
			ToCpu		: out 	DataMemoryOutRec
		);

	end component;	
	
	
	component ProgramMemory is

		generic 
		(
				InitFile : string := "(none)"
		);

		port
		(
			SysCtrl		: in	SystemCtrlRec;
			FromCpu		: in	PrgMemoryCtrlRec;
			ToCpu		: out	PrgMemoryOutRec
		);

	end component;	
	
	-----------------------------------------------------------------------------
	-- Internal CPU types														-
	-----------------------------------------------------------------------------
	
	type CycleOutRec is record
	
		Count			: std_logic_vector(2 downto 0);
		c0				: std_logic;
		c1				: std_logic;
		c2				: std_logic;
		c3				: std_logic;
		c4				: std_logic;
		
	end record;
	
	
	type DecoderOutRec is record
	
		Valid			: std_logic;
		
		OpADC			: std_logic;
		OpADD			: std_logic;
		OpADIW			: std_logic;
		OpAND			: std_logic;
		OpANDI			: std_logic;
		OpASR			: std_logic;

		OpBCLR			: std_logic;
		OpBLD			: std_logic;
		OpBRBC			: std_logic;
		OpBRBS			: std_logic;
		OpBSET			: std_logic;
		OpBST			: std_logic;
		
		OpCALL			: std_logic;
		OpCBI			: std_logic;
		OpCOM			: std_logic;
		OpCP			: std_logic;
		OpCPI			: std_logic;
		OpCPC			: std_logic;
		OpCPSE			: std_logic;
		
		OpDEC			: std_logic;
		
		OpELPMZI		: std_logic;
		OpEOR			: std_logic;
		
		OpICALL			: std_logic;
		OpIJMP			: std_logic;
		OpIN			: std_logic;
		OpINC			: std_logic;
		
		OpJMP			: std_logic;
		
		OpLDDY			: std_logic;
		OpLDDZ			: std_logic;
		OpLDI			: std_logic;
		OpLDS			: std_logic;
		OPLDX			: std_logic;
		OpLDXD			: std_logic;
		OpLDXI			: std_logic;
		OpLDYD			: std_logic;
		OpLDYI			: std_logic;
		OpLDZD			: std_logic;
		OpLDZI			: std_logic;
		OpLPM			: std_logic;
		OpLPMZ			: std_logic;
		OpLPMZI			: std_logic;
		OpLSR			: std_logic;
		
		OpMOV			: std_logic;
		OpMOVW			: std_logic;
		OpMUL			: std_logic;
		OpMULS			: std_logic;

		OpNEG			: std_logic;
		OpNOP			: std_logic;

		OpOR			: std_logic;
		OpORI			: std_logic;
		OpOUT			: std_logic;

		OpPOP			: std_logic;
		OpPUSH			: std_logic;

		OpRCALL			: std_logic;
		OpRET			: std_logic;
		OpRETI			: std_logic;
		OpRJMP			: std_logic;
		OpROR			: std_logic;
		
		OpSBC			: std_logic;
		OpSBCI			: std_logic;
		OpSBI			: std_logic;
		OpSBIC			: std_logic;
		OpSBIS			: std_logic;
		OpSBIW			: std_logic;
		OpSBRC			: std_logic;
		OpSBRS			: std_logic;
		OpSTDY			: std_logic;
		OpSTDZ			: std_logic;
		OpSTX			: std_logic;
		OpSTXD			: std_logic;
		OpSTXI			: std_logic;
		OpSTYD			: std_logic;
		OpSTYI			: std_logic;
		OpSTZD			: std_logic;
		OpSTZI			: std_logic;
		OpSTS			: std_logic;
		OpSUB			: std_logic;
		OpSUBI			: std_logic;
		OpSWAP			: std_logic;
	
	end record;
	
	
	type AluCtrlRec is record
	
		Op2Sel			: std_logic;
		StatusMask		: DataWord;
		BitChange		: std_logic;
		BitClrSet		: std_logic;
		BitOp			: std_logic;
		Zmod			: std_logic;
		InstADD			: std_logic;
		InstADC			: std_logic;
		InstSUB			: std_logic;
		InstSBC			: std_logic;
		InstNEG			: std_logic;
		InstAND 		: std_logic;
		InstCOM			: std_logic;
		InstEOR			: std_logic;
		InstOR			: std_logic;
		InstSWAP		: std_logic;
		InstLSR			: std_logic;
		InstASR			: std_logic;
		InstROR			: std_logic;
		InstMUL			: std_logic;
		MulHigh			: std_logic;
		
	end record;
	
	
	type AluOutRec is record
	
		RESULT			: DataWord;
		STATUS			: DataWord;
		
	end record;

	
	type PmaCtrlRec is record
	
		NewInstr		: std_logic;
		PcOffset		: ProgramOffset;
		AdjRet			: std_logic_vector(0 downto 0);
		UseCurrent		: std_logic;
		LpmRead			: std_logic;
		LoadDPTR		: std_logic;
		UseZ			: std_logic;
		UseRetVect		: std_logic;
		UseImmVect		: std_logic;
		UseIntvect		: std_logic;
	
	end record;

	
	type PmaOutRec is record
	
		IR				: OpcodeWord;
		PC				: ProgramAddr;
		DPTR			: SRamAddr;
		RetAddr			: ProgramAddr;
		LpmOut			: DataWord;
		NextIsTw		: std_logic;
		
	end record;

	
	type DmaCtrlRec is record
	
		RD				: std_logic;
		WR				: std_logic;	
		AddrOffset		: SRamAddr;
		UseSP			: std_logic;
		UseRetL			: std_logic;
		UseRetH			: std_logic;
		UseX			: std_logic;
		UseY			: std_logic;
		UseZ			: std_logic;
		UseDPTR			: std_logic;

	end record;
	
	
	type DmaOutRec is record
	
		Data			: DataWord;
		
	end record;
	
	
	type DmaToIoaRec is record
	
		RD				: std_logic;
		WR				: std_logic;
		Addr			: IoAddr;
		Data			: DataWord;
	
	end record;
	
	
	type DmaToRegRec is record

		RD				: std_logic;
		WR				: std_logic;
		Addr			: RegisterAddr;	
		Data			: DataWord;
		
	end record;

	
	type IoaCtrlRec is record
	
		RD				: std_logic;
		WR				: std_logic;
		BOP				: std_logic;
		Addr			: IoAddr;
		BitAddr			: BitAddr;
		BitData			: std_logic;
		IntAck			: std_logic;
			
	end record;
	
	
	type IoaOutRec is record
	
		Data			: DataWord;
		BitData			: std_logic;
		
	end record;
	
	
	type IoaToDmaRec is record
	
		Data			: DataWord;
	
	end record;
	
	
	type IoaToRegRec is record
	
		SetSREG			: std_logic;
		SetSPL			: std_logic;
		SetSPH			: std_logic;
		Data			: DataWord;
	
	end record;	

	
	type RegCtrlRec is record
	
		SelIn			: RegisterAddr;
		SelA			: RegisterAddr;
		SelB			: RegisterAddr;
		Immediate		: DataWord;
		EnableIn		: std_logic;
		DecSP			: std_logic;
		IncSP			: std_logic;
		IncX			: std_logic;
		DecX			: std_logic;
		IncY			: std_logic;
		DecY			: std_logic;
		IncZ			: std_logic;
		DecZ			: std_logic;
		UseAkk			: std_logic;
		UseImm			: std_logic;
		LpmIn			: std_logic;
		SetRetL			: std_logic;
		SetRetH			: std_logic;
		IoRD			: std_logic;
		DmaRD			: std_logic;
		CopyPair		: std_logic;
		
	end record;
	
	
	type RegOutRec is record
	
		A			: DataWord;
		B			: DataWord;
		SP			: ProgramAddr;
		X			: SRamAddr;
		Y			: SRamAddr;
		Z			: SRamAddr;
		DMA			: DataWord;
		RET			: ProgramAddr;
		
	end record;

	
	component IntControl is

		port
		(
			SysCtrl			: in 		SystemCtrlRec;
			Cycle			: in		CycleOutRec;
			NewInstr		: in		std_logic;
			IntReq			: in		std_logic;
			IntAllowed		: in		std_logic;
			IntAck			: buffer	std_logic;		
			InInt			: buffer	std_logic
		);

	end component;	

	
	component RegControl is

		port
		(
			DS			: in	DecoderOutRec;
			Cycle		: in	CycleOutRec;
			IR			: in	OpcodeWord;
			InInt		: in	std_logic;
			RegCtrl		: out	RegCtrlRec
		);

	end component;
	
	
	component PmaControl is

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

	end component;

	
	component IoaControl is

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

	end component;
	
	
	component AluControl is

		port
		(
			DS			: in	DecoderOutRec;
			Cycle		: in	CycleOutRec;
			IR			: in	OpcodeWord;
			InInt		: in	std_logic;
			AluCtrl		: out	AluCtrlRec
		);

	end component;
	
	
	component DmaControl is

		port
		(
			DS			: in	DecoderOutRec;
			Cycle		: in	CycleOutRec;
			InInt		: in	std_logic;
			IR			: in	OpcodeWord;
			DmaCtrl		: out	DmaCtrlRec
		);

	end component;
	
	
	component Decoder is		

		port
		(
			IR			: in	OpcodeWord;
			Disable		: in	std_logic;
			DecoderRec 	: out 	DecoderOutRec
		);

	end component;
	
	
	component Cycler is

		port
		(
			SysCtrl		: in 		SystemCtrlRec;
			NewInstr	: in 		std_logic;
			CycleRec	: out	 	CycleOutRec
		);
	
	end component;
	
	
	component Sequncer is

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

	end component;
	
	
	component AluAddBlock is

		port
		(
			InstADD	: in  std_logic;
			InstADC	: in  std_logic;
			InstSUB	: in  std_logic;
			InstSBC	: in  std_logic;
			InstNEG	: in  std_logic;
			A		: in  DataWord;
			B		: in  DataWord;
			iC		: in  std_logic;                   
			oH		: out std_logic;
			oV		: out std_logic;
			oC		: out std_logic;
			result	: out DataWord
		);
		
	end component;


	component LogicBlock is

		port
		(
			InstAND	: in  std_logic;
			InstCOM	: in  std_logic;
			InstEOR	: in  std_logic;
			InstOR	: in  std_logic;
			A		: in  DataWord;
			B		: in  DataWord;
			result	: out DataWord
		);
		
	end component;

	
	component AluShiftBlock is

		port
		(
			InstSWAP	: in  std_logic;
			InstLSR		: in  std_logic;
			InstASR		: in  std_logic;
			InstROR		: in  std_logic;		
			A			: in  DataWord;
			iC			: in  std_logic;                   
			oV			: out std_logic;
			oC			: out std_logic;
			result		: out DataWord
		);
		
	end component;


	component AluMulBlock is

		port
		(
			InstMUL	: in  std_logic;
			MulHigh	: in  std_logic;
			A		: in  DataWord;
			B		: in  DataWord;
			oC		: out std_logic;
			result	: out DataWord
		);
	
	end component;
	
	
	component ArithmeticLogicUnit is			
	
		port
		(
			SysCtrl			: in	SystemCtrlRec;
			AluCtrl			: in	AluCtrlRec;
			RegOut			: in	RegOutRec;
			Immediate		: in 	DataWord;
			AluOut			: out	AluOutRec;		
			SetSREG			: in	std_logic
		);

	end component;
	
	
	component RegisterFile is

		port
		(
			SysCtrl			: in	SystemCtrlRec;
			RegCtrl			: in	RegCtrlRec;
			AluOut			: in	AluOutRec;
			PmaOut			: in	PmaOutRec;
			DmaOut			: in	DmaOutRec;
			IoaOut			: in 	IoaOutRec;
			FromDma			: in	DmaToRegRec;
			FromIoa			: in  	IoaToRegRec;
			RegOut			: out	RegOutRec
		);

	end component;
	
	
	component ProgramMemoryAccess is

		port 
		(
			SysCtrl			: in	SystemCtrlRec;
			Ctrl			: in	PmaCtrlRec;
			IntVect			: in	InterruptVector;
			RegOut			: in	RegOutRec;
			OutRec			: out	PmaOutRec;
			FromMem			: in	PrgMemoryOutRec;
			ToMem			: out	PrgMemoryCtrlRec
		);

	end component;
	
	
	component DataMemoryAccess is

		port 
		(
			SysCtrl			: in	SystemCtrlRec;
			Ctrl			: in	DmaCtrlRec;
			OutRec			: out	DmaOutRec;
			ToReg			: out	DmaToRegRec;
			ToIoa			: out	DmaToIoaRec;
			ToMem			: out 	DataMemoryCtrlRec;
			FromReg			: in	RegOutRec;
			FromIoa			: in	IoaToDmaRec;
			FromPma			: in	PmaOutRec;
			FromMem			: in 	DataMemoryOutRec
		);

	end component;
	

	component InputOutputAccess is

		generic
		(
			STATUS_REG	: unsigned	:= STATUS_REG;
			STACK_PTR	: unsigned	:= STACK_PTR
		);
				
		port 
		(
			SysCtrl			: in	SystemCtrlRec;
			Ctrl			: in	IoaCtrlRec;
			OutRec			: out	IoaOutRec;
			FromDma			: in	DmaToIoaRec;
			ToDma			: out	IoaToDmaRec;
			FromReg			: in	RegOutRec;
			ToReg			: out	IoaToRegRec;
			FromIo			: in	InOutRec;
			ToIo			: out	IoCtrlRec;
			FromAlu			: in 	AluOutRec
		);

	end component;
	
end package;

