#include <iostream>
#include <cstdlib>
#include <ctime>
#include <math.h>
#include <conio.h>
//#include <string.h>

#define PI 3.14159265358979323846
#define SIZE 60

uint8_t map[SIZE][SIZE];
NavNode* nav_mesh[SIZE][SIZE];
char colors[] = "  []@@}{";

class Vector
{
public:
    float x, y;

    Vector(float _x = -1, float _y = -1)
    {
        x = _x;
        y = _y;
    }

    float length() {return x*x + y*y;}

    Vector operator + (Vector const& _vec) { return Vector(x + _vec.x, y + _vec.y); }
    Vector operator - (Vector const& _vec) { return Vector(x - _vec.x, y - _vec.y); }
    Vector operator * (float const& _val) { return Vector(x * _val, y * _val); }
    Vector operator / (float const& _val) { return Vector(x / _val, y / _val); }

    bool operator == (Vector const& _vec) { return (x == _vec.x && y == _vec.y) ? true : false; }
    bool operator != (Vector const& _vec) { return (x == _vec.x && y == _vec.y) ? false : true; }
};

class NavNode
{
public:
    Vector position;
    NavNode* neighbours[4] = {nullptr, nullptr, nullptr, nullptr}; // ????????????????????????????????????????
    NavNode(Vector _position) : position(_position) {}

    // void connect()
    // {
    //     if ((int)position.x != 0)
    //         neighbours[0] = map[(int)position.x - 1][(int)position.y];
    //     if ((int)position.y != 0)
    //         neighbours[1] = map[(int)position.x][(int)position.y - 1];
    //     if ((int)position.x != SIZE - 1)
    //         neighbours[2] = map[(int)position.x + 1][(int)position.y];
    //     if ((int)position.y != SIZE - 1)
    //         neighbours[3] = map[(int)position.x][(int)position.y + 1];
    // }

    
};

class Entity
{
public:
    Vector position;
    uint8_t symbol_idx;

    Entity(Vector _position) : position(_position) {}

    virtual bool turn();

    void draw()
    {
        map[(int)position.x][(int)position.y] = symbol_idx;
    }

};

class Player: public Entity
{
public:
    Player(Vector _position) : Entity(_position)
    {
        symbol = "HH";
    }
    
    bool turn()
    {
        char input = getch();
        switch (input)
        {
            case 'w': position.y -= 1; break;
            case 'a': position.x -= 1; break;
            case 's': position.y += 1; break;
            case 'd': position.x += 1; break;
            case 'e': map[(int)position.x][(int)position.y+1] = 1; break;
            case 'z': break;
            case 'q': return false;
        }
        //draw();
        return true;
    }
};


class Enemy: public Entity
{
public:
    Enemy(Vector _position) : Entity(_position)
    {
        symbol = "XX";
    }

    bool turn()
    {
        Vector current_cell = position;
        while (true)
        {
            
        }
        
    }
};


void print()
{
    char buffer[2*(SIZE*SIZE)+SIZE];
    int i=0;
    for (int y=0; y<SIZE; y++)
    {
        for (int x=0; x<SIZE; x++)
        {

            buffer[i] = colors[2*map[x][y]];
            buffer[i+1] = colors[2*map[x][y]+1];
            i+=2;
        }
        buffer[i] = '\n';
        i++;
    }
    std::cout << buffer;
}

void build_level()
{
    map[0][0] = 1;
    map[0][SIZE-1] = 1;
    map[SIZE-1][0] = 1;
    map[SIZE-1][SIZE-1] = 1;

    map[40][30] = 1;
    map[40][31] = 1;
    map[40][32] = 1;
    map[40][33] = 1;
    map[40][34] = 1;
    map[40][35] = 1;

    map[40][36] = 1;

    map[39][36] = 1;
    map[38][36] = 1;
    map[37][36] = 1;
    map[36][36] = 1;

}

int main()
{    
    char input;

    Source source1(Vector(10, 20));
    Source source2(Vector(45, 27));
    //Source source3(Vector(3, 53));
    
    build_level();

    while (true)
    {

        map[(int)source1.position.x][(int)source1.position.y] = 0;
        
        if      (input == 'w') source1.position.y -= 1;
        else if (input == 'a') source1.position.x -= 1;
        else if (input == 's') source1.position.y += 1;
        else if (input == 'd') source1.position.x += 1;
        else if (input == 'e') map[(int)source1.position.x][(int)source1.position.y+1] = 1;
        else if (input == 'q') break;

        clar_light_map();
        source1.illuminate(400); 
        source2.illuminate(400); 
        //source3.illuminate(400); 
        print();

        input = getch();
    }

    return 0;
}
