List p=18f4520 
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    MOVLW 0xAA
    MOVWF 0x00
    MOVLW 0x10
    MOVWF 0x10
    
    MOVFF 0x00, WREG	;wreg=0x00
    x:
	BTFSC 0x00, 0
	GOTO y    ;0x000 is not 2's or 4's multiple	
	BTFSC 0x00, 1
	GOTO z	    ;0x000 is 2's multiple not 4's
	INCF 0x10
	INCF 0x10  ;0x000 is 4's multiple
	GOTO loop
    y:
	DECF 0x10  ;0x000 is not 2's or 4's multiple
	GOTO loop
    z:
	INCF 0x10  ;0x000 is 2's multiple not 4's
	GOTO loop
    loop:	
	RRNCF 0x00  ;right shift
	CPFSEQ 0x00 ;check whether after right shift is the same as origin
	    GOTO x
	GOTO exit      	
    exit:
	NOP	    
    end

