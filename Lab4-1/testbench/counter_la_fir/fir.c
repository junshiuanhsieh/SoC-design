#include "fir.h"

void __attribute__ ( ( section ( ".mprjram" ) ) ) initfir() {
	//initial your fir
	for (int i=0; i<N; i=i+1) inputbuffer[i] = 0; 
	for (int i=0; i<N; i=i+1) outputsignal[i] = 0; 
	return;
}

//int* fir(){
int* __attribute__ ( ( section ( ".mprjram" ) ) ) fir(){
	initfir();
	//write down your fir
	for (int i=0; i<N; i=i+1) {
		for (int j=N-1; j>0; j=j-1) inputbuffer[j] = inputbuffer[j-1];
		inputbuffer[0] = inputsignal[i];
		int temp = 0;
		for (int j=0; j<N; j=j+1) temp = temp + inputbuffer[j] * taps[j];
		outputsignal[i] = temp;
	}
	return outputsignal;
}

