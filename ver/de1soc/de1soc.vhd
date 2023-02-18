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

entity de1soc is

	generic
	(
		CpuFrequncy	: positive	:= 40_000_000;
		ProgramFile : string 	:= "../../test/de1soc/Debug/de1soc.mif"
	);
		
	port
	(
        CLOCK_50  			: in 	std_logic;
		CLOCK2_50			: in	std_logic;
		
        HEX0_N 				: out 	std_logic_vector(6 downto 0);
        HEX1_N 				: out 	std_logic_vector(6 downto 0);
        HEX2_N 				: out 	std_logic_vector(6 downto 0);
        HEX3_N 				: out 	std_logic_vector(6 downto 0);
        HEX4_N 				: out 	std_logic_vector(6 downto 0);
        HEX5_N 				: out 	std_logic_vector(6 downto 0);
        KEY_N 				: in 	std_logic_vector(3 downto 0);
        LEDR 				: out 	std_logic_vector(9 downto 0);
        SW 					: in 	std_logic_vector(9 downto 0);
        GPIO_0 				: inout std_logic_vector(35 downto 0);
        GPIO_1 				: inout std_logic_vector(35 downto 0);
		
        HPS_CONV_USB_N 		: inout std_logic;
        HPS_DDR3_ADDR   	: out   std_logic_vector(14 downto 0);
        HPS_DDR3_BA     	: out   std_logic_vector(2 downto 0);
        HPS_DDR3_CAS_N  	: out   std_logic;
        HPS_DDR3_CK_N   	: out   std_logic;
        HPS_DDR3_CK_P   	: out   std_logic;
        HPS_DDR3_CKE    	: out   std_logic;
        HPS_DDR3_CS_N   	: out   std_logic;
        HPS_DDR3_DM     	: out   std_logic_vector(3 downto 0);
        HPS_DDR3_DQ     	: inout std_logic_vector(31 downto 0);
        HPS_DDR3_DQS_N  	: inout std_logic_vector(3 downto 0);
        HPS_DDR3_DQS_P  	: inout std_logic_vector(3 downto 0);
        HPS_DDR3_ODT   		: out   std_logic;
        HPS_DDR3_RAS_N  	: out   std_logic;
        HPS_DDR3_RESET_N	: out   std_logic;
        HPS_DDR3_RZQ     	: in    std_logic;
        HPS_DDR3_WE_N    	: out   std_logic;
        HPS_ENET_GTX_CLK 	: out   std_logic;
        HPS_ENET_INT_N  	: inout std_logic;
        HPS_ENET_MDC     	: out   std_logic;
        HPS_ENET_MDIO    	: inout std_logic;
        HPS_ENET_RX_CLK  	: in    std_logic;
        HPS_ENET_RX_DATA 	: in    std_logic_vector(3 downto 0);
        HPS_ENET_RX_DV   	: in    std_logic;
        HPS_ENET_TX_DATA 	: out   std_logic_vector(3 downto 0);
        HPS_ENET_TX_EN   	: out   std_logic;
        HPS_FLASH_DATA   	: inout std_logic_vector(3 downto 0);
        HPS_FLASH_DCLK   	: out   std_logic;
        HPS_FLASH_NCSO   	: out   std_logic;
        HPS_GSENSOR_INT  	: inout std_logic;
        HPS_I2C_CONTROL  	: inout std_logic;
        HPS_I2C1_SCLK    	: inout std_logic;
        HPS_I2C1_SDAT    	: inout std_logic;
        HPS_I2C2_SCLK    	: inout std_logic;
        HPS_I2C2_SDAT    	: inout std_logic;
        HPS_KEY_N        	: inout std_logic;
        HPS_LED          	: inout std_logic;
        HPS_LTC_GPIO     	: inout std_logic;
        HPS_SD_CLK       	: out   std_logic;
        HPS_SD_CMD       	: inout std_logic;
        HPS_SD_DATA      	: inout std_logic_vector(3 downto 0);
        HPS_SPIM_CLK     	: out   std_logic;
        HPS_SPIM_MISO    	: in    std_logic;
        HPS_SPIM_MOSI    	: out   std_logic;
        HPS_SPIM_SS      	: inout std_logic;
        HPS_UART_RX      	: in    std_logic;
        HPS_UART_TX      	: out   std_logic;
        HPS_USB_CLKOUT   	: in    std_logic;
        HPS_USB_DATA     	: inout std_logic_vector(7 downto 0);
        HPS_USB_DIR      	: in    std_logic;
        HPS_USB_NXT      	: in    std_logic;
        HPS_USB_STP      	: out   std_logic
    );
	
end entity de1soc;

