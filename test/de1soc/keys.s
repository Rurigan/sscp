/*
 * keys.s
 *
 *  Created on: Feb 14, 2023
 *      Author: charlie
 */

#define __SFR_OFFSET 0

#include "de1soc.h"

		.data

TokenBuf:
		.global TokenBuf

TokenOut:

		.global TokenOut
		.skip	1

TokenIn:

		.global TokenIn
		.skip	1

		.skip	TokenBufSize


SaveKeys:

		.global SaveKeys
		.skip	1

SaveSwitch:

		.global SaveSwitch
		.skip	1


		.text

FlushTokens:
;
; zap tokens que
;
		.global	FlushTokens

		in		r22, SREG
		cli
		clr		r21
		sts		(TokenIn), r21
		sts		(TokenOut), r21

		out		SREG, r22
		ret


RemoveToken:
;
; OUT:	r24 = token
;
; destroy: z, r18, r19, r20, r21, r22
;
		.global	RemoveToken

		in		r22, SREG						; save interrupt flag
		cli										; disbale interrupt
		push	rnull
		clr		rnull
		ldi		zl, lo8(TokenBuf)				; point to token buffer
		ldi		zh, hi8(TokenBuf)
		clr		r24								; null token
		ld		r18, z+							; get token out index
		ld		r19, z+							; get token in index

		cp		r18, r19						; is buffer empty
		breq	9f								; yes - abort

		movw	r20, zl							; save z register

		add		zl, r18							; point to token in buffer
		adc		zl, rnull
		ld		r24, z							; get token
		inc		r18								; inc index
		andi	r18, TokenInxMask				; and normalize

		movw	zl, r20							; restore z reg

		st		-z, r19							; save token in index
		st		-z, r18							; save token out index
9:
		pop		rnull
		out		SREG, r22						; restore interrupt flag
		ret


AddToken:
;
; IN:	r24 = token
;
; destroy: z, r18, r19, r20, r21, r22
;
		.global	AddToken

		in		r22, SREG						; save interrupt flag
		cli										; disbale interrupt
		push	rnull
		push	r16
		clr		rnull
		ldi		zl, lo8(TokenBuf)				; point to token buffer
		ldi		zh, hi8(TokenBuf)
		ld		r18, z+							; get token out index
		ld		r19, z+							; get token in index

		mov		r16, r19
		inc		r19								; inc index
		andi	r19, TokenInxMask				; and normalize
		cp		r18, r19						; is buffer full
		breq	9f								; yes - abort

		movw	r20, zl							; save z register

		add		zl, r16							; point to token in buffer
		adc		zl, rnull
		st		z, r24							; put token

		movw	zl, r20							; restore z reg

		st		-z, r19							; save token in index
		st		-z, r18							; save token out index
9:
		pop		r16
		pop		rnull
		out		SREG, r22						; restore interrupt flag
		ret



KeysISR: DEFISR(KEYINT)

		push	r16
		push	r17
		push	r18
		push	r19
		push	r20
		push	r21
		push	r22
		push	r24
		push	zl
		push	zh
		in		r17, SREG

		lds		r18, (SaveKeys)
		in		r19, KEYIN
		mov		r16, r19						; save input
		mov		r20, r19						; copy input
		eor		r20, r18						; changed keys
		clr		r21								; key no

4:		lsr		r20								; key changed
		brcc	8f

		mov		r24, r21						; key no
		lsl		r24								; shift key no to high nible
		lsl		r24
		lsl		r24
		lsl		r24
		lsr		r19								; on/off bit to carry
		brcs	5f								; jump if on
		ori		r24, KeyUpToken
		rjmp	6f

5:		ori		r24, KeyDownToken

6:		push	r18
		push	r19
		push	r20
		push	r21
		call	AddToken
		pop		r21
		pop		r20
		pop		r19
		pop		r18

		rjmp	9f

8:		lsr		r19
9:		inc		r21								; increment key no
		cpi		r21, 6							; all bits done
		brne	4b								; else do next bit

		sts		(SaveKeys), r16					; save input

		out		SREG, r17
		pop		zh
		pop		zl
		pop		r24
		pop		r22
		pop		r21
		pop		r20
		pop		r19
		pop		r18
		pop		r17
		pop		r16

		reti


SwitchISR: DEFISR(SWINT)

		push	r16
		push	r17
		push	r18
		push	r19
		push	r20
		push	r21
		push	r22
		push	r24
		push	zl
		push	zh
		in		r17, SREG

		lds		r18, (SaveSwitch)
		in		r19, SWIN
		mov		r16, r19						; save input
		mov		r20, r19						; copy input
		eor		r20, r18						; changed keys
		clr		r21								; key no

4:		lsr		r20								; key changed
		brcc	8f

		mov		r24, r21						; key no
		lsl		r24								; shift key no to high nible
		lsl		r24
		lsl		r24
		lsl		r24
		lsr		r19								; on/off bit to carry
		brcs	5f								; jump if on
		ori		r24, SwitchOffToken
		rjmp	6f

5:		ori		r24, SwitchOnToken

6:		push	r18
		push	r19
		push	r20
		push	r21
		call	AddToken
		pop		r21
		pop		r20
		pop		r19
		pop		r18

		rjmp	9f

8:		lsr		r19
9:		inc		r21								; increment key no
		cpi		r21, 8							; all bits done
		brne	4b								; else do next bit

		sts		(SaveSwitch), r16				; save input

;		ldi		r24, SwitchToken
;		rcall	AddToken

		out		SREG, r17
		pop		zh
		pop		zl
		pop		r24
		pop		r22
		pop		r21
		pop		r20
		pop		r19
		pop		r18
		pop		r17
		pop		r16

		reti
