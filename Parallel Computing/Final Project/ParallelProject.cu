#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>
#include <algorithm>
#include <numeric>
#include <typeinfo>
#include "./parallel_code.cu"

template <class T>
T sum(std::vector<T> data) {
	T result = std::accumulate(data.begin(), data.end(), T());
	return result;
}

float average(std::vector<std::string> data) {
	std::cout << "Invalid: Cannot average string type" << std::endl;
	return 0.0;
}

float average(std::vector<int> data) {
	float result = 1.0 * sum(data) / data.size();
	return result;
}

float average(std::vector<float> data) {
	float result = 1.0 * sum(data) / data.size();
	return result;
}

template <class T>
T min(std::vector<T> data) {
	T result = *(std::min_element(data.begin(), data.end()));
	return result;
}

template <class T>
T max(std::vector<T> data) {
	T result = *(std::max_element(data.begin(), data.end()));
	return result;
}

std::vector<std::string> scan(std::vector<std::string> data, bool inclusive)
{
	std::cout << "Invalid: Cannot scan strings" << std::endl;
	return data;
}

std::vector<float> scan(std::vector<float> data, bool inclusive)
{
	std::vector<float> results;
	if (inclusive)
	{
		for (int i = 0; i < data.size(); i++)
		{
			if (i > 0)
			{
				results.push_back(data[i] + results[i - 1]);
			}
			else
			{
				results.push_back(data[i]);
			}
		}
	}
	else
	{
		std::vector<float> inclusiveResults = scan(data, true);
		for (int i = 0; i < data.size(); i++)
		{
			results.push_back(inclusiveResults[i] - data[i]);
		}
	}
	return results;
}

std::vector<int> scan(std::vector<int> data, bool inclusive)
{
	std::vector<int> results;
	if (inclusive)
	{
		for (int i = 0; i < data.size(); i++)
		{
			if (i > 0)
			{
				results.push_back(data[i] + results[i - 1]);
			}
			else
			{
				results.push_back(data[i]);
			}
		}
	}
	else
	{
		std::vector<int> inclusiveResults = scan(data, true);
		for (int i = 0; i < data.size(); i++)
		{
			results.push_back(inclusiveResults[i] - data[i]);
		}
	}
	return results;
}

template <class T>
std::vector<T> split(const std::string& s, char c, std::vector<T> v, int colOfInterest = -1) {
	int i = 0;
	int j = s.find(c);
	std::vector<T> splitData;

	while (j >= 0) {
		//if (T == int)
		//{
		std::stringstream is(s.substr(i, j-i));
		//}
		T tempVal;
		is >> tempVal;
		splitData.push_back(tempVal);
		i = ++j;
		j = s.find(c, j);

		if (j < 0) {
			//if (T == "int")
			//{
			std::stringstream is(s.substr(i, s.length()));
			//}
			T tempVal2;
			is >> tempVal2;
  			splitData.push_back(tempVal2);
		}
	}
	std::vector<T> concatData = v;
	if (colOfInterest == -1)
	{
		concatData.insert(concatData.end(), splitData.begin(), splitData.end());
	}
	else
	{
		concatData.push_back(splitData[colOfInterest]);
	}
	return concatData;
}

template <class T>
std::vector<T> loadCSV(std::istream& in, std::vector<T> data, int colOfInterest, bool headersOnly = false) {

	std::vector<T> loadedData = data;

	std::string tmp;

	if (headersOnly)
	{
		getline(in, tmp, '\n');
		
		loadedData = split<T>(tmp, ',', loadedData, colOfInterest);
	}
	else
	{
		getline(in, tmp, '\n');
		getline(in, tmp, '\n');
		tmp.clear();
		while (!in.eof()) {
			getline(in, tmp, '\n');

			loadedData = split<T>(tmp, ',', loadedData, colOfInterest);

			tmp.clear();
	
		}
	}
	return loadedData;
}

template <class T>
void printVector(std::vector<T> data)
{
	for (int i = 0; i < data.size(); i++)
	{
		std::cout << i << "\t:" << data[i] << std::endl;
	}
}

void printhelp ()
{
	std::cout << "Syntax: data_filepath function print column_index [serial] [count_value] [hard top threshold] [hard bottom threshold] [soft threshold]" << std::endl;
	std::cout << "function: i (ingest only), s (sum), a (average), m (minimum), M (maximum), c (count of value), n (scan - exclusive), N (scan - inclusive), t (TEEN), d (DSSS)" << std::endl;
	std::cout << "print: r (read only), p (print function result only), P (print data & result of function) s (serial)" << std::endl;
	std::cout << "column_index: 0-based" << std::endl;
	std::cout << "count_value (if applicable)" << std::endl;
	std::cout << "Help Syntax: h" << std::endl;
}

