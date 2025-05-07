#include <iostream>
#include <cuda_runtime.h>
using namespace std;

#define N 1000000

__global__ void add(int* A, int* B, int* C) {
    int i = threadIdx.x + blockIdx.x * blockDim.x;
    if (i < N) C[i] = A[i] + B[i];
}

int main() {
    int* A, * B, * C;
    cudaMallocManaged(&A, N * sizeof(int));
    cudaMallocManaged(&B, N * sizeof(int));
    cudaMallocManaged(&C, N * sizeof(int));

    for (int i = 0; i < N; i++) A[i] = rand() % 100, B[i] = rand() % 100;

    add <<<(N + 255) / 256, 256 >>> (A, B, C);
    cudaDeviceSynchronize();

    for (int i = 0; i < 5; i++)
        cout << A[i] << "+" << B[i] << "=" << C[i] << endl;

    cudaFree(A); cudaFree(B); cudaFree(C);
    return 0;
}





#include <iostream>
#include <cuda_runtime.h>
using namespace std;

#define N 5  // small size for easy printing

__global__ void mul(int* A, int* B, int* C) {
    int r = threadIdx.y + blockIdx.y * blockDim.y;
    int c = threadIdx.x + blockIdx.x * blockDim.x;
    if (r < N && c < N) {
        int sum = 0;
        for (int k = 0; k < N; k++)
            sum += A[r * N + k] * B[k * N + c];
        C[r * N + c] = sum;
    }
}

void printMatrix(int* M, string name) {
    cout << name << ":\n";
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++)
            cout << M[i * N + j] << " ";
        cout << endl;
    }
    cout << endl;
}

int main() {
    int* A, * B, * C;
    cudaMallocManaged(&A, N * N * sizeof(int));
    cudaMallocManaged(&B, N * N * sizeof(int));
    cudaMallocManaged(&C, N * N * sizeof(int));b;/

    for (int i = 0; i < N * N; i++) A[i] = rand() % 10, B[i] = rand() % 10;

    dim3 threads(N, N);
    mul << <1, threads >> > (A, B, C);
    cudaDeviceSynchronize();

    printMatrix(A, "Matrix A");
    printMatrix(B, "Matrix B");
    printMatrix(C, "Matrix C (Result)");

    cudaFree(A); cudaFree(B); cudaFree(C);
    return 0;
}