List p=18f4520 
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00 ;PC = 0x00
    CLRF 0x20
    CLRF 0x21
    CLRF 0x22
    CLRF 0x23
    
    MOVLW 0x00
    MOVWF 0x02	
    MOVWF 0x03
    
    MOVLW 0x77
    MOVWF 0x00	
    MOVLW 0x77
    MOVWF 0x01	;multiplicand
   
    MOVLW 0x56
    MOVWF 0x10
    MOVLW 0x78
    MOVWF 0x11	;multiplier
    
    MOVLW d'16'	
    MOVWF 0x30	;count = 16
    
    check:
	BTFSS 0x11,0
	    GOTO skip
	MOVFF 0x01,WREG
	ADDWF 0x23
	
	MOVFF 0x00,WREG
	ADDWFC 0x22    
	
	MOVFF 0x03,WREG
	ADDWFC 0x21
	
	MOVFF 0x02,WREG
	ADDWFC 0x20
    skip:
	RLCF 0x01   
	RLCF 0x00
	RLCF 0x03
	RLCF 0x02
	BCF STATUS,C
	
	RRCF 0x10
	RRCF 0x11
	BCF STATUS,C
	
	DECFSZ	0x30	    
	    GOTO check
	GOTO exit
    exit:	
    end