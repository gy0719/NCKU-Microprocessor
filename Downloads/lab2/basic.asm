List p=18f4520 
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00 ;PC = 0x00 
    LFSR 0, 0x100 ; FSR0 point to 0x000
    LFSR 1, 0x116 ; FSR2 point to 0x020
    MOVLW 0x01
    MOVWF INDF0	;[FSR0] = 0x00
    MOVLW 0x00
    MOVWF INDF1	;[FSR1] = 0x01
    
    MOVLW 0x06
    MOVWF 0x01
    loop:
	MOVFF POSTINC0,WREG	;WREG = [FSR0] FSR0++
	ADDWF INDF1,0	    ;WREG = WREG + [FSR1]
	MOVWF INDF0    ;[FSR0] = WREG
	MOVFF POSTDEC1,WREG	;WREG = [FSR1] FSR1--
	ADDWF INDF0,0	    ;WREG = WREG + [FSR0]
	MOVWF INDF1    ;[FSR1] = WREG
	DECFSZ 0x01
	    GOTO loop
	GOTO exit
    exit:
    end

