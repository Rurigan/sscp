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

entity LogicBlock is

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
	
end entity;


architecture RTL of LogicBlock is
begin

	LOG : process(InstAND, InstCOM, InstEOR, InstOR, A, B) begin
	
		if InstOR then
		
			for i in 0 to result'length - 1 loop
			
					result(i) <= A(i) or B(i);
					
			end loop;
	
		elsif InstEOR then
		
			for i in 0 to result'length - 1 loop
			
					result(i) <= A(i) xor B(i);
					
			end loop;
	
		elsif InstCOM then
		
			result <= "11111111" - A;
		
		else

			for i in 0 to result'length - 1 loop
			
					result(i) <= A(i) and B(i);
					
			end loop;
		
		end if;
	
	end process;

end architecture;