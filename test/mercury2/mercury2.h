/*
 * mercury2.h
 *
 *  Created on: Feb 18, 2023
 *      Author: charlie
 */

#ifndef MERCURY2_H_
#define MERCURY2_H_


#include <avr/io.h>

#define rnull			r1
#define DEFISR(n) 		_VECTOR(n): .global _VECTOR(n)

#define INTMASK			_SFR_IO8(1)
#define IMSER0			2
#define IMTM0			5

#define UTLPORT			_SFR_IO8(2)
#define ENATM0			0
#define ENASER0			1
#define SER0FLOW		2
#define SER0INT			3

#define SER0DATA		_SFR_IO8(14)
#define SER0STAT		_SFR_IO8(15)
#define SER0BTL			_SFR_IO8(16)
#define SER0BTH			_SFR_IO8(17)
#define SER0RXINT		7
#define SER0TXINT		8

#define SER0RXRDY		0
#define SER0RXOFL		1
#define SER0TXRDY		2

#define SER0NDTR		4
#define SER0NCTS		5
#define SER0RXBUSY		6
#define SER0TXBUSY		7

#define TM0CNTL			_SFR_IO8(10)
#define TM0CNTH			_SFR_IO8(11)
#define TM0CNTM			_SFR_IO8(12)
#define TM0INT			6

#define AOUTPORT		_SFR_IO8(8)
#define LEDPORT			_SFR_IO8(9)


#define TESTPORT		AOUTPORT


#endif /* MERCURY2_H_ */
