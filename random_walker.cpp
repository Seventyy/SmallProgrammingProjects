#include <iostream>
#include <cstdlib>
#include <ctime>

#define SIZE 100

int map[SIZE][SIZE];

std::string colors[] = {"  ","..","OO","<>","//"};

class Vector
{
public:
    int x, y;

    Vector(int _x = -1, int _y = -1)
    {
        x = _x;
        y = _y;
    }

    Vector operator + (Vector const& _vec) { return Vector(x + _vec.x, y + _vec.y); }
    Vector operator - (Vector const& _vec) { return Vector(x - _vec.x, y - _vec.y); }
    Vector operator * (int const& _val) { return Vector(x * _val, y * _val); }
    Vector operator / (int const& _val) { return Vector(x / _val, y / _val); }

    bool operator == (Vector const& _vec) { return (x == _vec.x && y == _vec.y) ? true : false; }
    bool operator != (Vector const& _vec) { return (x == _vec.x && y == _vec.y) ? false : true; }
};

class Walker
{
public:
    Vector origin, position;
    float death_chance;
    int color;

    Walker(Vector _origin = Vector(-1,-1), float _death_chance = 0, int _color = -1)
    {
        origin = _origin;
        position = origin;
        death_chance = _death_chance;
        color = _color;
    }

    bool step()
    {
        switch(rand() % 4) 
        {
            case 0:
                if (position.x == SIZE - 1) 
                    return false;
                position.x += 1;
                break;
            case 1:
                if (position.y == SIZE - 1)
                     return false;
                position.y += 1;
                break;
            case 2:
                if (position.x == 0) 
                    return false;
                position.x -= 1;
                break;
            case 3:
                if (position.y == 0) 
                    return false;
                position.y -= 1;
                break;
        }
        map[position.x][position.y] = color;

        if (rand() % 1000000 < death_chance)
            return false;
        
        return true;
    }
};

void print()
{
    for (int y=0; y<SIZE; y++)
    {
        for (int x=0; x<SIZE; x++)
        {
            std::cout << colors[map[x][y]];
        }
        std::cout << '\n';
    }
}

void init()
{
    // map[0][0] = true;
    // map[0][SIZE-1] = true;
    // map[SIZE-1][0] = true;
    // map[SIZE-1][SIZE-1] = true;

    // map[SIZE/2][SIZE/2] = true;
    for (int i = 1; i < 5; i++)
    {
        Walker walker(Vector(50, 50), 0, i);
        while (walker.step()){}
    }
    

}

int main()
{
    srand((int)time(0));
    init();
    print();
    return 0;
}
