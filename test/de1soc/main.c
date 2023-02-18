/*
 * main.c
 *
 *  Created on: Feb 11, 2023
 *      Author: charlie
 */


#include <stdio.h>
#include <avr/pgmspace.h>
#include <avr/interrupt.h>
#include "de1soc.h"
#include "d1sext.h"


FILE io_stream = FDEV_SETUP_STREAM(s0_txchar, s0_rxchar, _FDEV_SETUP_RW);


void initialize()
{
	// disable segment digits

	for (int i = 0; i < 6; ++i)
		seg7_put(i, i);

	// initialize key and switch

	TokenIn = 0;
	TokenOut = 0;

	SaveKeys = KEYIN;
	SaveSwitch = SWIN;

	KEYINTMSK = 0xff;
	SWINTMSK = 0xff;

	// initialize clock

	ClockCount[0] = 0x00;
	ClockCount[1] = 0x00;
	ClockCount[2] = 0x00;

	TM0CNTL	= 0x3f;	// count 39.999 + 1 = 40.000
	TM0CNTH	= 0x9c;
	TM0CNTM	= 0x31;	// multiply 49 + 1 = 50 * 40.000 = 2.000.000 - one second resolution

	// initialize I/O

    stdout = &io_stream;
    stdin  = &io_stream;

	UTLPORT = ((1 << ENASER0) | (1 << SER0FLOW) | (1 << ENATM0));
	//UTLPORT = ((1 << ENASER0) | (1 << ENATM0));
	INTMASK = ((1 << IMTM0) | (1 << IMKEY) | (1 << IMSW));

	sei();
}


void update_clock()
{
	seg7_put(0, ClockCount[0] & 0x0f);
	seg7_put(1, ClockCount[0] >> 4);
	seg7_put(2, ClockCount[1] & 0x0f);
	seg7_put(3, ClockCount[1] >> 4);
	seg7_put(4, ClockCount[2] & 0x0f);
	seg7_put(5, ClockCount[2] >> 4);
}

const char nl[] PROGMEM = "\r\n";
const char keyDNmsg[] PROGMEM = "key %d down\r\n";
const char keyUPmsg[] PROGMEM = "key %d up\r\n";
const char swONmsg[]  PROGMEM = "switch %d on\r\n";
const char swOFFmsg[] PROGMEM = "switch %d off\r\n";

int main()
{
	initialize();

	printf_P(nl);
	printf_P(nl);

	while (1)
	{
		unsigned char token = RemoveToken();
		unsigned char key =  (token >> 4) & 0x0f;

		switch (token & 0x0f)
		{
			case KeyDownToken :

				++LEDPORT;
				printf_P(keyDNmsg, key);

				if (key == 1)
				{
					itmain();
					FlushTokens();
				}

				break;

			case KeyUpToken :

				++LEDPORT;
				printf_P(keyUPmsg, key);
				break;

			case SwitchOnToken:

				printf_P(swONmsg, key);
				break;

			case SwitchOffToken:

				printf_P(swOFFmsg, key);
				break;

			case ClockToken:

				update_clock();
				break;

			default:

				if (s0_char_ready())
				{
					char c = getchar();

					if ((c > 31) && (c < 128))
							putchar(c);
				}
		}
	}

	return 0;
}
