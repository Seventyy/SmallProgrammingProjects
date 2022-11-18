#include <iostream>

using namespace std;

class Vector
{
public:
	int x,y;
	Vector(int _x = -1, int _y = -1)
	{
		x=_x;
		y=_y;
	}

	Vector operator + (Vector const& _vec) {return Vector(x+_vec.x,y+_vec.y);}
	Vector operator - (Vector const& _vec) {return Vector(x+_vec.x,y+_vec.y);}
};

class Map
{
public:
	Vector size = Vector(30,20);
	bool map[30][20];

	void clear()
	{
		for(int y=0;y<size.y;y++)
		{
			for(int x=0;x<size.x;x++)
			{
				map[x][y] = 0;
			}
		}
	}
    
    void populate()
    {      
        Vector input;
        cout << "Coords (-1 to cancel): ";
        cin >> input.x >> input.y;
        if (input.x!=-1&&input.y!=-1)
        {
            map[input.x][input.y] = 1;
            populate();
        }
    }

	void print()
	{
		for(int y=0;y<size.y;y++)
		{
			for(int x=0;x<size.x;x++)
			{
                cout << ((map[x][y]) ? "[]" : "  ");
			}
            cout << '\n';
		}
	}
};




int main()
{
    Map map;
    map.clear();
    map.populate();
    map.print();
	return 0;
}
