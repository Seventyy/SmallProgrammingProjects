#pragma once

class Vector
{
public:
    double x, y;
    Vector(double _x = 0, double _y = 0);

    Vector operator + (Vector const& _vec);
    Vector operator - (Vector const& _vec);
    Vector operator * (double const& _vec);
    Vector operator / (double const& _vec);
};