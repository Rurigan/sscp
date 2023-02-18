/*
The MIT License (MIT)

Copyright (c) 2013 Shay Green

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

https://github.com/gblargg/avr-instrtest

*/

#include <stdio.h>
#include <avr/pgmspace.h>
#include "de1soc.h"
#include "d1sext.h"

static PROGMEM const unsigned crcs [] = {
	#include "itcorrect.h"
};

const char msgnl[] PROGMEM = "\r\n";
const char msgstart[] PROGMEM =  "// Starting\n";
const char msghead[] PROGMEM =  "%3d:+0x%03x:0x%04X,";
const char msgmis[] PROGMEM =  " // mismatch table shows 0x%04X";
const char msgskip[] PROGMEM =  " skip slot";
const char msgpass[] PROGMEM =  "// Passed\n\r";
const char msgfail[] PROGMEM =  "// Failed\n\r";
const char msgport[] PROGMEM =  "TESTPORT not acting like R/W bits\n";

void itsingle(int pTestInx)
{
	unsigned addr = (unsigned) &instrs;
	const unsigned* p = crcs;
	unsigned crc;
	unsigned correct;

	int tmp = pTestInx;

	TESTPORT = 0;

	while (tmp > 0)
	{
		++p;
		addr += 2;

		if ( pgm_read_word( addr*2+2 ) == 0 )
			addr += 2;

		--tmp;
	}

	crc = test_instr( addr );
	correct = pgm_read_word( p );

	printf_P(msghead, pTestInx, addr*2, crc );

	if ( crc != correct )
	{
		printf_P(msgmis, correct );
	}
}


int itmain( void )
{
	printf_P(msgstart);

	// Be sure that port B acts like an 8-bit RAM location (used in test)
	{
		uint8_t b = 0x55;
		do
		{
			TESTPORT = b;
			if ( TESTPORT != b )
			{
				printf_P(msgport);
				return 0;
			}
		}
		while ( --b );
	}
	
	// without this linker strips table from asm code
	static volatile char c = 123;
	c = 0;

	int test_inx = 0;
	char failed = 0;
	unsigned addr = (unsigned) &instrs;
	const unsigned* p = crcs;

	while ( addr < (unsigned) &instrs_end )
	{
		unsigned crc = test_instr( addr );
		unsigned correct = pgm_read_word( p++ );

		printf_P(msghead, test_inx, addr*2, crc );

		if ( crc != correct )
		{
			printf_P(msgmis, correct );
			failed = 1;
		}

		addr += 2;

		if ( pgm_read_word( addr*2+2 ) == 0 )
		{
			// prev instr was a skip which uses four slots, so skip the last two
			printf_P(msgskip);
			addr += 2;
		}

		++test_inx;

		printf_P(msgnl);
	}

	
	if ( !failed )
		printf_P(msgpass);
	else
		printf_P(msgfail);
	
	return 0;
}
