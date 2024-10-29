#include <xc.inc>
GLOBAL _mysqrt
PSECT mytext,local,class=CODE,reloc=2
_mysqrt:
    MOVWF LATD ;LATD is the target
    CLRF 0x10 ;clear a
    loop:
    INCF 0x10 ;a++
    MOVFF 0x10,WREG ;WREG = a
    MULWF 0x10 ;a^2
    TSTFSZ PRODH
	GOTO done
    MOVFF PRODL,WREG
    CPFSLT LATD 
	GOTO check  ;target >= a^2
    GOTO done	;target < a^2
    check:
    CPFSEQ LATD
	GOTO loop
    GOTO done	
    done:
	MOVFF 0x10,WREG
    RETURN


