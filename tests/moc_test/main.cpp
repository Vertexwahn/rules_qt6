#include <iostream>

#include "foo.hpp"
#include "bar.hpp"

int main() {
    Foo foo;
    foo.dumpObjectInfo();
    std::cout << foo.metaObject()->className() << std::endl;

    Bar bar;
    bar.dumpObjectInfo();
    std::cout << bar.metaObject()->className() << std::endl;

    return 0;
}
