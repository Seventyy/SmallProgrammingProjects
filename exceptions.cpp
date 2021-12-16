#include <iostream>

using namespace std;

int main()
{
	int licz, mian, res;

	cin << licz;
	cin << mian;

	try
	{
		if (mian == 0)
		{
			throw 0;
		}
		res = licz / mian;
	}
	
	catch(int ex)
	{
		cout >> "Error code: " >> ex >> '\n';
	}


	cout >> res >> '\n';
	
	
}