template <class T>
int mainfunc(int argc, char** argv) {
	// Should use an actual arg parse library or something

	// Only runs if filepath is given - maybe should check if filepath is valid
	bool badsyntax = false;
	std::ifstream in(argv[1]);
	T sumValue = T();
	float averageValue = 0.0;
	T minValue = T();
	T maxValue = T();
	int countValue = 0;
	std::vector<T> scanValues;

	bool serial = false;

	if (argc >= 6){
		bool serial = (*argv[5] == 's');
	}

	if (!in)
		return(EXIT_FAILURE);

	std::vector<T> data;
	std::vector<T>* data_ptr = &data;

	data = loadCSV<T>(in, data, atoi(argv[4]));
	
	if (*argv[2] == 'i')
	{
		// do nothing else - just ingest data
	}
	// Sum of data
	else if (*argv[2] == 's')
	{
		if (serial){
			if (typeid(T) != typeid(std::string))
			{
				sumValue = sum(data);
			}
			else
			{
				std::cout << "Invalid: Cannot sum string type" << std::endl;
			}
		}
		else{
			sumValue = parallel::reduce(data_ptr);
		}
	}
	// Average of data
	else if (*argv[2] == 'a')
	{
		if (serial){
			if (typeid(T) != typeid(std::string))
			{
				averageValue = average(data);				
			}
		}
		else{
			averageValue = parallel::average(&data);
		}
	}
	// Min of data
	else if (*argv[2] == 'm')
	{
		if (serial){
			minValue = min(data);
		}
		else{
			minValue = parallel::minimum(&data);
		}
	}
	// Max of data
	else if (*argv[2] == 'M')
	{	if (serial){
			maxValue = max(data);
		}
		else{
			maxValue = parallel::maximum(&data);
		}
	}
	// Count of data
	else if (*argv[2] == 'c' &&  argv[5] != "")
	{

		if(serial){
			std::stringstream ss(argv[6]);
			T countObject;
			ss >> countObject;

			countValue = std::count(data.begin(), data.end(), countObject);
		}
		else{
			std::stringstream ss(argv[5]);
			T countObject;
			ss >> countObject;

			countValue = parallel::count(&data, countObject);
		}
	}
	else if (*argv[2] == 'n')
	{
		if(serial){
			scanValues = scan(data, false);
		}
		else{
			parallel::exclusive_scan(data);
			scanValues = data;
		}
	}
	else if (*argv[2] == 'N')
	{
		if(serial){
			scanValues = scan(data, true);
		}
		else{
			parallel::inclusive_scan(data);
			scanValues = data;
		}
	}
	else if (*argv[2] == 't')
	{
		if (serial){
			std::stringstream ss1(argv[6]);
			T h_top_thres;
			ss1 >> h_top_thres;
			std::stringstream ss2(argv[7]);
			T h_bot_thres;
			ss2 >> h_bot_thres;
			std::stringstream ss3(argv[8]);
			T s_thres;
			ss3 >> s_thres;
			
			std::vector<T>* temp = TEEN(data, h_top_thres, h_bot_thres, s_thres);
			data.clear();
			for (int i = 0; i<temp->size();i++){
				data.push_back(temp->at(i));
			}
		}
		else{
			std::stringstream ss1(argv[5]);
			T h_top_thres;
			ss1 >> h_top_thres;
			std::stringstream ss2(argv[6]);
			T h_bot_thres;
			ss2 >> h_bot_thres;
			std::stringstream ss3(argv[7]);
			T s_thres;
			ss3 >> s_thres;
			
			std::vector<T>* temp = parallel::TEEN(&data, h_top_thres, h_bot_thres, s_thres);
			data.clear();
			for (int i = 0; i<temp->size();i++){
				data.push_back(temp->at(i));
			}
		}	
	}
	else if (*argv[2] == 'd'){
		if (typeid(T) == typeid(int)){
			T pattern_arr[data.size()];
			T vals[data.size()];
	
			if (serial) {
				DSSS_encrypt(&data, pattern_arr, vals);
				DSSS_decrypt(&data, pattern_arr, vals);
			
			}
			else{
				parallel::DSSS_encrypt(&data, pattern_arr, vals);
				parallel::DSSS_decrypt(&data, pattern_arr, vals);
			}
		}
	}
	else
	{
		badsyntax = true;
	}

	// Print results
	if (*argv[3] == 'P')
	{
		printVector<T>(data);
	}
	if (*argv[3] == 'p' || *argv[3] == 'P')
	{
		if (*argv[2] == 's')
		{
			std::cout << "Sum: " << sumValue << std::endl;
		}
		else if (*argv[2] == 'a')
		{
			std::cout << "Average: " << averageValue << std::endl;				
		}
		else if (*argv[2] == 'm')
		{
			std::cout << "Min: " << minValue << std::endl;				
		}
		else if (*argv[2] == 'M')
		{
			std::cout << "Max: " << maxValue << std::endl;				
		}
		else if (*argv[2] == 'c')
		{
			std::cout << "Count: " << countValue << std::endl;
		}
		else if (*argv[2] == 'n')
		{
			std::cout << "Scan (exclusive)" << std::endl;
			printVector<T>(scanValues);
		}
		else if (*argv[2] == 'N')
		{
			std::cout << "Scan (inclusive)" << std::endl;
			printVector<T>(scanValues);
		}
		else if (*argv[2] == 't')
		{
			std::cout << "TEEN" << std::endl;
			printVector<T>(data);
		}
	}
	if (badsyntax)
	{
		printhelp();
	}
	return 0;
}

int main(int argc, char* argv[]) {
	int result = -1;
	if (argc == 2 && *argv[1] == 'h')
	{
		printhelp();
		return 0;
	}
	else if (argc >= 4)
	{
		std::vector<std::string> headerTypes;
		std::vector<std::string> headerNames;
		std::ifstream in(argv[1]);
		
		if (!in)
			return(EXIT_FAILURE);

		headerTypes = loadCSV<std::string>(in, headerTypes, -1, true);
		headerNames = loadCSV<std::string>(in, headerNames, -1, true);
		
		if (argc == 4)
		{
			if (*argv[3] == 'P')
			{
				printVector<std::string>(headerTypes);
				printVector<std::string>(headerNames);
			}
		}
		else if (argc >= 5)
		{
			int columnIndex = atoi(argv[4]);
			// std::stringstream is(*argv[4]);
			// int columnIndex;
			// is >> columnIndex;
			if (headerTypes[columnIndex].find("i") != std::string::npos)
			{
				result = mainfunc<int>(argc, argv);
			}
			else
			{
				printhelp();
			}
		}
	}
	else
	{
		printhelp();
		return (EXIT_FAILURE);
	}
	return 0;
}
