LIST P=18F4520
    INCLUDE <p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF

    org 0x00  ; PC = 0x00
        CLRF 0x00
	CLRF 0x01
	CLRF 0x10
	CLRF 0x11
	CLRF 0x20
	CLRF 0x21
	MOVLW 0x01
        MOVWF 0x02  ; n
        MOVLW 0x01
        MOVWF 0x11  ; f(1) low bit
        RCALL fib
        GOTO exit

    fib:
    check0:
        TSTFSZ 0x02
        GOTO check1
        GOTO out

    check1:
	DECFSZ 0x02	;n-- if n = 1 then it will skip
	    GOTO loop
	MOVLW 0x01
	MOVWF 0x01
	GOTO out
    loop:
        MOVFF 0x21, WREG    ;WREG = f(n-2) low
        MOVFF 0x11, 0x01    ;f(n) low = f(n-1) low
        ADDWF 0x01	      ;f(n) low = f(n-1) low + f(n-2) low
        MOVFF 0x11, 0x21    ;f(n-1) low = next f(n-2) low
        MOVFF 0x01, 0x11    ;f(n) low = next f(n-1) low 
        MOVFF 0x20, WREG    ;WREG = f(n-2) high
        MOVFF 0x10, 0x00    ;f(n) high = f(n-1) high
        ADDWFC 0x00	      ;f(n) high = f(n-1) high + f(n-2) high + carry
        MOVFF 0x10, 0x20    ;f(n-1) high = next f(n-2) high
        MOVFF 0x00, 0x10    ;f(n) high = next f(n-1) high
	DECFSZ 0x02	      ;n-- if 0 then skip goto out
	    GOTO loop
    out:
        RETURN
    exit:
    end
