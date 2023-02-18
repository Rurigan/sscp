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

entity AluAddBlock is

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
	
end entity;

architecture RTL of AluAddBlock is

	signal l : std_logic_vector(4 downto 0);
	signal m : std_logic_vector(3 downto 0);
	signal u : std_logic_vector(1 downto 0);

begin

	ADD : process(InstADD, InstADC, InstSUB, InstSBC, InstNEG, A, B, iC) begin
	
		if InstNEG then
	
            l  <= std_logic_vector(signed('1' & (not A(3 downto 0))) + to_signed(1,5));
			
		elsif InstSBC then

            l  <= std_logic_vector(signed('0' & A(3 downto 0)) - signed('0' & B(3 downto 0))) - std_logic_vector(to_signed(0, 4) & iC);

		elsif InstSUB  then
		
            l  <= std_logic_vector(signed('0' & A(3 downto 0)) - signed('0' & B(3 downto 0)));
			
		elsif InstADC then
		
			l <= std_logic_vector(unsigned("0" & A(3 downto 0)) + unsigned("0" & B(3 downto 0)))  +  std_logic_vector(to_signed(0, 4) & iC);
			
		else 
			
			l <= std_logic_vector(unsigned("0" & A(3 downto 0)) + unsigned("0" & B(3 downto 0)));
		
		end if;
	
	end process;

	
	process(InstADD, InstADC, InstSUB, InstSBC, InstNEG, A, B, l) begin
	
		if InstNEG then

            m  <= std_logic_vector(signed('1' & (not A(6 downto 4))) + signed(std_logic_vector(to_signed(0, 3)) & (not l(4))));
			
		elsif InstSUB or InstSBC then
	
            m  <= std_logic_vector(signed('0' & A(6 downto 4)) - signed('0' & B(6 downto 4))) - std_logic_vector(signed("000" & l(4 downto 4)));
	
		else

			m <= std_logic_vector(unsigned("0" & A(6 downto 4)) + unsigned("0" & B(6 downto 4))) + std_logic_vector(unsigned("000" & l(4 downto 4)));
			
		end if;
	
	end process;

	
	process(InstADD, InstADC, InstSUB, InstSBC, InstNEG, A, B, m) begin
	
		if InstNEG then
		
            u <= std_logic_vector(signed('1' & (not A(7 downto 7))) + signed(std_logic_vector(to_signed(0, 1)) & (not m(3))));
		
		elsif InstSUB or InstSBC then
		
            u <= std_logic_vector(signed('0' & A(7 downto 7)) - signed('0' & B(7 downto 7))) - std_logic_vector(signed('0' & m(3 downto 3)));
		
		else
		
			u <= std_logic_vector(unsigned('0' & A(7 downto 7)) + unsigned('0' & B(7 downto 7))) + std_logic_vector(unsigned('0' & m(3 downto 3)));
			
		end if;
	
	end process;
	
	
	process(l, m, u) begin
	
		result <= u(0) & m(2 downto 0) & l(3 downto 0); 
	
	    oH <= l(4);
        oC <= u(1);
        oV <= u(1) XOR m(3);

	end process;

end architecture;