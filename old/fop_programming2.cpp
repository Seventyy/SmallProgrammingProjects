#include <iostream>
#include <fstream>
#include <string>

using namespace std;

int main()
{
	ifstream input_stream("fop_.txt");
	string a;

	input_stream >> a;

	cout << a;	
}
