#include <iostream>

#include "foo.hpp"
#include "bar.hpp"
#include "multiple_mocs.hpp"

int main() {
    Foo foo;
    std::cout << foo.metaObject()->className() << std::endl;
    foo.dumpObjectInfo();
    
    Bar bar;
    std::cout << bar.metaObject()->className() << std::endl;
    bar.dumpObjectInfo();
    
    Fuzz fuzz;
    std::cout << fuzz.metaObject()->className() << std::endl;
    fuzz.dumpObjectInfo();

    Buzz buzz;
    std::cout << buzz.metaObject()->className() << std::endl;
    buzz.dumpObjectInfo();

    return 0;
}
