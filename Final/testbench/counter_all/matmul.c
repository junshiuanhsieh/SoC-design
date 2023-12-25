#include "matmul.h"
#include <defs.h>
#include <stdint.h>


#define DATA      (*(volatile uint32_t*)0x30000280)
#define ANS       (*(volatile uint32_t*)0x30000284)

int* __attribute__ ( ( section ( ".mprjram" ) ) ) matmul(){

	for(int i=0; i<16; i=i+1) {
	    DATA = A[i];
	}
	for(int i=0; i<16; i=i+1) {
	    DATA = B[i];
	}
	for(int i=0; i<16; i=i+1) {
	    result[i] = ANS;
	}
	return result;
}
