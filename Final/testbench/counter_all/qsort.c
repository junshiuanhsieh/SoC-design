#include "qsort.h"
#include <defs.h>
#include <stdint.h>

//#define DATA      (*(volatile uint32_t*)0x30000380)
//#define ANS       (*(volatile uint32_t*)0x30000384)

#define QS_DMA_AP        (*(volatile uint32_t*)0x30000c00)
#define QS_DMA_DATA_LEN  (*(volatile uint32_t*)0x30000c10)
#define QS_DMA_ANS_LEN   (*(volatile uint32_t*)0x30000c14)
#define QS_DMA_DATA_ADDR (*(volatile uint32_t*)0x30000c20)
#define QS_DMA_ANS_ADDR  (*(volatile uint32_t*)0x30000c24)

int* __attribute__ ( ( section ( ".mprjram" ) ) ) qsort(){

	QS_DMA_ANS_LEN = SIZE;
    	QS_DMA_ANS_ADDR = (uint32_t)(QS_OUT);
    	QS_DMA_DATA_LEN = SIZE;
    	QS_DMA_DATA_ADDR = (uint32_t)(QS_IN);
    	
    	while(!(QS_DMA_AP & 0b10)) continue; // DMA done
	return QS_OUT;


	/*
	for(int i=0; i<SIZE; i=i+1) {
	    DATA = C[i];
	}
	for(int i=0; i<SIZE; i=i+1) {
	    OUT[i] = ANS;
	}
	return OUT;
	*/
}
