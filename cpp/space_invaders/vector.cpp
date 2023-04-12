#include "vector.h"

Vector::Vector(double _x, double _y): x(_x), y(_y) {}

Vector Vector::operator + (Vector const& _vec) { return Vector(x + _vec.x, y + _vec.y); }
Vector Vector::operator - (Vector const& _vec) { return Vector(x - _vec.x, y - _vec.y); }
Vector Vector::operator * (double const& _vec) { return Vector(x * _vec, y * _vec); }
Vector Vector::operator / (double const& _vec) { return Vector(x / _vec, y / _vec); }