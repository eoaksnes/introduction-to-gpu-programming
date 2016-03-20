#include <stdio.h>
#include <cuda_runtime.h>

__global__ void vectorAdd(float *d_A, float *d_B, float *d_C, int n) {
    //int i = blockDim.x * blockIdx.x + threadIdx.x;
    int i = threadIdx.x;
    // Make sure we do not go out of bounds.   
    if (i < n) {
        d_C[i] = d_A[i] + d_B[i];
    }
}

int main() {
    // Size of vectors
    int n = 16;

    // Size, in bytes, of each vector
    size_t bytes = n * sizeof(float);

    // Allocate memory for the host vectors
    float *h_A = (float *)malloc(bytes);
    float *h_B = (float *)malloc(bytes);
    float *h_C = (float *)malloc(bytes);
    
    // Initialize vectors
    for (int i = 0; i < n; ++i) {
      h_A[i] = 1; 
      h_B[i] = 2;
    }

    // Allocate memory for the device vectors
    float *d_A = NULL;
    cudaMalloc((void **)&d_A, bytes);
    float *d_B = NULL;
    cudaMalloc((void **)&d_B, bytes);
    float *d_C = NULL;
    cudaMalloc((void **)&d_C, bytes);
    
    // Copy the host vectors to the device    
    cudaMemcpy(d_A, h_A, bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, bytes, cudaMemcpyHostToDevice);

    // Execute the kernel
    int threadsPerBlock = 256;
    int blocksPerGrid =(n + threadsPerBlock - 1) / threadsPerBlock;
    //vectorAdd<<<blocksPerGrid, threadsPerBlock>>>(d_A, d_B, d_C, n);

    vectorAdd<<<1, n>>>(d_A, d_B, d_C, n);

    printf("Kernel launch with %d blocks of %d threads\n", blocksPerGrid, threadsPerBlock);

    // Copy the result back to the host result vector
    cudaMemcpy(h_C, d_C, bytes, cudaMemcpyDeviceToHost);

    // Sum up host result vector and print result divided by n, this should equal 4
    float sum = 0;
    int i;
    for(i=0; i<n; i++) {
        sum += h_C[i];
    }
    sum = sum/n;
    printf("Final result: %f\n", sum);

    // Free device global memory
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    // Free host memory
    free(h_A);
    free(h_B);
    free(h_C);

    // Explicitly destroys and cleans up all resources associated with the current device
    cudaDeviceReset();
    return 0;
}