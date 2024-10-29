List p=18f4520 
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    LFSR 0, 0x000 
    LFSR 1, 0x000 
    
    MOVLW 0x00 ; WREG = 0x28
    MOVWF POSTINC0 ;[0X000] = 0X08
    
    MOVLW 0x11 ; WREG = 0x08
    MOVWF POSTINC0 ;[0X001] = 0X08
    
    MOVLW 0x22 ; WREG = 0x08
    MOVWF POSTINC0 ;[0X002] = 0X08
    
    MOVLW 0x33 ; WREG = 0x08
    MOVWF POSTINC0 ;[0X003] = 0X08
    
    MOVLW 0x44 ; WREG = 0x08
    MOVWF POSTINC0 ;[0X004] = 0X08
    
    MOVLW 0x55 ; WREG = 0x08
    MOVWF POSTINC0 ;[0X005] = 0X08
    
    MOVLW 0x66 ; WREG = 0x08
    MOVWF INDF0 ;[0X006] = 0X08
    
    MOVLW 0x01	;0x10 target
    MOVWF 0x10
    MOVLW 0x00
    MOVWF 0x20	;0x20 left
    MOVLW 0x06
    MOVWF 0x30	;0x30 right
    
    loop:
	
	ADDWF 0x20,0	;WREG = left + right
	MOVWF 0x40	;0x40 = WREG
	RRNCF 0x40	;0x40/2 (right shift = mid
	BCF 0x40,7	;clear first bit
	MOVFF 0x40,WREG
	MOVFF PLUSW1,0x50   ;0x50 is the value of mid
	MOVFF 0x50,WREG     ;WREG = 0x50
	CPFSEQ 0x10	      ;check target is the same as mid 
	    GOTO midgreater
	GOTO equal
    midgreater:
	CPFSLT 0x10	 
	    GOTO midsmaller    ;target > mid
	MOVLW 0x01
	SUBWF  0x40	;mid - 1
	MOVFF 0x40,WREG	;WREG = mid - 1
	MOVWF 0x30  ;right = mid - 1
	BTFSC 0x30,7	;check whethr right is < 0 
	    GOTO exit
	CPFSGT 0x20 ;check whether left is bigger than right
	    GOTO loop
	GOTO exit
    midsmaller:
	MOVFF 0x40,WREG  ; WREG = mid
	ADDLW 0x01  ;mid + 1
	MOVWF 0x20  ;left = mid + 1
	MOVFF 0x30,WREG ;WREG = right
	CPFSGT 0x20 ;check whether left is bigger than right
	    GOTO loop
	GOTO exit
    equal:
	MOVLW 0xFF
	MOVWF 0x011
	GOTO?exit
    exit:
	
    end


