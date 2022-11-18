class Vector2Int
{
public:
    int x, y;
    Vector2Int(int _x = 0, int _y = 0);
};

class Vector3 
{
public:
    float x, y, z, length;
    Vector3(float _x = 0.0f, float _y = 0.0f, float _z = 0.0f);

    Vector3 operator + (const Vector3&);
    Vector3 operator - (const Vector3&);
    Vector3 operator * (const float&);
    Vector3 operator / (const float&);

    Vector3 normalize();
};