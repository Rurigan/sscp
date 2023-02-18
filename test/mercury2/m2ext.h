/*
 * m2ext.h
 *
 *  Created on: Feb 18, 2023
 *      Author: charlie
 */

#ifndef M2EXT_H_
#define M2EXT_H_


extern int s0_txchar(char c, FILE *stream);
extern int s0_rxchar(FILE *stream);
extern int s0_char_ready();

extern void instrs( void );
extern void instrs_end( void );
extern unsigned test_instr( unsigned );
extern void itsingle(int pTestInx);
extern int itmain( void );

#endif /* M2EXT_H_ */
