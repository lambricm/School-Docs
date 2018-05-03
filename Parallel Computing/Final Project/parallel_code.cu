#include <vector>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/reduce.h>
#include <thrust/count.h>
#include <thrust/functional.h>
#include <thrust/sort.h>
#include <iostream>
#include <thrust/extrema.h>
#include <stdlib.h>
#include <time.h>

namespace parallel{

template <class T>
//Retrieves indicies where data from nodes should be forwarded
__global__ void TEEN_indexes(T *d_vals, int *d_ind, T* h_thres_top, T* h_thres_bot, T* s_thres){

	int i = threadIdx.x + blockIdx.x * blockDim.x;
	
	//get indexes of values we want
	if ((d_vals[i] > *h_thres_top) || (d_vals[i] < *h_thres_bot)){
		//if the values exceed the given thresholds, collect index
		d_ind[i]= 1;
	}
	else if (i > 0){
		if (abs(d_vals[i] - d_vals[i-1]) > *s_thres){
			//or if the values changed more than the soft threshold from the last value, collect index
			d_ind[i] = 1;
		}
	}
}

template <class T>
__global__ void compact(T* d_vals, int* d_ind, T* d_vals_out){
	int i = threadIdx.x + blockIdx.x * blockDim.x;

	if (((i == 0) && (d_ind[i] == 1)) || ((i>0) && (d_ind[i] > d_ind[i-1]))){
		d_vals_out[d_ind[i]-1] = d_vals[i];
	}
}

template <class T>
std::vector<T>* TEEN(std::vector<T>* in, T h_thres_top, T h_thres_bot, T s_thres){
	//own algorithms

	int size = in->size();
	
	T arr[size];
	std::copy(in->begin(),in->end(), arr);

	int arr_ind[size];
	for (int i = 0; i < size;i++){
		arr_ind[i] = 0;
	}

	//device values
	T *d_arr;
	T *d_h_thres_top, *d_h_thres_bot, *d_s_thres;
	int *d_arr_ind;

	//allocate space for the values & copy memory there
	cudaMalloc((void**)&d_arr, size*sizeof(T));
	cudaMalloc((void**)&d_arr_ind, size*sizeof(int));
	cudaMalloc((void**)&d_h_thres_top, sizeof(int));
	cudaMalloc((void**)&d_h_thres_bot, sizeof(int));
	cudaMalloc((void**)&d_s_thres, sizeof(int));

	cudaMemcpy(d_arr, arr, size * sizeof(T),cudaMemcpyHostToDevice);
	cudaMemcpy(d_arr_ind, arr_ind, size * sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(d_h_thres_top, &h_thres_top, sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(d_h_thres_bot, &h_thres_bot, sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(d_s_thres, &s_thres, sizeof(int),cudaMemcpyHostToDevice);

	//get indexes for data we want
	TEEN_indexes<T><<<(size+266)/256, 256>>>(d_arr, d_arr_ind, d_h_thres_top, d_h_thres_bot, d_s_thres);

	//we can now free some values
	cudaFree(d_h_thres_top);
	cudaFree(d_h_thres_bot);
	cudaFree(d_s_thres);

	//copy values into thrust device pointer
	thrust::device_ptr<int> d_ptr = thrust::device_malloc<int>(size);
    	thrust::copy(&d_arr_ind[0], &d_arr_ind[0]+size, d_ptr);
	thrust::device_vector<int> d_vec(d_ptr,d_ptr + size);

	//run a sum for the value count
	int sum_ind = thrust::reduce(d_vec.begin(),d_vec.end(), 0, thrust::plus<int>());
	
	//run an inclusive scan
	thrust::inclusive_scan(d_vec.begin(),d_vec.end(),d_vec.begin());
	
	//copy values back into original array
	thrust::copy(d_vec.begin(),d_vec.end(),d_arr_ind);

	//create compacted array
	T comp_array[sum_ind];
	T* d_comp_array;

	cudaMalloc((void**)&d_comp_array, sum_ind*sizeof(T));
	cudaMemset(&d_comp_array,  0, sum_ind*sizeof(T));

	compact<T><<<(size+266)/256, 256>>>(d_arr, d_arr_ind, d_comp_array);

	cudaFree(d_arr);
	cudaFree(d_arr_ind);
	
	cudaMemcpy(comp_array, d_comp_array, sum_ind * sizeof(T),cudaMemcpyDeviceToHost);

	cudaFree(d_comp_array);

	std::vector<T> tmp(comp_array, comp_array + sum_ind);
	std::vector<T>* ret = new std::vector<T>(tmp);

	return ret;
}

template <class T>
__global__ void DSSS_operation(T* vals, T* pattern){
	int i = threadIdx.x + blockIdx.x * blockDim.x;

	//use bitwise operator to perform xor
	vals[i] = vals[i] ^ pattern[i];
}

template <class T>
void DSSS_encrypt(std::vector<T>* in,T* pattern_arr, T* vals){
	int size = in->size();

	//get random values for encryption
	srand(time(NULL));
	for(int i = 0; i< size;i++){
		pattern_arr[i] = rand();
	}

	//copy values, prepare memory
	T *d_vals, *d_pattern;
	std::copy(in->begin(),in->end(), vals);

	cudaMalloc((void**)&d_vals, size*sizeof(T));
	cudaMalloc((void**)&d_pattern, size*sizeof(T));

	cudaMemcpy(d_vals, vals, size*sizeof(T),cudaMemcpyHostToDevice);
	cudaMemcpy(d_pattern, pattern_arr, size*sizeof(T),cudaMemcpyHostToDevice);

	DSSS_operation<T><<<(size+266)/256, 256>>>(d_vals, d_pattern);

	cudaFree(d_pattern);

	cudaMemcpy(vals, d_vals, size*sizeof(T), cudaMemcpyDeviceToHost);
	cudaFree(d_vals);

}

template <class T>
void DSSS_decrypt(std::vector<T>* vals, T* pattern_arr, T* in){
	int size = vals->size();

	T *d_vals, *d_pattern;

	cudaMalloc((void**)&d_vals, size*sizeof(T));
	cudaMalloc((void**)&d_pattern, size*sizeof(T));

	cudaMemcpy(d_vals, in, size*sizeof(T),cudaMemcpyHostToDevice);
	cudaMemcpy(d_pattern, pattern_arr, size*sizeof(T),cudaMemcpyHostToDevice);

	DSSS_operation<T><<<(size+266)/256, 256>>>(d_vals, d_pattern);

	cudaFree(d_pattern);

	cudaMemcpy(in, d_vals, size*sizeof(T), cudaMemcpyDeviceToHost);
	cudaFree(d_vals);

	std::vector<T> temp (in, in + sizeof(in) / sizeof(in[0]));
	vals = new std::vector<T>(temp);
}

template <class T>
int reduce(std::vector<T>* in){
	thrust::host_vector<T> h_vec = *in;
	thrust::device_vector<T> d_vec = h_vec;

	T sm = thrust::reduce(d_vec.begin(),d_vec.end(), 0, thrust::plus<T>());
	return sm;
}

template <class T>
float average(std::vector<T>* in){
	T sm = reduce(in);
	return sm/(static_cast<float>(in->size()));
}

template <class T>
int count(std::vector<T>* in, T &val){
	thrust::host_vector<T> h_vec = *in;
	thrust::device_vector<T> d_vec = h_vec;

	return thrust::count(d_vec.begin(),d_vec.end(), val);
}

template <class T>
void inclusive_scan(std::vector<T> &in){
	thrust::host_vector<T> h_vec = in;
	thrust::device_vector<T> d_vec = h_vec;

	thrust::inclusive_scan(d_vec.begin(),d_vec.end(),d_vec.begin());

	h_vec = d_vec;
	for (int i = 0;i < h_vec.size(); i++){
		in[i] = h_vec[i];
	}
}

template <class T>
void exclusive_scan(std::vector<T> &in){
	thrust::host_vector<T> h_vec = in;
	thrust::device_vector<T> d_vec = h_vec;

	thrust::exclusive_scan(d_vec.begin(),d_vec.end(),d_vec.begin());

	h_vec = d_vec;
	for (int i = 0;i < h_vec.size(); i++){
		in[i] = h_vec[i];
	}
}

template <class T>
int minimum(std::vector<T>* in){
	thrust::host_vector<T> h_vec = *in;
	thrust::device_vector<T> d_vec = h_vec;

	return *thrust::min_element(d_vec.begin(),d_vec.end());
}

template <class T>
int maximum(std::vector<T>* in){
	thrust::host_vector<T> h_vec = *in;
	thrust::device_vector<T> d_vec = h_vec;

	return *thrust::max_element(d_vec.begin(),d_vec.end());
}

}

template <class T>
std::vector<T>* TEEN (std::vector<T> &in, T h_thres_top, T h_thres_bot, T s_thres){
	std::vector<T>* out = new std::vector<T>();

	for (int i = 0;i < in.size();i++){

		if ((in[i] > h_thres_top) || (in[i] < h_thres_bot)){
			//if the values exceed the given thresholds, collect index
			out->push_back(in[i]);
		}
		else if (i > 0){
			if (abs(in[i] - in[i-1]) > s_thres){
				//or if the values changed more than the soft threshold from the last value, collect index
				out->push_back(in[i]);
			}
		}
	}

	return out;
}

template <class T>
void DSSS_encrypt(std::vector<T>* in, T* pattern_arr, T* vals){
	int size = in->size();

	//get random values for encryption
	srand(time(NULL));
	for(int i = 0; i< size;i++){
		pattern_arr[i] = rand();
	}

	for(int i = 0; i < size;i++){
		vals[i] = (in->at(i) ^ pattern_arr[i]);
	}
}

template <class T>
void DSSS_decrypt(std::vector<T>* in, T* pattern_arr, T* vals){
	int size = in->size();

	for(int i = 0; i < size;i++){
		vals[i] = in->at(i) ^ pattern_arr[i];	
	}
}


/* //Example Funciton calls
int main(){

	static const int arr[] = {12,13,57,91,99,123,50};
	std::vector<int> temp (arr, arr + sizeof(arr) / sizeof(arr[0]));

	std::vector<int>* vals = parallel::TEEN<int>(&temp, 100, 15, 50);

	//repetative pattern for encrypting
	int pattern_arr[temp.size()];
	int vals2[temp.size()];

	parallel::DSSS_encrypt<int>(&temp, pattern_arr, vals2);

	parallel::DSSS_decrypt<int>(&temp, pattern_arr, vals2);
	
	std::cout << parallel::maximum(&temp);
	parallel::sort(vals);

	vals = TEEN<int>(temp, 100, 15, 50);

	DSSS_encrypt<int>(&temp, pattern_arr, vals2);

	DSSS_decrypt<int>(&temp, pattern_arr, vals2);
	return 0;	
}*/
