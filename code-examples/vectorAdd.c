#include <stdio.h>
#include <stdlib.h>
 
int main(int argc, char *argv[]) {
    // Size of vectors
    int n = 50000;
 
    // Size, in bytes, of each vector
    size_t bytes = n*sizeof(float);

    // Allocate memory for input vectors
    float *a = (float*)malloc(bytes);
    float *b = (float*)malloc(bytes);
    // Allocate memory for result vector
    float *c = (float*)malloc(bytes);
 
    // Initialize input vectors
    int i;
    for(i=0; i<n; i++) {
        a[i] = 1;
        b[i] = 3;
    }
 
    // Do the addition
    for(i=0; i<n; i++){
        c[i] = a[i] + b[i];
    }
 
    // Sum up result vector and print result divided by n, this should equal 4
    float sum = 0;
    for(i=0; i<n; i++) {
        sum += c[i];
    }
    sum = sum / n;
    printf("final result: %f\n", sum);
 
    // Release memory
    free(a);
    free(b);
    free(c);
 
    return 0;
}