#include <iostream>
#include <fstream>
#include <string>

using namespace std;


/*
 *	|z
 *	|
 *     / \
 *    /y  \x
 *
 * 
 *	0 
 *	1  O
 *	2
 *	4
 *	5  O 
 *	6 OOO
 *	7  O
 *	8
 *	9
 *     10  O
 *     11
 *
 *	
 *	 _
 *	/_/|
 *	|_|/
 *	
 *	 _
 *	/_/|
 *	|_|/
 *	|_|/
 *	
 *	
 *	
 *	
 */



class Space
{
public:
	bool space[16][16][16];

	void clear()
	{
		for (int x=0;x<16;x++)
		for (int y=0;y<16;y++)
		for (int z=0;z<16;z++)
			space[x][y][z] = 0;
	}

	void populate()
	{
		int x,y,z;
		char operation;
		cin >> x >> y >> z >> operation;

		if (operation == '+') space[x][y][z] = 1;
		else if (operation == '-') space[x][y][z] = 0;
		else return;

		populate();
	}
	
	void populate_from_file(string _filename)
	{
		fstream file;
		file.open(_filename, ios::in);
		string line;

		for (int line_num=0, getline(file, line), line_num++);	
		{
			for (int i=0;i<16,i++)
			{
				space[line[i]][][]
			}	
		}
	}

};

int main()
{
	Space space;
	space.populate();
	cout << "test1\n";
}
