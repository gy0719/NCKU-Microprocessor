#include <xc.inc>
GLOBAL _gcd
PSECT mytext,local,class=CODE,reloc=2
_gcd:
    ah EQU 0x10
    al EQU 0x11
    bh EQU 0x20
    bl EQU 0x21
    MOVFF 0x001,al
    MOVFF 0x002,ah
    MOVFF 0x003,bl
    MOVFF 0x004,bh
    
    checka:
	TSTFSZ ah
	    GOTO checkb
	MOVLW 0x01
	CPFSEQ al
	    GOTO checkb	;check is 1
	MOVFF al,bl
	MOVFF ah,bh
	GOTO done
    checkb:
	TSTFSZ bh
	    GOTO loop
	MOVLW 0x01
	CPFSEQ bl
	    GOTO loop		;check is 1
	GOTO done
    loop:
	MOVFF ah,WREG
	IORWF al,W	    
	BZ done			;if is 0 
	
	MOVFF bh,WREG
	CPFSLT ah
	    GOTO checkseq   ;ah >= bh
	GOTO swap
    checkseq:
	CPFSEQ ah
	    GOTO sub
	GOTO checklow   
    checklow:
	MOVFF bl,WREG
	CPFSLT al
	    GOTO sub   ;ah >= bh
	GOTO swap
    sub:    
	CLRF STATUS,B
	MOVFF bl,WREG
	SUBWF al
	MOVFF bh,WREG
	SUBWFB ah
	GOTO loop
    swap:
	MOVFF ah,0x30
	MOVFF al,0x31
	MOVFF bh,ah
	MOVFF bl,al
	MOVFF 0x30,bh
	MOVFF 0x31,bl
	GOTO sub	
    done:
	MOVFF bl,WREG
	MOVWF 0x001
	MOVFF bh,WREG
	MOVWF 0x002
	
    RETURN
    


