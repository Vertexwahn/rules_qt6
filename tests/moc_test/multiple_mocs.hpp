#pragma once

#include <QtCore/QObject>

class Fuzz : public QObject
{
    Q_OBJECT

public:
    Fuzz(QObject *parent = nullptr) : QObject(parent) {}
    ~Fuzz() {}
};

class Buzz : public QObject
{
    Q_OBJECT

public:
    Buzz(QObject *parent = nullptr) : QObject(parent) {}
    ~Buzz() {}
};
