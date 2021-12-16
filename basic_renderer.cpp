#include <iostream>
#include <math.h>
#include <vector>
//#include <conio.h>

#define MAPSIZE_X 62
#define MAPSIZE_Y 35

using namespace std;

/*
 *     ^y
 *     |
 *     |    x
 *     |______ >
 *     /
 *    /
 *   / z
 *
 */

class Vector2Int
{
public:
    int x, y;
    Vector2Int(int _x, int _y)
    {
        x = _x;
        y = _y;
    }
};

class Vector3
{
public:
    float x, y, z, length;

    Vector3(float _x = 0.0f, float _y = 0.0f, float _z = 0.0f)
    {
        x = _x;
        y = _y;
        z = _z;
        length = sqrt(x * x + y * y + z * z);
    }

    Vector3 operator+(const Vector3 &_vec) { return Vector3(x + _vec.x, y + _vec.y, z + _vec.z); }
    Vector3 operator-(const Vector3 &_vec) { return Vector3(x - _vec.x, y - _vec.y, z - _vec.z); }
    Vector3 operator*(const float &_var) { return Vector3(x * _var, y * _var, z * _var); }
    Vector3 operator/(const float &_var) { return Vector3(x / _var, y / _var, z / _var); }

    Vector3 normalize()
    {
        //return _vac / sqrt(_vec.x*_vec.x + _vec.y*_vec.y + _vec.z*_vec.z);
        return *this / length;
    }
};

class CubeFace
{
public:
    Vector3 normal;
    float position;
    CubeFace(Vector3 _normal, float _position) : normal(_normal), position(_position) {}
};

class Cube
{
public:
    Vector3 position;
    Vector3 size;
    CubeFace* faces[6]; // x-, x+, y-, y+, z-, z+    // not shure this good

    Cube(Vector3 _position, Vector3 _size = Vector3(1, 1, 1)) 
        : position(_position), size(_size)
    {
        create_faces();
    }
    Cube(Vector3 _position, float _size = 1)
        : position(_position), size(Vector3(_size, _size, _size))
    {
        create_faces();
    }
    
    void create_faces()
    {
        *faces[0] = CubeFace(Vector3(-1,0,0));
        *faces[1] = CubeFace(Vector3( 1,0,0));

        *faces[2] = CubeFace(Vector3(0,-1,0));
        *faces[3] = CubeFace(Vector3(0, 1,0));

        *faces[4] = CubeFace(Vector3(0,0,-1));
        *faces[5] = CubeFace(Vector3(0,0, 1));
    }
    
    bool is_intersecting(Vector3 _vec)
    {
        if (_vec.x >= position.x - size.x / 2 && _vec.x <= position.x + size.x / 2 &&
            _vec.y >= position.y - size.y / 2 && _vec.y <= position.y + size.y / 2 &&
            _vec.z >= position.z - size.z / 2 && _vec.z <= position.z + size.z / 2)
            return 1;
        return 0;
    }

    void determine_face(Vector3 _intersecting, Vector3 _before)
    {
        
    }
};

class Space
{
public:
    vector<Cube> objects;

    bool is_intersecting(Vector3 _vec)
    {
        for (int i = 0; i < objects.size(); i++)
            if (objects[i].is_intersecting(_vec))
                return true;
        return false;
    }
};

class Camera
{
public:
    bool image[MAPSIZE_X][MAPSIZE_Y];
    float depth_map[MAPSIZE_X][MAPSIZE_Y]; // form 0 to 1, form 0 to max render distance

    Vector3 position = Vector3(25, 0, 0);
    Vector3 normal = Vector3(-1, 0, 0);

    //float zoom = 4; // distance between camera and render plane
    float step = 0.01;          // length of vector searching for geomatry
    float render_distance = 50; // range of vision

    float h_angle = 0.44;
    float v_angle = 0.25;

    void move(char _input)
    {
        switch (_input)
        {
        case 'w':
            position.x -= 1;
            break;
        case 's':
            position.x += 1;
            break;
        case 'a':
            position.z += 1;
            break;
        case 'd':
            position.z -= 1;
            break;
        case 'z':
            position.y += 1;
            break;
        case 'x':
            position.y -= 1;
            break;
        }
    }
    void render(Space _space)
    {
        Vector3 v_step;
        Vector3 h_step;
        Vector3 vision_ray;

        for (int y = 0; y < MAPSIZE_Y; y++)
            for (int x = 0; x < MAPSIZE_X; x++)
            {
                h_step = Vector3(0, 0, tan((2 * x * -h_angle) / MAPSIZE_X + h_angle));
                v_step = Vector3(0, tan((2 * y * -v_angle) / MAPSIZE_Y + v_angle), 0); //these asume normal is perpendicular to y and z axis

                for (float k = 0; k <= render_distance; k += step)
                {
                    vision_ray = (normal + h_step + v_step).normalize() * k;
                    if (_space.is_intersecting(position + vision_ray))
                    {
                        image[x][y] = 1;
                        depth_map[x][y] = k / render_distance;
                        break;
                    }
                }
            }
    }

