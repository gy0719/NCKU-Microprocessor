#include "setting_hardaware/setting.h"
#include <stdlib.h>
#include "stdio.h"
#include "string.h"
#define _XTAL_FREQ 4000000
// using namespace std;

char str[20];
int interrupted = 0;
void Mode1(){   // Todo : Mode1
    LATA = (int)str[2] - 48;
    return ;
}
void Mode2(){   // Todo : Mode2 
    int limit = (int)str[2] - 48;
    int i = 0;
    while(1)
    {
        if(interrupted)
        {
            interrupted =0;
            break;
        }
        LATA = i++;
        __delay_ms(500);
        if(i == limit+1)
        {
            i = 0;
        }
    }
    return;
}
void main(void) 
{
    
    SYSTEM_Initialize();
    
    while(1) {
        strcpy(str, GetString()); // TODO : GetString() in uart.c
        if(str[0]=='m' && str[1]=='1' && str[2] != '\0'){ // Mode1
            Mode1();
            ClearBuffer();
        }
        else if(str[0]=='m' && str[1]=='2' && str[2] != '\0'){ // Mode2
            Mode2();
            ClearBuffer();  
            interrupted = 0;
        }
    }
    return;
}

void __interrupt(high_priority) Hi_ISR(void)
{
    LATA = 0;
    interrupted = 1;
    INTCONbits.INT0IF = 0;
}