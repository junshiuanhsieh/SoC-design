#include "fir.h"
#include <defs.h>
#include <stdint.h>

#define FIR_AP        (*(volatile uint32_t*)0x30000100)
#define FIR_DATA_LEN  (*(volatile uint32_t*)0x30000110)
#define FIR_TAP_START (  volatile uint32_t*)0x30000140
//#define FIR_DATA      (*(volatile uint32_t*)0x30000180)
//#define FIR_ANS       (*(volatile uint32_t*)0x30000184)

#define FIR_DMA_AP        (*(volatile uint32_t*)0x30000a00)
#define FIR_DMA_DATA_LEN  (*(volatile uint32_t*)0x30000a10)
#define FIR_DMA_ANS_LEN   (*(volatile uint32_t*)0x30000a14)
#define FIR_DMA_DATA_ADDR (*(volatile uint32_t*)0x30000a20)
#define FIR_DMA_ANS_ADDR  (*(volatile uint32_t*)0x30000a24)


int* __attribute__ ( ( section ( ".mprjram" ) ) ) fir(){
	if(FIR_AP & 0b100) { // ap_idle == 1
    		FIR_DATA_LEN = 11;
    		volatile uint32_t* tap_addr = FIR_TAP_START;
        	for (int i=0; i<11; i=i+1) {
            	    *tap_addr = FIR_TAP[i];
            	    tap_addr++;
        	}
    	}
    	FIR_DMA_ANS_LEN = 11;
    	FIR_DMA_ANS_ADDR = (uint32_t)(FIR_OUT);
    	FIR_DMA_DATA_LEN = 11;
    	FIR_DMA_DATA_ADDR = (uint32_t)(FIR_IN);
    	
    	
    	while(!(FIR_AP & 0b100)) continue;
	FIR_AP = 1; // ap_start
	
	
	while(!(FIR_DMA_AP & 0b10)) continue; // DMA done
	return FIR_OUT;
}



		
