# 0 "fir.c"
# 1 "/home/ubuntu/SoC/lab4-1/testbench/counter_la_fir//"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "fir.c"
# 1 "fir.h" 1





int taps[11] = {0,-10,-9,23,56,63,56,23,-9,-10,0};
int inputbuffer[11];
int inputsignal[11] = {1,2,3,4,5,6,7,8,9,10,11};
int outputsignal[11];
# 2 "fir.c" 2

void __attribute__ ( ( section ( ".mprjram" ) ) ) initfir() {

 for (int i=0; i<11; i=i+1) inputbuffer[i] = 0;
 for (int i=0; i<11; i=i+1) outputsignal[i] = 0;
 return;
}


int* __attribute__ ( ( section ( ".mprjram" ) ) ) fir(){
 initfir();

 for (int i=0; i<11; i=i+1) {
  for (int j=11 -1; j>0; j=j-1) inputbuffer[j] = inputbuffer[j-1];
  inputbuffer[0] = inputsignal[i];
  int temp = 0;
  for (int j=0; j<11; j=j+1) temp = temp + inputbuffer[j] * taps[j];
  outputsignal[i] = temp;
 }
 return outputsignal;
}
