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

entity AAAA is


end entity;

architecture RTL of AAAA is
	
	constant half_cpu_clock	: time := 25 ns;
	
	signal CpuClock			: std_logic;
	signal nCpuReset		: std_logic;
	signal ValidInstr		: std_logic;
	
	signal EndSim			: std_logic;
	signal Break			: std_logic;
		
begin
	
	DUT : entity work.SscpTop

		port map
		(
			CpuClock	=>	CpuClock,
			nCpuReset	=>	nCpuReset,
			ValidInstr	=>	ValidInstr
		);

	
	nCpuReset 	<= '0', '1' after 65 ns;

	Break		<= not ValidInstr;
	
	debug : process begin
	
		EndSim <= '0';
		wait for 25 ns;
		wait until Break; 
		EndSim <= '1';
		wait for 1 ns;

	end process;

	
	EndOfSim : process begin

		wait until EndSim;
		assert false Report "Simulation Finished" severity failure;
	
	end process;
	
	
	genclk : process begin
	
		CpuClock <= '0' after half_cpu_clock, '1' after 2 * half_cpu_clock;
		wait for 2 * half_cpu_clock;
		
	end process;

end architecture;