architecture RTL of de1soc is

	signal	PllLocked		: std_logic;
	signal	Clock2Mhz		: std_logic;
	signal	ClockAvr		: std_logic;
	alias	nResetKey		: std_logic is KEY_N(0);
	alias	nReset			: std_logic is PllLocked;
	alias	RunningLed		: std_logic is LEDR(9);
	
	signal 	HpsIn			: HpsInputRec;
	signal 	HpsOut			: HpsOutputRec;
	
	signal	AvrControl		: SystemCtrlRec;
	signal	AvrInfo			: SystemInfoRec;
	signal 	AvrToIo			: IoCtrlRec;
	signal 	IoToAvr			: InOutRec;
	
	signal	BoardIn			: BoardInputRec;
	signal	BoardOut		: BoardOutputRec;

begin
	RunningLed			<= not nReset;			
	
	AvrControl.Clock	<= ClockAvr;
	AvrControl.nReset	<= nReset;
	
	BoardIn.KEY(0)		<= not KEY_N(1);
	BoardIn.KEY(1)		<= not KEY_N(2);
	BoardIn.KEY(2)		<= not KEY_N(3);
	BoardIn.SW			<= SW;
	BoardIn.HPS_A		<= HpsOut.A;
	BoardIn.RX0			<= GPIO_1(5);
	BoardIn.CTS0		<= GPIO_1(1);
	
	LEDR(7 downto 0)	<= BoardOut.LED;
	HEX0_N				<= BoardOut.HEX0;
	HEX1_N				<= BoardOut.HEX1;
	HEX2_N				<= BoardOut.HEX2;
	HEX3_N				<= BoardOut.HEX3;
	HEX4_N				<= BoardOut.HEX4;
	HEX5_N				<= BoardOut.HEX5;
	HpsIn.A				<= BoardOut.HPS_A;
	HpsIn.B				<= BoardOut.HPS_B;
	GPIO_1(3)			<= BoardOut.TX0;
	GPIO_1(7)			<= BoardOut.DTR0;

	LEDR(8)				<= '0';
	
	IO : component IoBlock

		generic map
		(		
			CpuFrequncy		=>	CpuFrequncy
		)
	
		port map
		(
			SysCtrl			=>	AvrControl,
			IoCtrl			=>	AvrToIo,
			IoOut			=>	IoToAvr,
			UtilClock		=>	Clock2Mhz,
			BoardIn			=>	BoardIn,
			BoardOut		=>	BoardOut
		);

		
	AVR : component ProcessorUnit

		generic map
		(
			ProgramFile 	=> 	ProgramFile
		)

		port map
		(
			SysCtrl			=>	AvrControl,
			SysInfo			=>	AvrInfo,
			FromIo			=>	IoToAvr,
			ToIo			=>	AvrToIo
		);
		
		
	PLL : component clockpll

		port map
		(
			refclk   	=>	CLOCK2_50,
			rst      	=>	not nResetKey,
			outclk_0 	=>	ClockAvr,
			outclk_1 	=>	Clock2Mhz,
			locked   	=>	PllLocked
		);
		
	
    SOC : component soc_system
	
		port map 
		(
            output_a_export                 => HpsOut.A,    	    		-- output_a.export
            input_a_export                  => HpsIn.A,         	  		--  input_a.export
            input_b_export                  => HpsIn.B,			        	--  input_b.export
			clk_clk                         => CLOCK_50,                    --             clk.clk
			reset_reset_n                   => '1',                     	--           reset.reset_n
 			hps_ddr_mem_a                   => HPS_DDR3_ADDR,             	--       hps_ddr.mem_a
			hps_ddr_mem_ba                  => HPS_DDR3_BA,                 --                .mem_ba
			hps_ddr_mem_ck                  => HPS_DDR3_CK_P,               --                .mem_ck
			hps_ddr_mem_ck_n                => HPS_DDR3_CK_N,               --                .mem_ck_n
			hps_ddr_mem_cke                 => HPS_DDR3_CKE,                --                .mem_cke
			hps_ddr_mem_cs_n                => HPS_DDR3_CS_N,               --                .mem_cs_n
			hps_ddr_mem_ras_n               => HPS_DDR3_RAS_N,              --                .mem_ras_n
			hps_ddr_mem_cas_n               => HPS_DDR3_CAS_N,              --                .mem_cas_n
			hps_ddr_mem_we_n                => HPS_DDR3_WE_N,               --                .mem_we_n
			hps_ddr_mem_reset_n             => HPS_DDR3_RESET_N,            --                .mem_reset_n
			hps_ddr_mem_dq                  => HPS_DDR3_DQ,                	--                .mem_dq
			hps_ddr_mem_dqs                 => HPS_DDR3_DQS_P,              --                .mem_dqs
			hps_ddr_mem_dqs_n               => HPS_DDR3_DQS_N,              --                .mem_dqs_n
			hps_ddr_mem_odt                 => HPS_DDR3_ODT,                --                .mem_odt
			hps_ddr_mem_dm                  => HPS_DDR3_DM,                 --                .mem_dm
			hps_ddr_oct_rzqin        		=> HPS_DDR3_RZQ,                --                .oct_rzqin
			hps_io_hps_io_emac1_inst_TX_CLK => HPS_ENET_GTX_CLK, 			--        hps_io.hps_io_hps_io_emac1_inst_TX_CLK
			hps_io_hps_io_emac1_inst_TXD0   => HPS_ENET_TX_DATA(0),   		--                .hps_io_hps_io_emac1_inst_TXD0
			hps_io_hps_io_emac1_inst_TXD1   => HPS_ENET_TX_DATA(1),   		--                .hps_io_hps_io_emac1_inst_TXD1
			hps_io_hps_io_emac1_inst_TXD2   => HPS_ENET_TX_DATA(2),   		--                .hps_io_hps_io_emac1_inst_TXD2
			hps_io_hps_io_emac1_inst_TXD3   => HPS_ENET_TX_DATA(3),   		--                .hps_io_hps_io_emac1_inst_TXD3
			hps_io_hps_io_emac1_inst_RXD0   => HPS_ENET_RX_DATA(0),   		--                .hps_io_hps_io_emac1_inst_RXD0
			hps_io_hps_io_emac1_inst_MDIO   => HPS_ENET_MDIO,   			--                .hps_io_hps_io_emac1_inst_MDIO
			hps_io_hps_io_emac1_inst_MDC    => HPS_ENET_MDC,    			--                .hps_io_hps_io_emac1_inst_MDC
			hps_io_hps_io_emac1_inst_RX_CTL => HPS_ENET_RX_DV, 				--                .hps_io_hps_io_emac1_inst_RX_CTL
			hps_io_hps_io_emac1_inst_TX_CTL => HPS_ENET_TX_EN, 				--                .hps_io_hps_io_emac1_inst_TX_CTL
			hps_io_hps_io_emac1_inst_RX_CLK => HPS_ENET_RX_CLK, 			--                .hps_io_hps_io_emac1_inst_RX_CLK
			hps_io_hps_io_emac1_inst_RXD1   => HPS_ENET_RX_DATA(1),   		--                .hps_io_hps_io_emac1_inst_RXD1
			hps_io_hps_io_emac1_inst_RXD2   => HPS_ENET_RX_DATA(2),   		--                .hps_io_hps_io_emac1_inst_RXD2
			hps_io_hps_io_emac1_inst_RXD3   => HPS_ENET_RX_DATA(3),   		--                .hps_io_hps_io_emac1_inst_RXD3
			hps_io_hps_io_qspi_inst_IO0     => HPS_FLASH_DATA(0),     		--                .hps_io_hps_io_qspi_inst_IO0
			hps_io_hps_io_qspi_inst_IO1     => HPS_FLASH_DATA(1),     		--                .hps_io_hps_io_qspi_inst_IO1
			hps_io_hps_io_qspi_inst_IO2     => HPS_FLASH_DATA(2),     		--                .hps_io_hps_io_qspi_inst_IO2
			hps_io_hps_io_qspi_inst_IO3     => HPS_FLASH_DATA(3),     		--                .hps_io_hps_io_qspi_inst_IO3
			hps_io_hps_io_qspi_inst_SS0     => HPS_FLASH_NCSO,     			--                .hps_io_hps_io_qspi_inst_SS0
			hps_io_hps_io_qspi_inst_CLK     => HPS_FLASH_DCLK,     			--                .hps_io_hps_io_qspi_inst_CLK
			hps_io_hps_io_sdio_inst_CMD     => HPS_SD_CMD,     				--                .hps_io_hps_io_sdio_inst_CMD
			hps_io_hps_io_sdio_inst_D0      => HPS_SD_DATA(0),      		--                .hps_io_hps_io_sdio_inst_D0
			hps_io_hps_io_sdio_inst_D1      => HPS_SD_DATA(1),      		--                .hps_io_hps_io_sdio_inst_D1
			hps_io_hps_io_sdio_inst_CLK     => HPS_SD_CLK,     				--                .hps_io_hps_io_sdio_inst_CLK
			hps_io_hps_io_sdio_inst_D2      => HPS_SD_DATA(2),      		--                .hps_io_hps_io_sdio_inst_D2
			hps_io_hps_io_sdio_inst_D3      => HPS_SD_DATA(3),      		--                .hps_io_hps_io_sdio_inst_D3
			hps_io_hps_io_usb1_inst_D0      => HPS_USB_DATA(0),      		--                .hps_io_hps_io_usb1_inst_D0
			hps_io_hps_io_usb1_inst_D1      => HPS_USB_DATA(1),      		--                .hps_io_hps_io_usb1_inst_D1
			hps_io_hps_io_usb1_inst_D2      => HPS_USB_DATA(2),      		--                .hps_io_hps_io_usb1_inst_D2
			hps_io_hps_io_usb1_inst_D3      => HPS_USB_DATA(3),      		--                .hps_io_hps_io_usb1_inst_D3
			hps_io_hps_io_usb1_inst_D4      => HPS_USB_DATA(4),      		--                .hps_io_hps_io_usb1_inst_D4
			hps_io_hps_io_usb1_inst_D5      => HPS_USB_DATA(5),      		--                .hps_io_hps_io_usb1_inst_D5
			hps_io_hps_io_usb1_inst_D6      => HPS_USB_DATA(6),      		--                .hps_io_hps_io_usb1_inst_D6
			hps_io_hps_io_usb1_inst_D7      => HPS_USB_DATA(7),      		--                .hps_io_hps_io_usb1_inst_D7
			hps_io_hps_io_usb1_inst_CLK     => HPS_USB_CLKOUT,     			--                .hps_io_hps_io_usb1_inst_CLK
			hps_io_hps_io_usb1_inst_STP     => HPS_USB_STP,     			--                .hps_io_hps_io_usb1_inst_STP
			hps_io_hps_io_usb1_inst_DIR     => HPS_USB_DIR,     			--                .hps_io_hps_io_usb1_inst_DIR
			hps_io_hps_io_usb1_inst_NXT     => HPS_USB_NXT,     			--                .hps_io_hps_io_usb1_inst_NXT
			hps_io_hps_io_spim1_inst_CLK    => HPS_SPIM_CLK,    			--                .hps_io_hps_io_spim1_inst_CLK
			hps_io_hps_io_spim1_inst_MOSI   => HPS_SPIM_MOSI,   			--                .hps_io_hps_io_spim1_inst_MOSI
			hps_io_hps_io_spim1_inst_MISO   => HPS_SPIM_MISO,   			--                .hps_io_hps_io_spim1_inst_MISO
			hps_io_hps_io_spim1_inst_SS0    => HPS_SPIM_SS,    				--                .hps_io_hps_io_spim1_inst_SS0
			hps_io_hps_io_uart0_inst_RX     => HPS_UART_RX,     			--                .hps_io_hps_io_uart0_inst_RX
			hps_io_hps_io_uart0_inst_TX     => HPS_UART_TX,     			--                .hps_io_hps_io_uart0_inst_TX
			hps_io_hps_io_i2c0_inst_SDA     => HPS_I2C1_SDAT,     			--                .hps_io_hps_io_i2c0_inst_SDA
			hps_io_hps_io_i2c0_inst_SCL     => HPS_I2C1_SCLK,     			--                .hps_io_hps_io_i2c0_inst_SCL
			hps_io_hps_io_i2c1_inst_SDA     => HPS_I2C2_SDAT,     			--                .hps_io_hps_io_i2c1_inst_SDA
			hps_io_hps_io_i2c1_inst_SCL     => HPS_I2C2_SCLK,     			--                .hps_io_hps_io_i2c1_inst_SCL
			hps_io_hps_io_gpio_inst_GPIO09  => HPS_CONV_USB_N,  			--                .hps_io_hps_io_gpio_inst_GPIO09
			hps_io_hps_io_gpio_inst_GPIO35  => HPS_ENET_INT_N,  			--                .hps_io_hps_io_gpio_inst_GPIO35
			hps_io_hps_io_gpio_inst_GPIO40  => HPS_LTC_GPIO,  				--                .hps_io_hps_io_gpio_inst_GPIO40
			hps_io_hps_io_gpio_inst_GPIO48  => HPS_I2C_CONTROL,  			--                .hps_io_hps_io_gpio_inst_GPIO48
			hps_io_hps_io_gpio_inst_GPIO53  => HPS_LED,  					--                .hps_io_hps_io_gpio_inst_GPIO53
			hps_io_hps_io_gpio_inst_GPIO54  => HPS_KEY_N,  					--                .hps_io_hps_io_gpio_inst_GPIO54
			hps_io_hps_io_gpio_inst_GPIO61  => HPS_GSENSOR_INT   			--                .hps_io_hps_io_gpio_inst_GPIO61
			--hps_h2f_reset_reset_n           => CONNECTED_TO_hps_h2f_reset_reset_n            -- hps_h2f_reset.reset_n
		);

end architecture;