    void clear()
    {
        for (int y = 0; y < MAPSIZE_Y; y++)
            for (int x = 0; x < MAPSIZE_X; x++)
            {
                image[x][y] = 0;
                depth_map[x][y] = 0;
            }
    }

    void print()
    {
        string image_sring;
        char gray_shades[5] = {char(32), char(219), char(178), char(177), char(176)}; // from darkest to ligterst, starting with space
        //char gray_shades[13] = {' ','.',',','-','~',':',';','=','!','*','#','$','@'};
        //char gray_shades[5] = {char(32), char(176), char(177), char(178), char(219)}; // from lighest to darkest

        // cout << "   0 1 2 3 4 5 6 7 8 9 ";
        // for (int i = 10; i < image_size.x; i++)
        //     cout << i;
        // cout << '\n';

        image_sring += char(201); // ╔
        for (int i = 0; i < MAPSIZE_X * 2; i++)
        {
            image_sring += char(205); // ═
        }
        image_sring += char(187); // ╗
        image_sring += '\n';

      //  for (char i = 0; i<256;i++) cout<< i;
        
        for (int y = 0; y < MAPSIZE_Y; y++)
        {
            // cout << y << ' ';
            // if (y < 10)
                // cout << ' ';
            image_sring += char(186); // ║
            for (int x = 0; x < MAPSIZE_X; x++)
            {
                image_sring += gray_shades[int(ceil(depth_map[x][y] * 4))];
                image_sring += gray_shades[int(ceil(depth_map[x][y] * 4))];
                /*
                if (image[x][y])
                {
                    // image_sring += char(219);
                    // image_sring += char(219);

                    image_sring += gray_shades[int(ceil(depth_map[x][y] * 4))];
                    image_sring += gray_shades[int(ceil(depth_map[x][y] * 4))];
                }
                else
                {
                    image_sring += gray_shades[4]; // ' '
                    image_sring += gray_shades[4]; // ' '
                }
                */
            }
            image_sring += char(186); // ║
            image_sring += '\n';
        }

        image_sring += char(200); // ╚
        for (int i = 0; i < MAPSIZE_X * 2; i++)
        {
            image_sring += char(205); // ═
        }
        image_sring += char(188); // ╝
        image_sring += '\n';

        // image_sring[2 * ((image_size.x + 3) * int((image_size.y + 2) / 2) + int((image_size.x + 2) / 2) + 1)] = '+'; // cursor
        image_sring[(int(MAPSIZE_Y / 2) + 1) * (2 * MAPSIZE_X + 3) + MAPSIZE_X + 1] = '['; // cursor
        image_sring[(int(MAPSIZE_Y / 2) + 1) * (2 * MAPSIZE_X + 3) + MAPSIZE_X + 2] = ']'; // cursor

        cout << image_sring;
    }
};

int main()
{
    Camera camera;
    Space space;
    // Cube normal_boi(Vector3(0, 0, 4), 2),
    //     big_boi(Vector3(0, 4, -4), Vector3(1, 4, 4)),
    //     long_boi(Vector3(0, 2.5, 1.5), Vector3(2, 1, 5));

    // space.objects.push_back(normal_boi);
    // space.objects.push_back(big_boi);
    // space.objects.push_back(long_boi);

    Cube cube[9] = {
         Cube(Vector3(3, 5, 9), Vector3(2, 6, 2)),
         Cube(Vector3(3, 3, 3), Vector3(2, 6, 2)),
         Cube(Vector3(3, 5, -3), Vector3(2, 6, 2)),
         Cube(Vector3(3, 3, -9), Vector3(2, 6, 2)),

         Cube(Vector3(-3, 3, 9), Vector3(2, 6, 2)),
         Cube(Vector3(-3, 5, 3), Vector3(2, 6, 2)),
         Cube(Vector3(-3, 3, -3), Vector3(2, 6, 2)),
         Cube(Vector3(-3, 5, -9), Vector3(2, 6, 2)),
         
         Cube(Vector3(0, 11, 0), Vector3(6, 2, 20))
    };

    for (int i = 0; i < 9; i++) 
        space.objects.push_back(cube[i]);

    char input;
    while (true)
    {
        camera.clear();
        camera.render(space);
        camera.print();

        //input = getch();
        cin >> input;


        camera.move(input);
    }
}
