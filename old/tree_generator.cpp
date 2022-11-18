#include <iostream>
#include <cstdlib>
#include <ctime>



class Vector
{
public:
    int x, y;

    Vector (int _x = -1, int _y = -1)
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

#define SIZE 60
char canvas[SIZE][SIZE];
std::string colors[] = {"  ","##","><"};

float split_factor = -75;
float flower_factor = 1;

void grow(Vector position, float split = 1.0, float flower = 1.0)
{
    if (rand() % 32767 < flower || position.y == 0 || position.x == 0 || position.x == SIZE-1) 
    {
        canvas[position.x][position.y] = 2;
        return;
    }
    int random = rand();
    if (random % 32767 < split)
    {
        canvas[position.x+1][position.y] = 1;
        canvas[position.x-1][position.y] = 1;
        canvas[position.x+2][position.y] = 1;
        canvas[position.x-2][position.y] = 1;
        
        grow(position + Vector( 2, -1), split+split_factor, flower+flower_factor);
        grow(position + Vector(-2, -1), split+split_factor, flower+flower_factor);
    }
    else
    {
        canvas[position.x][position.y] = 1;
        grow(position + Vector(0, -1), split+split_factor, flower+flower_factor);
    }
}

void print()
{
    for (int y=0; y<SIZE; y++)
    {
        for (int x=0; x<SIZE; x++)
        {
            std::cout << colors[canvas[x][y]];
        }
        std::cout << '\n';
    }
}

int main()
{
    srand((int)time(0));
    grow(Vector(30, 59), 3000.0, 1000.0);
    print();
    return 0;
}














/*#include <iostream>
#include <cstdlib>
#include <ctime>

#define SIZE 60

char canvas[SIZE][SIZE];

std::string colors[] = {"  ","##","><"};

class Vector
{
public:
    int x, y;

    Vector (int _x = -1, int _y = -1)
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

class Tree
{
public:
    Vector origin;
    int split_chance;
    int flower_chance;

    float split_factor;
    float flower_factor;

    Tree(Vector _origin = Vector(-1,-1),
        int _split_chance = 0,
        int _flower_chance = 0,
        int _split_factor = 0,
        int _flower_factor = 0
        ):
        origin(_origin),
        split_chance(_split_chance),
        flower_chance(_flower_chance),
        split_factor(_split_factor),
        flower_factor(_flower_factor)
    {}

    void grow(Vector position, float split, float flower)
    {
        std::cout << "yes";
        if (rand() % 32767 > flower || position.y == 0 || position.x == 0 || position.x == SIZE-1) 
        {
            canvas[position.x][position.y] = 2;
            return;
        }
        int random = rand() % 32767;
        if (random > split)
        {
            canvas[position.x+1][position.y] = 1;
            canvas[position.x-1][position.y] = 1;
            canvas[position.x+2][position.y] = 1;
            canvas[position.x-2][position.y] = 1;
            
            grow(position + Vector( 2, -1), split*split_factor, flower*flower_factor);
            grow(position + Vector(-2, -1), split*split_factor, flower*flower_factor);
        }
        else
        {
            canvas[position.x][position.y] = 1;
            grow(position + Vector(0, -1), split*split_factor, flower*flower_factor);
        }
    }

    void plant()
    {
        grow(origin, split_chance, flower_chance);
    }
};

void print()
{
    for (int y=0; y<SIZE; y++)
    {
        for (int x=0; x<SIZE; x++)
        {
            std::cout << colors[canvas[x][y]];
        }
        std::cout << '\n';
    }
}

void init()
{
    Tree tree(Vector(30, 30), 32767, 32767, 0.9, 0.9);
    tree.plant();
}

int main()
{
    srand((int)time(0));
    init();
    print();
    return 0;
}
*/