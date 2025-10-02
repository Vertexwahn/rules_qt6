#pragma once

#include <QtCore/QObject>

class Foo : public QObject
{
    Q_OBJECT

public:
    Foo(QObject *parent = nullptr) : QObject(parent) {}
    ~Foo() {}
};
