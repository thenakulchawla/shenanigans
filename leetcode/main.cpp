#include <iostream>
#include "Orange.h"

using namespace std;

int main() {

    vector<vector<int>> input{{2,1,1},{1,1,0},{0,1,1}}; 

	Oranges sol;
	int ret = sol.orangesRotting(input);
	std::cout<<ret<<std::endl;
	return 0;
}