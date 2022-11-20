#include <iostream>
#include <string>
#include <vector>
#include <math.h>

using namespace std;

#define SCREEN_SIZE_X 30
#define SCREEN_SIZE_Y 30

class Vector3
{
public:
    float x, y, z;

    Vector3(float _x = 0, float _y = 0, float _z = 0) : x(_x), y(_y), z(_z) {}

    Vector3 operator+(const Vector3 &_vec) { return Vector3(x + _vec.x, y + _vec.y, z + _vec.z); }
    Vector3 operator-(const Vector3 &_vec) { return Vector3(x - _vec.x, y - _vec.y, z - _vec.z); }
    Vector3 operator*(const float &_var) { return Vector3(x * _var, y * _var, z * _var); }
    Vector3 operator/(const float &_var) { return Vector3(x / _var, y / _var, z / _var); }

    float get_length()
    {
        return sqrt(x * x + y * y + z * z);
    }

    Vector3 normalize()
    {
        return *this / this->get_length();
    }
};

class Matrix
{
    //  |a b c|     |00 01 02|
    //  |d e f|     |10 11 12|
    //  |g h i|     |20 21 22|
public:
    float a, b, c, d, e, f, g, h, i;
    Matrix(float _a = 1, float _b = 0, float _c = 0,
           float _d = 0, float _e = 1, float _f = 0,
           float _g = 0, float _h = 0, float _i = 1)
        : a(_a), b(_b), c(_c), d(_d), e(_e), f(_f), g(_g), h(_h), i(_i) {}

    Vector3 operator*(const Vector3 &vec) { return Vector3(
        a * vec.x + b * vec.y + c * vec.z,
        d * vec.x + e * vec.y + f * vec.z,
        g * vec.x + h * vec.y + i * vec.z); }
};

class Cube
{
public:
    float a = 1;

    bool is_intersecting(Vector3 vec)
    {
        if (vec.x <= a / 2.0f && vec.x >= -a / 2.0f &&
            vec.y <= a / 2.0f && vec.y >= -a / 2.0f &&
            vec.z <= a / 2.0f && vec.z >= -a / 2.0f)
            return true;
        return false;
    }
};

class Camera
{
public:

    // float depth_map[SCREEN_SIZE_X][SCREEN_SIZE_Y]; // 0.0 - 1.0
    bool bool_map[SCREEN_SIZE_X][SCREEN_SIZE_Y];

    float render_distance = 10;
    float ray_step = 1;

    Vector3 position = Vector3(5, 0, 0);
    // Vector3 normal = Vector3(-1, 0, 0);

    bool ray_cast(Vector3 vec, Cube cube) // assuming vec is normalised
    {
        for (float i = 0; i <= render_distance; i += ray_step)
            if (cube.is_intersecting(position + (vec * i)))
                return true;
        return false;
    }

    void render(Cube cube)
    {
        float pixel_angle = 0.03491;

        for (int y = -SCREEN_SIZE_Y / 2; y < (SCREEN_SIZE_Y / 2); y++)
        {
            for (int x = -SCREEN_SIZE_X / 2; x < (SCREEN_SIZE_X / 2); x++)
            {
                if (ray_cast(Vector3(-1, tan(pixel_angle * y), tan(pixel_angle * x)), cube))
                    bool_map[x][y] = true;
                else // not needed???
                    bool_map[x][y] = false;
            }
        }
    }

    void print()
    {
        for (int y = 0; y < SCREEN_SIZE_Y; y++)
        {
            for (int x = 0; x < SCREEN_SIZE_X; x++)
            {
                if (bool_map[x][y])
                    cout << "[]";
                else
                    cout << "  ";
            }
            cout << endl;
        }
    }
};

int main()
{
    Cube c1;
    Camera cam;

    cam.render(c1);
    cam.print();

    cout << c1.is_intersecting(Vector3(.1, .3, -.4)) << endl;
    cout << c1.is_intersecting(Vector3(.1, .3, -1.9)) << endl;

    cout << cam.ray_cast(Vector3(-1, 0, 0), c1) << endl;
    cout << cam.ray_cast(Vector3(0, 1, 0), c1) << endl;
}

// void render(Space _space)
// {
//     Vector3 v_step;
//     Vector3 h_step;
//     Vector3 vision_ray;

//     for (int y = 0; y < SCREEN_SIZE_Y; y++)
//     {
//         for (int x = 0; x < SCREEN_SIZE_X; x++)
//         {
//             h_step = Vector3(0, 0, tan((2 * x * -h_angle) / SCREEN_SIZE_X + h_angle));
//             v_step = Vector3(0, tan((2 * y * -v_angle) / SCREEN_SIZE_Y + v_angle), 0); // these asume normal is perpendicular to y and z axis

//             for (float k = 0; k <= render_distance; k += step)
//             {
//                 vision_ray = (normal + h_step + v_step).normalize() * k;
//                 if (_space.is_intersecting(position + vision_ray))
//                 {
//                     image[x][y] = 1;
//                     depth_map[x][y] = k / render_distance;
//                     break;
//                 }
//             }
//         }
//     }
// }
