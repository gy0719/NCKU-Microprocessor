#include <xc.h>
#include <pic18f4520.h>
#include <stdio.h>

#pragma config OSC = INTIO67 // Oscillator Selection bits
#pragma config WDT = OFF     // Watchdog Timer Enable bit
#pragma config PWRT = OFF    // Power-up Enable bit
#pragma config BOREN = ON    // Brown-out Reset Enable bit
#pragma config PBADEN = OFF  // Watchdog Timer Enable bit
#pragma config LVP = OFF     // Low Voltage (single -supply) In-Circute Serial Pragramming Enable bit
#pragma config CPD = OFF     // Data EEPROM Memory Code Protection bit (Data EEPROM code protection off)

#define _XTAL_FREQ 1000000 // Define clock frequency (1 MHz)

int preadcValue = 0;
void PWM_Init(void) {
    T2CONbits.TMR2ON = 1;         // Enable Timer2 for PWM operation
    T2CONbits.T2CKPS = 0b01;      // Set Timer2 prescaler to 4
    OSCCONbits.IRCF = 0b001;      // Set internal oscillator frequency to 1 MHz
    CCP1CONbits.CCP1M = 0b1100;   // Configure CCP1 module in PWM mode
    PR2 = 0x9B;                   // Set PWM period for desired frequency
}
void light(int duty) {
    // Set duty cycle (10-bit resolution: 8 MSBs in CCPR1L, 2 LSBs in CCP1CON)
    CCPR1L = duty >> 2;             // 8 MSBs
    CCP1CONbits.DC1B = duty & 0x03; // 2 LSBs
}
void __interrupt(high_priority)H_ISR(){
    
    //step4
    int value = ADRESH;
    
    if(value < 128){
        value *= 4;
    } else{
        value = (255 - value) *4;
    }
    
    light(value);
    //clear flag bit
    PIR1bits.ADIF = 0;
    
    // Delay at least 2 Tad (Tad = 2 us)
    __delay_us(5);

    // Start next ADC conversion
    ADCON0bits.GO = 1;

    return;
}
void main(void) 
{
    PWM_Init();
    //configure OSC and port
    OSCCONbits.IRCF = 0b100; //1MHz
    TRISAbits.RA0 = 1;       //analog input port
    TRISC = 0;  // Set PORTC as output
    LATC = 0;   // Clear PORTC data latch

    //step1
    ADCON1bits.VCFG0 = 0;
    ADCON1bits.VCFG1 = 0;
    ADCON1bits.PCFG = 0b1110; //AN0 is analog input,others are digital
    ADCON0bits.CHS = 0b0000;  //AN0 is analog input
    ADCON2bits.ADCS = 0b000;  //read table 000(1Mhz < 2.86Mhz)
    ADCON2bits.ACQT = 0b001;  //Tad = 2 us acquisition time so set 2Tad = 4 > 2.4
    ADCON0bits.ADON = 1;
    ADCON2bits.ADFM = 0;    //left justified 
    
    
    //step2
    PIE1bits.ADIE = 1;
    PIR1bits.ADIF = 0;
    INTCONbits.PEIE = 1;
    INTCONbits.GIE = 1;

    //step3
    ADCON0bits.GO = 1;
    
    while(1);
    
    return;
}
