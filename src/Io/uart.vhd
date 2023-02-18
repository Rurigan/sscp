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
use work.IoTypes.all;
	
entity Uart is

	
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

end entity;

architecture RTL of Uart is

	signal BitTicks		: DoubleWord;
	alias  BtLow		: DataWord is BitTicks(7 downto 0);
	alias  BtHigh		: DataWord is BitTicks(15 downto 8);
	signal Status		: DataWord;
	alias  RxReady		: std_logic is Status(0);
	alias  RxOverflow	: std_logic	is Status(1);
	alias  TxReady		: std_logic is Status(2);
	
	alias  STAnRxDTR	: std_logic is Status(4);
	alias  STAnTxCTS	: std_logic is Status(5);
	alias  RxBusy		: std_logic is Status(6);
	alias  TxBusy		: std_logic is Status(7);
	
	type TxStateType is (sTxInit, sTxDisabled, sTxReady, sTxTransmit);
	type RxStateType is (sRxInit, sRxDisabled, sRxIdle, sRxRecived);
	
	signal TxState		: TxStateType;
	signal TxData		: DataWord;
	signal TxSend		: std_logic;
	signal TxDone		: std_logic;
	signal TxTmpReady	: std_logic;
	
	signal RxState		: RxStateType;
	signal RxData		: DataWord;
	signal RxBuffer		: DataWord;
	signal RxRecived	: std_logic;
	signal RxTMPnDRT	: std_logic;
 	
	signal HitData		: std_logic;
	signal DataRead		: std_logic;
	signal DataWrite	: std_logic;
	signal HitStatus	: std_logic;
	signal StatusRead	: std_logic;
	signal HitBtLow		: std_logic;
	signal BtLowRead	: std_logic;
	signal BtLowWrite	: std_logic;
	signal HitBtHigh	: std_logic;
	signal BtHighRead	: std_logic;
	signal BtHighWrite	: std_logic;
	
	signal SelectedData	: DataWord;
	signal BitInx 		: integer range 0 to 7;

	signal RxTrig		: std_logic;
	signal RxPend		: std_logic;
	signal TxTrig		: std_logic;
	signal TXPend		: std_logic;
	
