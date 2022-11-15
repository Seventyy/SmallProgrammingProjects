#include <iostream>
#include <cstdlib>
#include <ctime>
#include <math.h>
#include <conio.h>
//#include <string.h>

#define PI 3.14159265358979323846
#define SIZE 60

char light_map[SIZE][SIZE];
char map[SIZE][SIZE];

char map_colors[] = "  []><88";
char light_colors[] = "::  ";

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

class Source
{
public:
    Vector position;

    Source (Vector _position = Vector(-1,-1)): position(_position) {}

    void illuminate(int rays_ammount)
    {
        map[(int)position.x][(int)position.y] = 2;
        for (int i=0; i<rays_ammount; i++)
        {
            draw_ray(i*2*PI/rays_ammount);
        }
    }

    void draw_ray(float angle)
    {
        Vector current_cell = position;

        Vector path = Vector(cos(angle), sin(angle));
        Vector path_signs = Vector((path.x > 0) - (path.x < 0), (path.y > 0) - (path.y < 0));

        Vector step = Vector (1 / abs(path.x), 1 / abs(path.y));
        Vector i = Vector(1, 1); 
        

        while (true)
        {
            if (i.x * step.x < i.y * step.y)
            {
                current_cell.x += path_signs.x; 
                i.x++;
            }
            else
            {
                current_cell.y += path_signs.y; 
                i.y++;
            }
            if (!(current_cell.x >= 0 && current_cell.x < SIZE && current_cell.y >= 0 && current_cell.y < SIZE) || 
                map[(int)current_cell.x][(int)current_cell.y] == 1) break;
            light_map[(int)current_cell.x][(int)current_cell.y] = 1;
        }
    }
};

void clar_light_map()
{
    for (int y=0; y<SIZE; y++)
    {
        for (int x=0; x<SIZE; x++)
        {
            light_map[x][y] = 0;
        }
    }
}

void print()
{
    char buffer[2*(SIZE*SIZE)+SIZE];
    int i=0;
    for (int y=0; y<SIZE; y++)
    {
        for (int x=0; x<SIZE; x++)
        {
            if (map[x][y])
            {
                buffer[i] = map_colors[2*map[x][y]];
                buffer[i+1] = map_colors[2*map[x][y]+1];
            }
            else
            {
                buffer[i] = light_colors[2*light_map[x][y]];
                buffer[i+1] = light_colors[2*light_map[x][y]+1];
            }
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
