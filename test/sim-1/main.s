/*
 * main.s
 *
 *  Created on: Jun 27, 2021
 *      Author: charlie
 */

#define __SFR_OFFSET 0
#include <avr/io.h>

main:

		.global	main
		.type	main, @function

		rjmp	boot
		rjmp	proc2

		nop
		nop
		nop
done:
		reti
		nop
		nop

proc2:

		nop
		nop

		ret


boot:

		ldi		r18, 0xff
		ldi		r19, 0x04

		out		SPL, r18
		out		SPH, r19

		rcall	proc1
		rjmp	done

		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop

proc1:

		in		r16, SPL
		in		r17, SPH
		rcall	proc2
		ret






