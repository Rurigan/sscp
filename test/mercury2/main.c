/*
 * main.c
 *
 *  Created on: Feb 17, 2023
 *      Author: charlie
 */

#include <stdio.h>
#include <avr/pgmspace.h>
#include <avr/interrupt.h>
#include "mercury2.h"
#include "m2ext.h"

FILE io_stream = FDEV_SETUP_STREAM(s0_txchar, s0_rxchar, _FDEV_SETUP_RW);

const char nl[] PROGMEM = "\r\n";

void initialize()
{
    stdout = &io_stream;
    stdin  = &io_stream;

	UTLPORT = (1 << ENASER0);

	sei();
}

int main(void)
{
	initialize();
	printf_P(nl);
	printf_P(nl);
	itmain();
	return 0;
}

