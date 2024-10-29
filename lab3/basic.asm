List p=18f4520 
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00 ;PC = 0x00
    CLRF TRISA
    MOVLW 0xC8
    MOVWF TRISA	
    RLNCF TRISA	;left shift
    BCF TRISA,0		;set LSB 0 (logical left shift end
    MOVLW b'10000000'
    ANDWF TRISA,0	;get first is 0 or 1
    RRNCF TRISA
    BCF TRISA,7
    ADDWF TRISA	;arithmetic right shift 
    end


