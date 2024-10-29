
#include <xc.inc>
GLOBAL _multi_signed
PSECT mytext,local,class=CODE,reloc=2
_multi_signed:
     MOVWF LATB	;a high
     MOVFF 0x01,LATD	;b 
     CLRF LATA		;a low
     CLRF 0x10	    ;change sing or not (change if it is 1)
     CLRF 0x20
     CLRF 0x21
     res_high EQU 0x20
     res_low EQU 0x21
     checka:
	BTFSS LATB,7	;check a's sign
	    GOTO checkb	;a is positive
	NEGF LATB
	INCF 0x10
     checkb:
	BTFSS LATD,7	;check b's sign
	    GOTO multi	;b is positive
	NEGF LATD
	INCF 0x10
     multi:
	BTFSS LATD,0
	    GOTO skip
	MOVFF LATB,WREG
	ADDWF res_low
	MOVFF LATA,WREG
	ADDWFC res_high
     skip:
	RLCF LATB   
	RLCF LATA
	
	CLRF STATUS,C
	RRCF LATD
	TSTFSZ LATD
	    GOTO multi
     check:	    
	BTFSS 0x10,0	    ;if is 0 or 2 then no need to change sign
	    GOTO done
	COMF res_high
	COMF res_low
	INCF res_low
	MOVLW 0x00
	ADDWFC res_high
     done:
	MOVFF res_low,0x001
	MOVFF res_high,0x002
     RETURN
    


