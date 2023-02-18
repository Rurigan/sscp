/*
 * serial.s
 *
 *  Created on: Feb 11, 2023
 *      Author: charlie
 */

#define __SFR_OFFSET 0

#include "de1soc.h"

s0_char_ready:
;
; int s0_char_ready()
;
; OUT -	r25:r24	= char ready if 1 else 0b
;
; call used  (r18-r27, r30-r31)	free use
; call saved (r2-r17, r28-r29)	unchanged

		.global	s0_char_ready
		.type   s0_char_ready, @function

		clr		r25								; default to no char
		clr		r24

		sbic	SER0STAT, SER0RXRDY				; is ready flag cleared skip
		inc		r24								; else char ready result

		ret


s0_txchar:
;
; int s0_txchar(char c, FILE *stream)
;
; IN - 	r25:r24 = char
;		r23:r22 = unused file pointer
;
; OUT -	r25:r24	= char
;
; call used  (r18-r27, r30-r31)	free use
; call saved (r2-r17, r28-r29)	unchanged

		.global	s0_txchar
		.type   s0_txchar, @function

		#define	char r24

1:		sbis	SER0STAT, SER0TXRDY				; wait for ready
		rjmp	1b

		out		SER0DATA, char					; transmit char

		ret


s0_rxchar:
;
; int s0_rxchar(FILE *stream)
;
; IN - 	r25:r24 = unused file pointer
;
; OUT -	r25:r24	= char
;
; call used  (r18-r27, r30-r31)	free use
; call saved (r2-r17, r28-r29)	unchanged

		.global	s0_rxchar
		.type   s0_rxchar, @function

		#define	char r24

1:		sbis	SER0STAT, SER0RXRDY				; char ready
		rjmp	1b

		in		char, SER0DATA					; read char
		mov		r25, rnull

		ret