begin
	HitData 	<= '1' when FromCpu.Addr = PortAddr else '0';	
	HitStatus 	<= '1' when FromCpu.Addr = PortAddr + 1 else '0';	
	HitBtLow 	<= '1' when FromCpu.Addr = PortAddr + 2 else '0';	
	HitBtHigh 	<= '1' when FromCpu.Addr = PortAddr + 3 else '0';	
	
	DataRead	<= HitData and FromCpu.RD;
	DataWrite	<= HitData and FromCpu.WR;

	StatusRead	<= HitStatus and FromCpu.RD;
	
	BtLowRead	<= HitBtLow and FromCpu.RD;
	BtLowWrite	<= HitBtLow and FromCpu.WR;
	
	BtHighRead	<= HitBtHigh and FromCpu.RD;
	BtHighWrite	<= HitBtHigh and FromCpu.WR;
	
	BitInx		<= to_integer(unsigned(FromCpu.BitAddr));
	
	SelectedData	<=  Status when StatusRead
							else RxData when DataRead
							else BtLow when BtLowRead
							else BtHigh when BtHighRead
							else (others => '0');
							
	ToCpu.BitData	<= SelectedData(BitInx) when 
							(
								FromCpu.BOP and
								(
									DataRead 
									or StatusRead 
									or BtLowRead
									or BtHighRead
								)
							)
							else '0';
							
	ToCpu.Data		<= SelectedData;
	ToCpu.IntReq	<= RxTrig or TxTrig;
	toCpu.IntVect	<= RxIntVect when RxTrig
							else TxIntVect when TxTrig
							else (others => '0');
	
	STAnRxDTR	<= nRxDTR;
	STAnTxCTS	<= nTxCTS;

	nRxDTR		<= RxTMPnDRT or (EnableFlow and RxBusy);
	TxReady		<= TxTmpReady and not (EnableFlow and nTxCTS);
	
	ENG : process(SysCtrl) begin
	
		if not SYsCtrl.nReset then
		
			BitTicks	<= DefBitTicks;
		
		else
		
			if rising_edge(SysCtrl.Clock) then

				if BtlowWrite then
				
					BtLow <= FromCpu.Data;
					
				end if;
				
				if BtHighWrite then
				
					BtHigh <= FromCpu.Data;
					
				end if;
			
			end if;
			
		end if;
	
	end process;
	
	
	STX : process(SysCtrl) begin
	
		if not SYsCtrl.nReset then
		
			TxState		<= sTxInit;
			TxData		<= (others => '0');
		
		else
		
			if rising_edge(SysCtrl.Clock) then

				if EnableInt then
				
					if TxPend and not RxTrig then
				
						TxTrig <= '1';	
						TxPend <= '0';
						
					end if;
					
					if TxTrig and IntAck then
					
						TxTrig <= '0';
					
					end if;
					
				end if;
					
				case TxState is
				
					when sTxInit =>
					
						TxTmpReady 	<= '0';
						TxSend		<= '0';

						if not Txbusy then
	
							TxState <= sTxDisabled;
							
						end if;
				
				
					when sTxDisabled =>
					
						if EnableDev then
						
							TxTrig	<= '0';
							TxPend	<= '0';
							TxSend	<= '0';
							TxState <= sTxReady;
							
						end if;
				
				
					when sTxReady =>
					
						if EnableDev then
					
							TxTmpReady	<= '1';
								
							if DataWrite and not (EnableFlow and nTxCTS) then
						
								TxData 		<= FromCpu.Data;
								TxSend 		<= '1';
								TxTmpReady	<= '0';
								TxState 	<= sTxTransmit;
								
							end if;
							
						else
						
							TxState <= sTxInit;
						
						end if;
						
					
					when sTxTransmit =>

						if EnableDev then
						
							if TxBusy then
							
								TxSend	<= '0';
								
							end if;
						
							if TxDone then
							
								if EnableInt then
								
									if RxTrig or RxRecived  then
									
										TxPend <= '1';
									
									else
									
										TxTrig <= '1';
									
									end if;
								
								end if;
							
								TxState <= sTxReady;
							
							end if;
				
						else
						
							TxState <= sTxInit;
						
						end if;
						
						
					when others =>
				
						TxState <= sTxInit;
				
				end case;
				
			end if;
			
		end if;
		
	end process;
	
	
	SRX : process(SysCtrl) begin
	
		if not SYsCtrl.nReset then
		
			RxState		<= sRxInit;
			RxData		<= (others => '0');
		
		else
		
			if rising_edge(SysCtrl.Clock) then
			
				if EnableInt then 
				
					if RxPend and not TxTrig then
				
						RxTrig <= '1';
						RxPend <= '0';
						
					end if;
					
					if RxTrig and IntAck then
					
						RxTrig <= '0';
						
					end if;
					
				end if;
			
				case RxState is
				
					when sRxinit =>
					
						Status(3) <= '0';

						if EnableFlow then
						
							RxTMPnDRT	<= '1';
							
						else
						
							RxTMPnDRT	<= '0';
							
						end if;
						
						RxReady		<= '0';
						RxOverflow	<= '0';
						RxState 	<= sRxDisabled;
						
					
					when sRxDisabled => 
						
						if EnableFlow then
						
							RxTMPnDRT	<= '1';
						
						end if;
						
						if EnableDev then
							
							RxTrig		<= '0';
							RxPend		<= '0';
							RxReady		<= '0';
							RxOverflow	<= '0';
							RxState		<= sRxIdle;
							
						end if;
						
					
					when sRxIdle =>
					
						if EnableDev then
	
							if RxRecived then
							
								if EnableFlow then
								
									RxTMPnDRT  <= '1';
								
								end if;
							
								if EnableInt then
								
									if TxTrig  then
									
										RxPend <= '1';
									
									else
									
										RxTrig <= '1';
									
									end if;
								
								end if;
							
								RxData 	<= RxBuffer;
								RxReady	<= '1';
								RxState <= sRxRecived; 
								
							else
							
								if EnableFlow then
								
									RxTMPnDRT	<= '0';
									
								end if;
							
							end if;
							
						else
						
							RxState <= sRxDisabled;
						
						end if;
						
						
					when sRxRecived =>
					
						if EnableDev then
						
							if DataRead then
							
								RxOverflow	<= '0';
								RxReady		<= '0';
								RxState		<= sRxIdle;
							
							elsif RxRecived then
							
								RxOverflow <= '1';
								
							end if;
						
						else
						
							RxState	<= sRxDisabled;
							
						end if;
					
	
					when others =>
				
						RxState <= sRxInit;
				
				end case;
				
			end if;
			
		end if;
	
	end process;

	
	RX : component SerialReceiver 

		port map
		(
			Clock		=>	SysCtrl.Clock,
			nReset		=>	SysCtrl.nReset,
			BitTicks	=>	BitTicks,
			Wire		=>	RxWire,
			Data		=>	RxBuffer,
			Recived		=>	RxRecived,
			Busy		=>	RxBusy
		);

		
	TX : component SerialTransmitter

		port map
		(
			Clock		=>	SysCtrl.Clock,
			nReset		=>	SysCtrl.nReset,
			BitTicks	=>	BitTicks,
			Data		=>	TxData,
			Send		=>	TxSend,
			Wire		=>	TxWire,
			Busy		=>	TxBusy,
			Done		=>	TxDone
		);


end architecture; 