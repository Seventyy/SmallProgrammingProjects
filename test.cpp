#include <iostream>
#include <vector>
#include <deque>
#include <set>
#include <algorithm>
#include <functional>
#include <iterator>

using namespace std;

int main() {
    vector<double> v{89,13,1,7,4,11,7,12,4,5,2,11,11,7,7,7,13,7,7,};
    deque<double> d;
    set<double> s;

    copy_if(v.begin(), v.end(), front_inserter(d), bind1st(less<double>(), 6));
    for_each(d.begin(), d.end(), [&s](double e) { s.insert(e); });
    copy(s.begin(), s.end(), ostream_iterator<double>(cout, " "));
}





// class A{
// protected:
//     int a;

// public:
//     A(int a): a(a) {}
//     virtual int f() { return a - 1; }
//     int g() { return a + 2; }
// };

// class B: public A{
// protected:
//     int b;

// public:
//     B(int a, int b): A(a), b(b) {}
//     virtual int f() { return a + b; }
//     int g() { return a - b; }
// };

// int main(){
//     A a(2);
//     B b(3, 1);
//     A* pa = &a;
//     B* pb = &b;
//     a = b;
//     pa = pb;

//     std::cout << a.f() << " ";
//     std::cout << a.g() << " ";
//     std::cout << pa->f() << " ";
//     std::cout << pa->g() << " ";
//     std::cout << pb->f() << " ";
//     std::cout << pb->g() << " ";
// }










































// class O{
// protected:
//     int v;
// public:
//     O(int v): v(v){}

//     void operator()(int &e){
//         e -= v;
//         v++;    
//     }
// };

// template <class I, class F> 
// void p(I b, I e, F f) {
//     I i = e;
//     do {
//         i--;
//         f(*i);
//         std::cout << *i << " ";
//     }
//     while (i != b);
// }

// int main(){
//     int t[] = {-2,5,-3,3,4};
//     p(t, t+4, O(-3));
// }