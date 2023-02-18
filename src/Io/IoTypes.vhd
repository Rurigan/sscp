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

package IoTypes is

	component InputPort is

		generic
		(
			PortAddr	: IoAddr;
			IntVect		: InterruptVector	
		);
		
		port
		(
			SysCtrl		: in 	SystemCtrlRec;
			FromCpu		: in	IoCtrlRec;
			IntAck		: in	std_logic;
			ToCpu		: out	InOutRec;
			Input		: in	DataWord
		);

	end component;


	component OutputPort is

		generic
		(
			PortAddr	: IoAddr;
			PortDef		: DataWord	:= x"00"	
		);
		
		port
		(
			SysCtrl		: in 	SystemCtrlRec;
			FromCpu		: in	IoCtrlRec;
			ToCpu		: out	InOutRec;
			Output		: out	DataWord
		);
		
	end component;

	
	component Timer is

		--
		-- Generate interupt after (Count + 1) * (Mulitplier + 1) of ExtCLock rising edges
		--
		-- 2 MHz external clock, 49.999 count, 39 multiblier should give a one second resolution	
		--
		-- offset   bits   	rd/wr  
		-- ------	-----	----- 
		--	0				RD/WR	Count low byte		 
		--  1				RD/WR	Count high byte
		--  2				RD/WR	Mulitplier
		--
		
		generic
		(
			PortAddr	: IoAddr			:= x"55";
			IntVect		: InterruptVector	:= "10101"
		);
		
		port
		(
			SysCtrl		: in 	SystemCtrlRec;
			FromCpu		: in	IoCtrlRec;
			ToCpu		: out	InOutRec;
			IntAck		: in	std_logic;
			Enable		: in	std_logic;
			ExtClock	: in	std_logic
		);

	end component;	
	
	
	component Segment7 is

		--
		-- Drives 7 segment display
		--
		-- offset   bits   	rd/wr  
		-- ------	-----	----- 
		-- 0      	3-0		WR		: 4 bit hexadecimal value converetd to hex digit on segment display
		--			4		WR		: high to enable segment
		--
		
		generic
		(
			PortAddr	: IoAddr;
			PortDef		: DataWord	:= x"80"	
		);
		
		port
		(
			SysCtrl		: in 	SystemCtrlRec;
			FromCpu		: in	IoCtrlRec;
			ToSegment	: out 	std_logic_vector(6 downto 0)
		);

	end component;
	
	
	component Uart is

		
		generic
		(
			PortAddr	: IoAddr;
			RxIntVect	: InterruptVector;
			TxIntVect	: InterruptVector;
			DefBitTicks	: DoubleWord
		);
		
		port
		(
			SysCtrl		: in 	SystemCtrlRec;
			FromCpu		: in	IoCtrlRec;
			ToCpu		: out	InOutRec;
			IntAck		: in	std_logic;
			EnableDev	: in	std_logic;
			EnableFlow	: in	std_logic;
			EnableInt	: in	std_logic;
			RxWire		: in	std_logic;
			nRxDTR		: out	std_logic;
			TxWire		: out	std_logic;
			nTxCTS		: in	std_logic
		);

	end Component;


	component SerialTransceiver is

		port
		(
			Clock		: in	std_logic;
			nReset		: in	std_logic;
			BitTicks	: in	std_logic_vector(15 downto 0);
			TxData		: in	std_logic_vector(7 downto 0);
			TxSend		: in	std_logic;
			RxWire		: in	std_logic;
			TxWire		: out	std_logic;
			TxBusy		: out	std_logic;
			TxDone		: out	std_logic;
			RxData		: out	std_logic_vector(7 downto 0);
			RxBusy		: out	std_logic;
			RxRecived	: out	std_logic
		);
		
	end component;


	component SerialTransmitter is

		port
		(
			Clock		: in	std_logic;
			nReset		: in	std_logic;
			BitTicks	: in	std_logic_vector(15 downto 0);
			Data		: in	std_logic_vector(7 downto 0);
			Send		: in	std_logic;
			Wire		: out	std_logic;
			Busy		: out	std_logic;
			Done		: out	std_logic
		);
		
	end component;
	

	component SerialReceiver is

		port
		(
			Clock		: in	std_logic;
			nReset		: in	std_logic;
			BitTicks	: in	std_logic_vector(15 downto 0);
			Wire		: in	std_logic;
			Data		: out	std_logic_vector(7 downto 0);
			Recived		: out	std_logic;
			Busy		: out	std_logic
		);

	end component;


	component InterruptControler is

		port
		(
			SysCtrl		: in 	SystemCtrlRec;
					   
			INTreq		: out  	std_logic;									-- interrupt request
			INTack		: in  	std_logic;									-- value of the global interrupt flag
			
			IntLines	: in	std_ulogic_vector(7 downto 0);
			IntMask		: in	std_ulogic_vector(7 downto 0);
			IntCurrent	: out	std_ulogic_vector(7 downto 0);
			IntAckLines	: out	std_ulogic_vector(7 downto 0)
		);
		
	end component InterruptControler;
	
	
	component KeyDebounce is

		generic 
		(
			BTN_ACTIVE	: std_logic := '1';
			COUNT_MAX 	: positive	:= 40
		);

		port
		(   
			clock 		: in std_logic;
			nReset 		: in std_logic;
			button_in	: in std_logic		:= not BTN_ACTIVE;
			pulse_out 	: out std_logic
		);
		
	end component;

end package;
