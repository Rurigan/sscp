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

entity ProgramMemory is

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

end entity;
	
architecture RTL of ProgramMemory is

	signal i_clock 		: std_logic;
	signal sub_wire0	: std_logic_vector(15 downto 0);

begin
	i_clock 	<= not SysCtrl.Clock;
	ToCpu.Data	<= sub_wire0(7 downto 0) & sub_wire0(15 downto 8);
	
	
	altsyncram_component : altsyncram
	
		generic map 
		(
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => InitFile,
		intended_device_family => "Cyclone V",
		lpm_hint => "ENABLE_RUNTIME_MOD=YES,INSTANCE_NAME=PMEM",
		--lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 32768,
		operation_mode => "SINGLE_PORT",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "UNREGISTERED",
		power_up_uninitialized => "FALSE",
		widthad_a => 15,
		width_a => 16,
		width_byteena_a => 1
		)
	
		port map
		(
		address_a => FromCpu.Addr(14 downto 0),
		clock0 => i_clock,
		data_a => (others => '0'),
		wren_a => '0',
		q_a => sub_wire0
		);

end architecture;
