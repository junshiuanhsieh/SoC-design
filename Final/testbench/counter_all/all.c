#include "fir.h"
#include <defs.h>
#include <stdint.h>

#define FIR_AP        (*(volatile uint32_t*)0x30000100)
#define FIR_DATA_LEN  (*(volatile uint32_t*)0x30000110)
#define FIR_TAP_START (  volatile uint32_t*)0x30000140
#define FIR_DATA      (*(volatile uint32_t*)0x30000180)
#define FIR_ANS       (*(volatile uint32_t*)0x30000184)

#define MM_DATA       (*(volatile uint32_t*)0x30000280)
#define MM_ANS        (*(volatile uint32_t*)0x30000284)
 
#define QS_DATA       (*(volatile uint32_t*)0x30000380)
#define QS_ANS        (*(volatile uint32_t*)0x30000384)


int* __attribute__ ( ( section ( ".mprjram" ) ) ) all(){
	//initfir();
	
	if(AP & 0b100) { // ap_idle == 1
    		DATA_LEN = 11;
    		volatile uint32_t* tap_addr = TAP_START;
        	for (int i=0; i<11; i=i+1) {
            	*tap_addr = taps[i];
            	tap_addr++;
        	}
    	}
    	
    	while(!(AP & 0b100)) continue;
	AP = 1; // ap_start
	
    	for(int i=0; i<11; i=i+1) {
	    DATA = inputsignal[i];
	    outputsignal[i] = ANS;
	}
	while(!(AP & 0b10)) continue;
	
	return outputsignal;
}




		
