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
use work.De1SocTypes.all;
use work.IoTypes.all;

entity IoBlock is

	generic
	(
		IntMaskPortAddr	: positive	:= 1;				-- Interrupt enable port
														--
														-- 0 =
														-- 1 = 
														-- 2 = UART 0
														-- 3 = 
														-- 4 = 
														-- 5 = Timer 0
														-- 6 = KeyPort
														-- 7 = SwPort  
														--
															
		UtlPortAddr		: positive	:= 2;				-- Utility port 	
														--
														-- 0 = enable timer 0 
														-- 1 = enable uart 0
														-- 2 = enable uart 0 flow
														-- 3 = enable uart 0 interrupt
														-- 4 =  
														-- 5 = 
														-- 6 = 
														-- 7 =
														--
														 
														
		Uart0PortAddr	: positive	:= 10;
		Rx0IntVect		: positive	:= 7;
		Tx0IntVect		: Positive	:= 8;
		Uart0IntPri		: positive	:= 2;
		
		Timer0Addr		: positive	:= 14;
		Timer0IntVect	: positive	:= 6;
		Timer0IntPri	: positive 	:= 5;
		
		KeyPortAddr		: positive	:= 18;
		KeyPortIntVect	: positive	:= 4;
		KeyPortIntPri	: positive 	:= 6;
		
		SwPortAddr		: positive	:= 19;
		SwPortIntVect	: positive	:= 5;
		SwPortIntPri	: positive 	:= 7;
		
		LedPortAddr		: positive	:= 20;
		
		HpsInAaddr		: positive	:= 21;
		HpsInBaddr		: positive	:= 22;		
		
		SegmentPortAddr	: positive	:= 64;				-- base port addr of 6 segment display ports
		
		BaudRate		: positive	:= 115200;
		CpuFrequncy		: positive
	);

	port
	(
		SysCtrl			: in	SystemCtrlRec;
		IoCtrl			: in	IoCtrlRec;
		IoOut			: out	InOutRec;
		UtilClock		: in	std_logic;	
		BoardIn			: in 	BoardInputRec;
		BoardOut		: out	BoardOutputRec 
	);

end entity;

architecture RTL of IoBlock is


	signal IntMask		: DataWord;	
	signal IntMaskPort	: InOutRec;
	signal IntReqLines	: std_ulogic_vector(7 downto 0);	
	signal IntCurrent	: std_ulogic_vector(7 downto 0);	
	signal IntAckLines	: std_ulogic_vector(7 downto 0);	

	signal UtlMask		: DataWord;
	signal UtlMaskPort	: InOutRec;
	alias  EnableT0		: std_logic is UtlMask(0);
	alias  EnableU0		: std_logic is UtlMask(1);
	alias  EnableU0Flow	: std_logic is UtlMask(2);
	alias  EnableU0Int	: std_logic is UtlMask(3);

	signal Uart0PortOut	: InOutRec;
	
	signal Timer0PortOut: InOutRec;	
	
	signal KeyPortOut	: InOutRec;
	signal KeyDebounced	: DataWord;
	
	signal SwPortOut	: InOutRec;
	signal SwDebounced	: DataWord;
	
	signal LedPortOut	: InOutRec;
	signal HpsInAout	: inOutRec;
	signal HpsInBout	: inOutRec;
	
