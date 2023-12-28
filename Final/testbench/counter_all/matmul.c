#include "matmul.h"
#include <defs.h>
#include <stdint.h>


//#define MM_DATA        (*(volatile uint32_t*)0x30000280)
//#define MM_ANS         (*(volatile uint32_t*)0x30000284)

#define MM_DMA_AP        (*(volatile uint32_t*)0x30000b00)
#define MM_DMA_DATA_LEN  (*(volatile uint32_t*)0x30000b10)
#define MM_DMA_ANS_LEN   (*(volatile uint32_t*)0x30000b14)
#define MM_DMA_DATA_ADDR (*(volatile uint32_t*)0x30000b20)
#define MM_DMA_ANS_ADDR  (*(volatile uint32_t*)0x30000b24)

int* __attribute__ ( ( section ( ".mprjram" ) ) ) matmul(){
	
	MM_DMA_ANS_LEN = 16;
    	MM_DMA_ANS_ADDR = (uint32_t)(MM_OUT);
    	MM_DMA_DATA_LEN = 32;
    	MM_DMA_DATA_ADDR = (uint32_t)(MM_IN1);
    	
    	while(!(MM_DMA_AP & 0b10)) continue; // DMA done
	return MM_OUT;
	
	/*
    	
	for(int i=0; i<16; i=i+1) {
	    MM_DATA = MM_IN1[i];
	}
	for(int i=0; i<16; i=i+1) {
	    MM_DATA = MM_IN2[i];
	}
	for(int i=0; i<16; i=i+1) {
	    MM_OUT[i] = MM_ANS;
	}
	return MM_OUT;
	*/
}
