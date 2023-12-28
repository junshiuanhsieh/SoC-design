#include "all.h"
#include <defs.h>
#include <stdint.h>

#define FIR_AP        (*(volatile uint32_t*)0x30000100)
#define FIR_DATA_LEN  (*(volatile uint32_t*)0x30000110)
#define FIR_TAP_START (  volatile uint32_t*)0x30000140
#define FIR_DATA      (*(volatile uint32_t*)0x30000180)
#define FIR_ANS       (*(volatile uint32_t*)0x30000184)

#define FIR_DMA_AP        (*(volatile uint32_t*)0x30000a00)
#define FIR_DMA_DATA_LEN  (*(volatile uint32_t*)0x30000a10)
#define FIR_DMA_ANS_LEN   (*(volatile uint32_t*)0x30000a14)
#define FIR_DMA_DATA_ADDR (*(volatile uint32_t*)0x30000a20)
#define FIR_DMA_ANS_ADDR  (*(volatile uint32_t*)0x30000a24)

#define MM_DMA_AP        (*(volatile uint32_t*)0x30000b00)
#define MM_DMA_DATA_LEN  (*(volatile uint32_t*)0x30000b10)
#define MM_DMA_ANS_LEN   (*(volatile uint32_t*)0x30000b14)
#define MM_DMA_DATA_ADDR (*(volatile uint32_t*)0x30000b20)
#define MM_DMA_ANS_ADDR  (*(volatile uint32_t*)0x30000b24)

#define QS_DMA_AP        (*(volatile uint32_t*)0x30000c00)
#define QS_DMA_DATA_LEN  (*(volatile uint32_t*)0x30000c10)
#define QS_DMA_ANS_LEN   (*(volatile uint32_t*)0x30000c14)
#define QS_DMA_DATA_ADDR (*(volatile uint32_t*)0x30000c20)
#define QS_DMA_ANS_ADDR  (*(volatile uint32_t*)0x30000c24)


int* __attribute__ ( ( section ( ".mprjram" ) ) ) all(){
	if(FIR_AP & 0b100) { // ap_idle == 1
    		FIR_DATA_LEN = 11;
    		volatile uint32_t* tap_addr = FIR_TAP_START;
        	for (int i=0; i<11; i=i+1) {
            	    *tap_addr = FIR_TAP[i];
            	    tap_addr++;
        	}
    	}
    	
    	while(!(FIR_AP & 0b100)) continue;
	FIR_AP = 1; // ap_start
	
    	FIR_DMA_ANS_LEN = 11;
    	FIR_DMA_ANS_ADDR = (uint32_t)(FIR_OUT);
    	FIR_DMA_DATA_LEN = 11;
    	FIR_DMA_DATA_ADDR = (uint32_t)(FIR_IN);
    	
    	MM_DMA_ANS_LEN = 16;
    	MM_DMA_ANS_ADDR = (uint32_t)(MM_OUT);
    	MM_DMA_DATA_LEN = 32;
    	MM_DMA_DATA_ADDR = (uint32_t)(MM_IN1);
    	
    	QS_DMA_ANS_LEN = QS_SIZE;
    	QS_DMA_ANS_ADDR = (uint32_t)(QS_OUT);
    	QS_DMA_DATA_LEN = QS_SIZE;
    	QS_DMA_DATA_ADDR = (uint32_t)(QS_IN);
    	
	
	while(!(FIR_DMA_AP & 0b10)) continue; // DMA done
	while(!(MM_DMA_AP & 0b10)) continue; // DMA done
	while(!(QS_DMA_AP & 0b10)) continue; // DMA done
	
	return FIR_OUT;
}


void __attribute__ ( ( section ( ".mprjram" ) ) ) check_ans(){

	reg_mprj_datal = 0xAB500000;
	reg_mprj_datal = FIR_OUT[0] << 16;
	reg_mprj_datal = FIR_OUT[1] << 16;
	reg_mprj_datal = FIR_OUT[2] << 16;
	reg_mprj_datal = FIR_OUT[3] << 16;
	reg_mprj_datal = FIR_OUT[4] << 16;
	reg_mprj_datal = FIR_OUT[5] << 16;
	reg_mprj_datal = FIR_OUT[6] << 16;
	reg_mprj_datal = FIR_OUT[7] << 16;
	reg_mprj_datal = FIR_OUT[8] << 16;
	reg_mprj_datal = FIR_OUT[9] << 16;
	reg_mprj_datal = FIR_OUT[10] << 16;
	
	reg_mprj_datal = 0xAB600000;
	
	reg_mprj_datal = MM_OUT[0] << 16;
	reg_mprj_datal = MM_OUT[1] << 16;
	reg_mprj_datal = MM_OUT[2] << 16;
	reg_mprj_datal = MM_OUT[3] << 16;
	reg_mprj_datal = MM_OUT[4] << 16;
	reg_mprj_datal = MM_OUT[5] << 16;
	reg_mprj_datal = MM_OUT[6] << 16;
	reg_mprj_datal = MM_OUT[7] << 16;
	reg_mprj_datal = MM_OUT[8] << 16;
	reg_mprj_datal = MM_OUT[9] << 16;
	reg_mprj_datal = MM_OUT[10] << 16;
	reg_mprj_datal = MM_OUT[11] << 16;
	reg_mprj_datal = MM_OUT[12] << 16;
	reg_mprj_datal = MM_OUT[13] << 16;
	reg_mprj_datal = MM_OUT[14] << 16;
	reg_mprj_datal = MM_OUT[15] << 16;

	reg_mprj_datal = 0xAB700000;
	
	reg_mprj_datal = QS_OUT[0] << 16;
	reg_mprj_datal = QS_OUT[1] << 16;
	reg_mprj_datal = QS_OUT[2] << 16;
	reg_mprj_datal = QS_OUT[3] << 16;
	reg_mprj_datal = QS_OUT[4] << 16;
	reg_mprj_datal = QS_OUT[5] << 16;
	reg_mprj_datal = QS_OUT[6] << 16;
	reg_mprj_datal = QS_OUT[7] << 16;
	reg_mprj_datal = QS_OUT[8] << 16;
	reg_mprj_datal = QS_OUT[9] << 16;
	
	
}

/*
void __attribute__ ( ( section ( ".mprjram" ) ) ) check_ans(){

	reg_mprj_datal = 0xAB500000;
	for(int i = 0; i < 11; i++){
	    reg_mprj_datal = FIR_OUT[i] << 16;
	}
	
	reg_mprj_datal = 0xAB600000;
	
	for(int i = 0; i < 16; i++){
	    reg_mprj_datal = MM_OUT[i] << 16;
	}

	reg_mprj_datal = 0xAB700000;
	
	for(int i = 0; i < 10; i++){
	    reg_mprj_datal = QS_OUT[i] << 16;
	}
	
	
}
*/

		
