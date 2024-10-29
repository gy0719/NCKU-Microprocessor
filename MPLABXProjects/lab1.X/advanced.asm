List p=18f4520 
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    MOVLW 0xF7
    MOVWF 0x00
    ANDLW 0xF0	;WREG=WREG and 0x11110000
    MOVWF 0x02
    
    MOVLW 0X9F
    MOVWF 0x01
    ANDLW 0x0F	;WREG=WREG and 0x00001111
    ADDWF 0x02
    
    MOVLW 0x08
    MOVWF 0x03
    MOVLW 0x00
    loop:
	BTFSS 0x02,0	;check 0 or not
	    ADDLW 0x01
	RRNCF 0x02
	DECFSZ 0x03	;0 goto exit not 0 goto loop
	    GOTO loop
	GOTO exit    
    exit:
	MOVWF 0x03
    end


