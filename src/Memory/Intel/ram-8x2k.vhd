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

library altera_mf;
use altera_mf.altera_mf_components.all;

use work.CoreTypes.all;

entity DataMemory is

	port
	(
		SysCtrl		: in	SystemCtrlRec;
		FromCpu		: in	DataMemoryCtrlRec;
		ToCpu		: out	DataMemoryOutRec
	);

end entity;

architecture RTL of DataMemory is

	signal i_clock		: std_logic;
	signal i_addr		: std_logic_vector(15 downto 0);

begin
	i_clock 	<= not SysCtrl.Clock;
	i_addr  	<= FromCpu.Addr - x"0100";
	
	
	altsyncram_component : altsyncram
	GENERIC MAP (
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		intended_device_family => "Cyclone V",
		--lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_hint => "ENABLE_RUNTIME_MOD=YES,INSTANCE_NAME=DMEM",
		lpm_type => "altsyncram",
		numwords_a => 2048,
		operation_mode => "SINGLE_PORT",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "UNREGISTERED",
		power_up_uninitialized => "FALSE",
		read_during_write_mode_port_a => "NEW_DATA_NO_NBE_READ",
		widthad_a => 11,
		width_a => 8,
		width_byteena_a => 1
	)
	PORT MAP (
		address_a => i_addr(10 downto 0),
		clock0 => i_clock,
		data_a => FromCpu.Data,
		wren_a => FromCpu.WR,
		q_a => ToCpu.Data
	);
end architecture;
