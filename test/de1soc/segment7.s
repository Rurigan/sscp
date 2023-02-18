/*
 * segment7.s
 *
 *  Created on: Feb 11, 2023
 *      Author: charlie
 */



#define __SFR_OFFSET 0

#include "de1soc.h"

seg7_put:
;
; void seg7_put(int segment_no, int value);
;
; IN - 	r25:r24 = segment no
;		r23:r22 = value
;
; call used  (r18-r27, r30-r31)	free use
; call saved (r2-r17, r28-r29)	unchanged
;
		.global	seg7_put
		.type   seg7_put, @function

		#define	segno r24
		#define val	r22


		clr		zh
		ldi		zl, SEGBASE + 0x20				; z points to segemnt base using memory map
		andi	segno, 0x7						; mask segment no
		add		zl, segno						; point to segemnt
		st		z, val							; set segemtn

		ret
