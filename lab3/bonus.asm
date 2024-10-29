List p=18f4520 
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00 ;PC = 0x00
    MOVLW 0xFF
    MOVWF 0x00
    MOVLW 0xF1
    MOVWF 0x01
    
    MOVLW 0x08	;i for check 0x00
    MOVWF 0x10
    
    MOVLW 0x08	;j for check 0x01
    MOVWF 0x11
 
    MOVLW 0x0F;for log answer
    MOVWF 0x12
    high_loop:
	BTFSC 0x00,7	
	    GOTO checkhigh	    ;1
	DECF 0x12	    ;log--
	RLNCF 0x00	    ;left shift
	BCF 0x00,0	    ;clear LSB to 0
	DECFSZ	0x10	    ;i--
	    GOTO high_loop
	GOTO low_loop
    low_loop:
	BTFSC 0x01,7	
	    GOTO checklow	    ;1
	DECF 0x12	    ;log--
	RLNCF 0x01	    ;left shift
	BCF 0x01,0	    ;clear LSB to 0
	DECFSZ	0x11	    ;j--
	    GOTO low_loop
	GOTO exit
    checkhigh:	    
	RLNCF 0x00
	BCF 0x00,0
	MOVLW 0x00
	CPFSGT 0x00
	    GOTO check
	INCF 0x12
	GOTO exit
	check:
	CPFSGT 0x01
	    GOTO exit
	INCF 0x12
	GOTO exit
    checklow:
	RLNCF 0x01
	BCF 0x01,0
	MOVLW 0x00
	CPFSGT 0x01
	    GOTO exit
	INCF 0x12
	GOTO exit
    exit:
	MOVFF 0x12,0x02
    end