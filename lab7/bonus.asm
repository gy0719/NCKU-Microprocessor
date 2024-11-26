#include "p18f4520.inc"

; CONFIG1H
  CONFIG  OSC = INTIO67         ; Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
  CONFIG  BORV = 3              ; Brown Out Reset Voltage bits (Minimum setting)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = PORTC        ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = ON           ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

; CONFIG4L
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) not protected from table reads executed in other blocks)
  
    org 0x00

goto Initial			; skip Interrupt
ISR:				; Interrupt
    org 0x08
    BTFSS PIR1, TMR2IF
    GOTO button
    GOTO timer
    button:
	INCF ls
	MOVLW 0x01
	CPFSEQ ts
	    GOTO time2
	CLRF ts
	MOVLW D'61'		
	MOVWF PR2
	GOTO changelight
	time2:
	    MOVLW D'122'		
	    MOVWF PR2
	    INCF ts
	    GOTO changelight
	changelight:
	    MOVLW 0x03
	    CPFSEQ ls
		GOTO checklight2
	    CLRF ls
	    CLRF count
	    GOTO buttonend
	checklight2:
	    MOVLW 0x01
	    CPFSEQ ls
		GOTO checklight3
	    CLRF count
	    GOTO buttonend
	checklight3:
	    MOVLW 0x0F
	    MOVWF count
	    GOTO buttonend
	buttonend:
	    BCF INTCON, INT0IF
	    RCALL change
	    RETFIE 
    timer:
	MOVLW 0x00
	CPFSEQ ls
	    GOTO check1
	INCF count
	MOVLW 0x08
	CPFSEQ count
	    GOTO timerend
	CLRF count
	GOTO timerend
	check1:
	    MOVLW 0x01
	    CPFSEQ ls
		GOTO check2
	    INCF count
	    MOVLW 0x10
	    CPFSEQ count
		GOTO timerend
	    CLRF count
	    GOTO timerend
	check2:
	    DECF count
	    MOVLW 0xFF
	    CPFSEQ count
		GOTO timerend
	    MOVLW 0x0F
	    MOVWF count
	    GOTO timerend
	timerend:
	BCF PIR1, TMR2IF        ; clear TIMER2 flag bit
	RCALL change
	RETFIE                    
    
    
Initial:		
    count EQU 0x01
    ts EQU 0x02
    ls EQU 0x03
    real EQU 0x04
    CLRF count
    MOVLW 0x00
    MOVWF ls
    MOVLW 0x00
    MOVWF ts
    MOVLW 0x0F
    MOVWF ADCON1
    CLRF TRISA
    CLRF LATA
    BSF RCON, IPEN
    BSF INTCON, GIE
    ;for button
    BCF INTCON, INT0IF		;clear Interrupt flag bit
    BSF INTCON, INT0IE		; turn interrupt0 enable bit on (INT0 is same as RB0 pin)
    ;fot timer
    BCF PIR1, TMR2IF		; to use TIMER2
    BSF IPR1, TMR2IP
    BSF PIE1 , TMR2IE
    MOVLW b'11111111'	        ; Prescale & Postscale both set to 1:16 so every 256 cycle TIMER2+1
    MOVWF T2CON		; TIMER is clock/4
    MOVLW D'61'		; so 256 * 4 = 1024 cycles TIMER2 + 1
    MOVWF PR2			; 250khz Delay 0.25 then 62500cycles occur Interrupt
				; PR 62500 / 1024 = 61.035 -> 61
    MOVLW D'00100000'
    MOVWF OSCCON	        ; clock is 250kHz
main:
    BRA main
change:
    MOVFF count,0x05
    MOVLW 0x04
    loop:
    RRCF 0x01
    RLCF real
    DECFSZ WREG
    BRA loop
    MOVFF 0x05,count
    MOVFF real,LATA
    RETURN
end


