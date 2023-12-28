#ifndef __FIR_H__
#define __FIR_H__

#define N 11

int FIR_TAP[N] = {0,-10,-9,23,56,63,56,23,-9,-10,0};
int FIR_IN[N] = {1,2,3,4,5,6,7,8,9,10,11};
int FIR_OUT[N];
#endif

#ifndef _MATMUL_H
#define _MATMUL_H

#define MM_SIZE 4
	int MM_IN1[MM_SIZE*MM_SIZE] = {0, 1, 2, 3,
				  0, 1, 2, 3,
				  0, 1, 2, 3,
				  0, 1, 2, 3,
	};
	int MM_IN2[MM_SIZE*MM_SIZE] = {1, 2, 3, 4,
				  5, 6, 7, 8,
				  9, 10, 11, 12,
				  13, 14, 15, 16,
	};
	int MM_OUT[MM_SIZE*MM_SIZE];
#endif


#ifndef _QSORT_H
#define _QSORT_H

#define QS_SIZE 10
int QS_IN[QS_SIZE] = {893, 40, 3233, 4267, 2669, 2541, 9073, 6023, 5681, 4622};
int QS_OUT[QS_SIZE];
#endif