begin

	IoOut.BitData	<= UtlMaskPort.BitData or IntMaskPort.BitData or KeyPortOut.BitData or SwPortOut.BitData 
							or LedPortOut.BitData or HpsInAout.BitData or HpsInBout.BitData or Timer0PortOut.BitData or Uart0PortOut.BitData;
	
	din : for i in 0 to 7 generate
	
		IoOut.Data(i) <= UtlMaskPort.Data(i) or IntMaskPort.Data(i) or KeyPortOut.Data(i) or SwPortOut.Data(i) 
							or LedPortOut.Data(i) or HpsInAout.Data(i) or HpsInBout.Data(i) or Timer0PortOut.Data(i) or Uart0PortOut.Data(i);
	
	end generate;	

	
	IoOut.IntVect	<=  Uart0PortOut.IntVect when IntCurrent(Uart0IntPri)
							else Timer0PortOut.IntVect when IntCurrent(Timer0IntPri)
							else KeyPortOut.IntVect when IntCurrent(KeyPortIntPri)
							else SwPortOut.IntVect when IntCurrent(SwPortIntPri)
							else (others => '1');

	IntReqLines <=	(
						Uart0IntPri		=> Uart0PortOut.IntReq,
						Timer0IntPri 	=> Timer0PortOut.IntReq,
						KeyPortIntPri 	=> KeyPortOut.IntReq,
						SwPortIntPri 	=> SwPortOut.IntReq,
						others 			=> '0'
					);
		
		
	ICTRL : component InterruptControler

		port map
		(	
			SysCtrl		=>	SysCtrl,
			INTreq		=>	IoOut.IntReq,
			INTack		=>	IoCtrl.IntAck,
			IntLines	=> 	IntReqLines,
			IntMask		=>  std_ulogic_vector(IntMask),
			IntCurrent	=>	IntCurrent,
			IntAckLines	=>	IntAckLines
		);


	IMSK : component OutputPort

		generic map
		(
			PortAddr	=>	IoAddr(to_unsigned(IntMaskPortAddr, IoAddrWidth))
		)
		
		port map
		(
			SysCtrl		=>	SysCtrl,
			FromCpu		=>	IoCtrl,
			ToCpu		=>	IntMaskPort,
			Output		=>	IntMask
		);

		
	UTL : component OutputPort

		generic map
		(
			PortAddr	=>	IoAddr(to_unsigned(UtlPortAddr, IoAddrWidth))
		)
		
		port map
		(
			SysCtrl		=>	SysCtrl,
			FromCpu		=>	IoCtrl,
			ToCpu		=>	UtlMaskPort,
			Output		=>	UtlMask
		);

		
	UART0 : component uart 

		generic map
		(
			PortAddr	=>	IoAddr(to_unsigned(Uart0PortAddr, IoAddrWidth)),
			RxIntVect	=>	InterruptVector(to_unsigned(Rx0IntVect, InterruptVectorWidth)),
			TxIntVect	=>	InterruptVector(to_unsigned(Tx0IntVect, InterruptVectorWidth)),
			DefBitTicks	=>	DoubleWord(to_unsigned(CpuFrequncy / BaudRate, DataWidth * 2))
		)
		
		port map
		(
			SysCtrl		=>	SysCtrl,
			FromCpu		=>	IoCtrl,
			ToCpu		=>	Uart0PortOut,
			IntAck		=>	IntAckLines(Uart0IntPri),
			EnableDev	=>	EnableU0,
			EnableFlow	=>	EnableU0Flow,
			EnableInt	=>	EnableU0Int,
			RxWire		=>	BoardIn.RX0,
			nRxDTR		=>	BoardOut.DTR0,
			TxWire		=>	BoardOut.TX0,
			nTxCTS		=>	BoardIn.CTS0
		);
		
		
	TM0 : component Timer
		
		generic map
		(
			PortAddr	=>	IoAddr(to_unsigned(Timer0Addr, IoAddrWidth)),
			IntVect		=>  InterruptVector(to_unsigned(Timer0IntVect, InterruptVectorWidth))
		)
		
		port map
		(
			SysCtrl		=>	SysCtrl,
			FromCpu		=>	IoCtrl,
			IntAck		=>	IntAckLines(Timer0IntPri),
			ToCpu		=>	Timer0PortOut,
			Enable		=>	EnableT0,
			ExtClock	=>	UtilClock
		);

	
	KEY : component InputPort 

		generic map
		(
			PortAddr	=>	IoAddr(to_unsigned(KeyPortAddr, IoAddrWidth)),
			IntVect		=>  InterruptVector(to_unsigned(KeyPortIntVect, InterruptVectorWidth))
		)
		
		port map
		(
			SysCtrl		=>	SysCtrl,
			FromCpu		=>	IoCtrl,
			IntAck		=>	IntAckLines(KeyPortIntPri),
			ToCpu		=>	KeyPortOut,
			Input		=>  KeyDebounced
		);
	 

	SW : component InputPort 

		generic map
		(
			PortAddr	=>	IoAddr(to_unsigned(SwPortAddr, IoAddrWidth)),
			IntVect		=>  InterruptVector(to_unsigned(SwPortIntVect, InterruptVectorWidth))
		)
		
		port map
		(
			SysCtrl		=>	SysCtrl,
			FromCpu		=>	IoCtrl,
			IntAck		=>	IntAckLines(SwPortIntPri),
			ToCpu		=>	SwPortOut,
			Input		=>  SwDebounced
		);
	 

	HINA : component OutputPort

		generic map
		(
			PortAddr	=>	IoAddr(to_unsigned(HpsInAaddr, IoAddrWidth))
		)
		
		port map
		(
			SysCtrl		=>	SysCtrl,
			FromCpu		=>	IoCtrl,
			ToCpu		=>	HpsInAout,
			Output		=>	BoardOut.HPS_A
		);
		
		
	HINB : component OutputPort

		generic map
		(
			PortAddr	=>	IoAddr(to_unsigned(HpsInBaddr, IoAddrWidth))
		)
		
		port map
		(
			SysCtrl		=>	SysCtrl,
			FromCpu		=>	IoCtrl,
			ToCpu		=>	HpsInBout,
			Output		=>	BoardOut.HPS_B
		);
		
		
	LED : component OutputPort

		generic map
		(
			PortAddr	=>	IoAddr(to_unsigned(LedPortAddr, IoAddrWidth))
		)
		
		port map
		(
			SysCtrl		=>	SysCtrl,
			FromCpu		=>	IoCtrl,
			ToCpu		=>	LedPortOut,
			Output		=>	BoardOut.LED
		);
		
		
	HEX0 : component Segment7

		generic map
		(
			PortAddr	=>	IoAddr(to_unsigned(SegmentPortAddr, IoAddrWidth))
		)
		
		port map
		(
			SysCtrl		=>	SysCtrl,
			FromCpu		=>	IoCtrl,
			ToSegment	=>	BoardOut.HEX0
		);


	HEX1 : component Segment7

		generic map
		(
			PortAddr	=>	IoAddr(to_unsigned(SegmentPortAddr + 1, IoAddrWidth))
		)
		
		port map
		(
			SysCtrl		=>	SysCtrl,
			FromCpu		=>	IoCtrl,
			ToSegment	=>	BoardOut.HEX1
		);


	HEX2 : component Segment7

		generic map
		(
			PortAddr	=>	IoAddr(to_unsigned(SegmentPortAddr + 2, IoAddrWidth))
		)
		
		port map
		(
			SysCtrl		=>	SysCtrl,
			FromCpu		=>	IoCtrl,
			ToSegment	=>	BoardOut.HEX2
		);

		
	HEX3 : component Segment7

		generic map
		(
			PortAddr	=>	IoAddr(to_unsigned(SegmentPortAddr + 3, IoAddrWidth))
		)
		
		port map
		(
			SysCtrl		=>	SysCtrl,
			FromCpu		=>	IoCtrl,
			ToSegment	=>	BoardOut.HEX3
		);


	HEX4 : component Segment7

		generic map
		(
			PortAddr	=>	IoAddr(to_unsigned(SegmentPortAddr + 4, IoAddrWidth))
		)
		
		port map
		(
			SysCtrl		=>	SysCtrl,
			FromCpu		=>	IoCtrl,
			ToSegment	=>	BoardOut.HEX4
		);

		
	HEX5 : component Segment7

		generic map
		(
			PortAddr	=>	IoAddr(to_unsigned(SegmentPortAddr + 5, IoAddrWidth))
		)
		
		port map
		(
			SysCtrl		=>	SysCtrl,
			FromCpu		=>	IoCtrl,
			ToSegment	=>	BoardOut.HEX5
		);
	

	swb : for i in 0 to 7 generate
	
		swb : component KeyDebounce

			generic map
			(
				COUNT_MAX 	=> 4000
			)
		
			port map
			(   
				clock 		=>	UtilClock,
				nReset 		=>	SysCtrl.nReset,
				button_in	=>	BoardIn.SW(i),
				pulse_out 	=>	SwDebounced(i)
			);	
			
	end generate;

	
	kb : for i in 0 to 2 generate
	
		kb : component KeyDebounce

			generic map
			(
				COUNT_MAX 	=> 40
			)
		
			port map
			(   
				clock 		=>	UtilClock,
				nReset 		=>	SysCtrl.nReset,
				button_in	=>	BoardIn.KEY(i),
				pulse_out 	=>	KeyDebounced(i)
			);	
			
	end generate;

	
	KeyDebounced(7 downto 5)	<= (others => '0');
	
	skb : for i in 8 to 9 generate
	
		skb : component KeyDebounce

			generic map
			(
				COUNT_MAX 	=> 4000
			)
		
			port map
			(   
				clock 		=>	UtilClock,
				nReset 		=>	SysCtrl.nReset,
				button_in	=>	BoardIn.SW(i),
				pulse_out 	=>	KeyDebounced(i - 5)
			);	
			
	end generate;
	

end architecture;