/*
 * d1sext.h
 *
 *  Created on: Feb 11, 2023
 *      Author: charlie
 */

#ifndef D1SEXT_H_
#define D1SEXT_H_

extern volatile unsigned char ClockCount[3]; // 3 byte bcd clock ClockCount[0] = seconds, ClockCount[1] = minutes, ClockCount[2] = hours

extern volatile unsigned char TokenIn;
extern volatile unsigned char TokenOut;
extern volatile unsigned char TokenBuf[TokenBufSize];

extern volatile unsigned char SaveKeys;
extern volatile unsigned char SaveSwitch;


extern void seg7_put(int segment_no, int value);
extern int s0_txchar(char c, FILE *stream);
extern int s0_rxchar(FILE *stream);
extern int s0_char_ready();

extern unsigned char RemoveToken();
extern void AddToken(unsigned char pToken);
extern void FlushTokens();

extern void instrs( void );
extern void instrs_end( void );
extern unsigned test_instr( unsigned );
extern void itsingle(int pTestInx);
extern int itmain( void );

#endif /* D1SEXT_H_ */
