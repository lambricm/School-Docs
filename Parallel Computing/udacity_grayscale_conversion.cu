//Name Removed

// Homework 1
// Color to Greyscale Conversion

#include "reference_calc.cpp"
#include "utils.h"
#include <stdio.h>

__global__
void rgba_to_greyscale(const uchar4* const rgbaImage,
                       unsigned char* const greyImage,
                       int numRows, int numCols)
{
  
  //get thread/block indexes
  int idx = blockIdx.x * blockDim.x + threadIdx.x;
  int idy = blockIdx.y * blockDim.y + threadIdx.y;
  
  //get pixel index
  int pix_index = (idx * numCols) + idy;
  
  //grab rgb data
  const uchar4 input_val = rgbaImage[pix_index];
  
  //greyscale the output
  greyImage[pix_index] = input_val.x * .299f + input_val.y * .587f + input_val.z * .114f;
}

void your_rgba_to_greyscale(const uchar4 * const h_rgbaImage, uchar4 * const d_rgbaImage,
                            unsigned char* const d_greyImage, size_t numRows, size_t numCols)
{
  
  // using 256 (16 * 16) thread per block
  // blocks should be picture divided into blocks of 256 pixels (rounded up), divided by 16 in x & y directions
  
  const dim3 gridSize(16,16,1);
  const dim3 blockSize(((numRows+15)/16),((numCols+15)/16),1);
  rgba_to_greyscale<<<gridSize, blockSize>>>(d_rgbaImage, d_greyImage, numRows, numCols);
  
  cudaDeviceSynchronize(); checkCudaErrors(cudaGetLastError());
}
