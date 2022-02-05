#include<iostream>
#define M 100
#define N 100

using namespace std;

bool map[M][N];
bool map_build[M][N];


void set_build_cell(int _x, int _y, bool _a)
{
	if (_x < 0 || _x >= M || _y < 0 || _x >= N) return; 
	map_build[_x][_y] = _a;
}	

void set_cell(int _x, int _y, bool _a)
{
	if (_x < 0 || _x >= M || _y < 0 || _x >= N) return; 
	map[_x][_y] = _a;
}	

bool get_build_cell(int _x, int _y)
{
	if (_x < 0 || _x >= M || _y < 0 || _x >= N) return 0; 
	return map_build[_x][_y];
}

bool get_cell(int _x, int _y)
{
	if (_x < 0 || _x >= M || _y < 0 || _x >= N) return 0; 
	return map[_x][_y];
}

void tick()
{
	for (int j=0; j<N; j++)
	for (int i=0; i<M; i++)
		set_build_cell(i, j, 0);

	for (int j=0; j<N; j++)
	{
		for (int i=0; i<M; i++)
		{
			if (get_cell(i + 1, j) ||
			get_cell(i - 1, j) ||
			//get_cell(i, j + 1) ||
			get_cell(i, j - 1))
				set_build_cell(i, j, 1);
			if (get_cell(i + 1, j) &&
			//get_cell(i - 1, j) &&
			get_cell(i, j + 1) &&
			get_cell(i, j - 1))
				set_build_cell(i, j, 0);

		}
	}
	for (int j=0; j<N; j++)
	for (int i=0; i<M; i++)
		set_cell(i, j, get_build_cell(i, j));
}

void print()
{
	for (int j=30; j<90; j++)
	{
		for (int i=0; i<80; i++)
		{
			if (get_cell(i,j)) 
				cout << "[]";
			else
				cout << "  ";
		}	
		cout << '\n';
	}
}

int main()
{
	//map[33][33] = 1;		
	map[10][53] = 1;
	map[10][54] = 1;
	map[11][53] = 1;

	//map[69][70] = 1;
	//map[71][70] = 1;
	//map[70][69] = 1;
	//map[70][71] = 1;

	while(true)
	{
		print();
		cin.get();
		tick();
	}
}
