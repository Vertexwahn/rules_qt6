#pragma once

#include <QtCore/QObject>

class Bar : public QObject
{
    Q_OBJECT

public:
    Bar(QObject *parent = nullptr) : QObject(parent) {}
    ~Bar() {}
};
