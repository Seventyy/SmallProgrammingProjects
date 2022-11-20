#include <iostream>
#include <string>
#include <vector>

using namespace std;

#define MAPSIZE_X 30
#define MAPSIZE_Y 17

float depth_map[MAPSIZE_X][MAPSIZE_Y];

class Vector3
{
public:
    float x, y, z;

    Vector3(float _x = 0, float _y = 0, float _z = 0) : x(_x), y(_y), z(_z) {}
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

void print()
{
    string image_string;
    // char gray_shades[5] = {char(32), char(219), char(178), char(177), char(176)}; // from darkest to ligterst, starting with space
    char gray_shades[9] = {' ', '-', '~', ':', '!', '=', '#', '$', '@'};
    // char gray_shades[5] = {char(32), char(176), char(177), char(178), char(219)}; // from lighest to darkest

    image_string += '+';
    for (int i = 0; i < MAPSIZE_X * 2; i++)
    {
        image_string += '-';
    }
    image_string += '+';
    image_string += '\n';

    //  for (char i = 0; i<256;i++) cout<< i;

    for (int y = 0; y < MAPSIZE_Y; y++)
    {
        // cout << y << ' ';
        // if (y < 10)
        // cout << ' ';
        image_string += '!';
        for (int x = 0; x < MAPSIZE_X; x++)
        {
            image_string += gray_shades[int(ceil(depth_map[x][y] * 8))];
            image_string += gray_shades[int(ceil(depth_map[x][y] * 8))];
        }
        image_string += '!';
        image_string += '\n';
    }

    image_string += '+';
    for (int i = 0; i < MAPSIZE_X * 2; i++)
    {
        image_string += '-';
    }
    image_string += '+';
    image_string += '\n';

    // image_string[2 * ((image_size.x + 3) * int((image_size.y + 2) / 2) + int((image_size.x + 2) / 2) + 1)] = '+'; // cursor
    image_string[(int(MAPSIZE_Y / 2) + 1) * (2 * MAPSIZE_X + 3) + MAPSIZE_X + 1] = '[';
    image_string[(int(MAPSIZE_Y / 2) + 1) * (2 * MAPSIZE_X + 3) + MAPSIZE_X + 2] = ']';

    cout << image_string;
}

int main()
{
    Vector3 v1 = Vector3(3, 4, 1);
    Matrix m1 = Matrix(-1, 0, 0, 0, 0, 2, 0, -1, 0);

    Vector3 v2 = m1 * v1;

    cout << v2.x << ", " << v2.y << ", " << v2.z << endl;
}
