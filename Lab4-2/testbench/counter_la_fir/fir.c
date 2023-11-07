#include "fir.h"
#include <stdint.h>
#include <defs.h>

#define AP        (*(volatile uint32_t*)0x30000000)
#define DATA_LEN  (*(volatile uint32_t*)0x30000010)
#define TAP_START (  volatile uint32_t*)0x30000040
#define DATA      (*(volatile uint32_t*)0x30000080)
#define ANS       (*(volatile uint32_t*)0x30000084)

void __attribute__ ( ( section ( ".mprjram" ) ) ) initfir() {
    //initial your fir
 
    return;
}

int* __attribute__ ( ( section ( ".mprjram" ) ) ) fir() {
    initfir();
    //write down your fir
    int test;
    if(AP & 0b100) { // ap_idle == 1
    	DATA_LEN = 600;
    	volatile uint32_t* tap_addr = TAP_START;
        for (int i=0; i<11; i=i+1) {
            *tap_addr = taps[i];
            tap_addr++;
        }
    }
        
    for(int j=0; j<3; j=j+1) {
	while(!(AP & 0b100)) continue;
	AP = 1; // ap_start
	for(int i=1; i<75; i=i+1) {
	    DATA = i;
	    reg_mprj_datal = ANS << 16;
	}
	for(int i=75; i>-75; i=i-1) {
	    DATA = i;
	    reg_mprj_datal = ANS << 16;
	}
	for(int i=-75; i<75; i=i+1) {
	    DATA = i;
	    reg_mprj_datal = ANS << 16;
	}
	for(int i=75; i>-75; i=i-1) {
	    DATA = i;
	    reg_mprj_datal = ANS << 16;
	}
	for(int i=-75; i<=0; i=i+1) {
	    DATA = i;
	    reg_mprj_datal = ANS << 16;
	}
	while(!(AP & 0b10)) continue;
    }
        
    
    
    return outputsignal;
}
		
