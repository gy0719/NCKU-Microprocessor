List p=18f4520 
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    MOVLW 0x00
    MOVWF 0x00
    
    MOVLW 0x00
    MOVWF 0x01
    
    ADDWF 0x00, W   ;WREG=0x00+WREG(0x01)
    
    MOVWF 0x02
    
    MOVLW 0x00
    MOVWF 0x10
    
    MOVLW 0x00
    MOVWF 0x11
    
    SUBWF 0x10, W   ;WREG=0x10-WREG(0x11)
    
    MOVWF 0x12
    
    CPFSEQ 0x02	;check equal
	GOTO greater
    MOVLW 0xBB
    MOVWF 0x20
    GOTO exit
    greater:
	CPFSGT 0x02	;check greater
	    GOTO smaller
	MOVLW 0xAA
	MOVWF 0x20
	GOTO exit
    smaller:
	MOVLW 0xcc
	MOVWF 0x20
    exit:
	NOP
    end
    


