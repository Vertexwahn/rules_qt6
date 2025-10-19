#include <QCoreApplication>
#include <QString>
#include <iostream>

int main(int argc, char *argv[]) {
    QCoreApplication app(argc, argv);
    
    std::cout << "Qt Version: " << QT_VERSION_STR << std::endl;
    std::cout << "Qt Major Version: " << QT_VERSION_MAJOR << std::endl;
    std::cout << "Qt Minor Version: " << QT_VERSION_MINOR << std::endl;
    std::cout << "Qt Patch Version: " << QT_VERSION_PATCH << std::endl;
    
    return 0;
}
