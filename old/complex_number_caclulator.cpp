#include <iostream>

class Complex
{
public:
	float r,i;
	Complex(float _r, float _i)
	{
		r=_r;
		i=_i;
	}

	Complex operator + (const Complex &c)
	{
		return Complex(r+c.r,i+c.i);
	}
	
	Complex operator - (const Complex &c)
	{
		return Complex(r-c.r,i-c.i);
	}
	
	static void print(Complex c)
	{
		std::cout<<c.r<<" + "<<c.i<<"i\n";
	}
};


int main()
{
	Complex z = Complex(5,2);
	Complex w = Complex(3,78);
	
	Complex sum = z+w;
	
	Complex::print(sum);

}
