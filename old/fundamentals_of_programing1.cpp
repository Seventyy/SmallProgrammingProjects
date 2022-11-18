#include <iostream>


int main ()
{
	int arr[10];// = {00,00,00,00,00,00,00,00,00,00};
	arr[0] = 01;
	arr[1] = 07;
	arr[2] = 077;	
	arr[3] = -0x100;
	arr[4] = 0xff;
	for (int i=0;i<10;i++)
		;//std::cout<<arr[i]<<'\n';

	std::cout<<'\n'<<'/'<<'n'<<int('/')<<int('n')<<'\n';
}

