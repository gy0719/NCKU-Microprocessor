List p=18f4520 
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00 ;PC = 0x00

    Sub_Mul macro xh, xl, yh, yl 
	MOVLW xh
	MOVWF 0x20	;xh
	MOVLW xl	
	MOVWF 0x21	;xl
	MOVLW yh	
	MOVWF 0x30	;yh
	MOVLW yl
	MOVWF 0x31	;yl
	
	sub:
	SUBWF 0x21,0	;WREG = 0x21 - 0x31  
	MOVWF 0x01
	MOVFF 0x30,WREG
	SUBWFB 0x20,0	;WREG = 0x20 - 0x30 
	mul:
	MOVWF 0x00
	MULWF 0x01	;0x01 * 0x00
	MOVFF PRODH,0x10
	MOVFF PRODL,0x11
	endm
    Sub_Mul 0x03,0xA5,0x02,0xA7
    end