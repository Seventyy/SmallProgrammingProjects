#pragma once
#include <math.h>
#include "Vector.h"


Vector2Int::Vector2Int(int _x, int _y): x(_x), y(_y) {}

Vector3::Vector3(float _x, float _y, float _z)
{
    x = _x;
    y = _y;
    z = _z;
    length = sqrt(x * x + y * y + z * z);
}

Vector3 Vector3::operator+(const Vector3 &_vec) { return Vector3(x + _vec.x, y + _vec.y, z + _vec.z); }
Vector3 Vector3::operator-(const Vector3 &_vec) { return Vector3(x - _vec.x, y - _vec.y, z - _vec.z); }
Vector3 Vector3::operator*(const float &_var) { return Vector3(x * _var, y * _var, z * _var); }
Vector3 Vector3::operator/(const float &_var) { return Vector3(x / _var, y / _var, z / _var); }

Vector3 Vector3::normalize()
{
    //return _vac / sqrt(_vec.x*_vec.x + _vec.y*_vec.y + _vec.z*_vec.z);
    return *this / length;
}
