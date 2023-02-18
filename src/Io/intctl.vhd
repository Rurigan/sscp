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
use work.interrupt_ctl_pkg.all;

entity InterruptControler is

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
	
end entity InterruptControler;

architecture RTL of InterruptControler is

	signal i_int_lines			: std_ulogic_vector(7 downto 0);
	signal i_int_mask			: std_ulogic_vector(7 downto 0);
	signal i_int_pending		: std_ulogic_vector(7 downto 0);
	signal i_int_current		: std_ulogic_vector(7 downto 0);	
	
begin
	i_int_lines <= IntLines;
	i_int_mask	<= IntMask;
	
	IntCurrent <= i_int_current;
	
	ack : for i in 0 to 7 generate 
	
		IntAckLines(i) <= i_int_current(i) and INTack;
	
	end generate;
	
	
	intctl : component interrupt_ctl
	
		generic map
			(
				RESET_ACTIVE_LEVEL	=> '0'
			)
		
		port map
		(
			Clock			=>	SysCtrl.Clock,
			Reset			=>	SysCtrl.nReset,
			
			Int_mask    	=>	i_int_mask,
			Int_request		=>	i_int_lines,
			Pending     	=>	i_int_pending,
			Current     	=>	i_int_current,

			Interrupt     	=>	INTreq,
			Acknowledge  	=>	INTack,
			Clear_pending 	=>  '0'
		);


end architecture RTL;	