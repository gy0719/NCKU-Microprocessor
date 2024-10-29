#include <xc.h>

extern unsigned char mysqrt(unsigned char a);
//extern unsigned int gcd(unsigned int a,unsigned int b);
//extern unsigned int multi_signed(unsigned char a,unsigned char b);
void main(void) {
    volatile unsigned char result = mysqrt(255);
//    volatile unsigned int result = gcd(65535,12321);
//    volatile unsigned int result = multi_signed(-128,0);
    while(1);
    return;
}
