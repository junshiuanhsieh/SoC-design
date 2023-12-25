#include "qsort.h"
#include <defs.h>
#include <stdint.h>

#define DATA      (*(volatile uint32_t*)0x30000380)
#define ANS       (*(volatile uint32_t*)0x30000384)

int* __attribute__ ( ( section ( ".mprjram" ) ) ) qsort(){
	for(int i=0; i<SIZE; i=i+1) {
	    DATA = C[i];
	}
	for(int i=0; i<SIZE; i=i+1) {
	    OUT[i] = ANS;
	}
	return OUT;
}
