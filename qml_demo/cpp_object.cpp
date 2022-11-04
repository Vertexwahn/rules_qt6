#include "qml_demo/cpp_object.h"

#include <QtCore/QDebug>

CppObject::CppObject(QObject *parent)
    : QObject(parent), myName("none"), myYear(0) {}

void CppObject::sendSignal() {
  qDebug() << "CppObject::sendSignal";
  emit cppSignalA();
  emit cppSignalB(myName, myYear);
}

void CppObject::setName(const QString &name) {
  if (myName != name) {
    emit nameChanged(name);
  }
  myName = name;
}

const QString &CppObject::getName() const { return myName; }

void CppObject::setYear(int32_t year) {
  if (myYear != year) {
    emit yearChanged(year);
  }
  myYear = year;
}

int32_t CppObject::getYear() const { return myYear; }

void CppObject::cppSlotA() { qDebug() << "slotA called"; }

void CppObject::cppSlotB(const QString &str, int32_t value) {
  qDebug() << "slotB called, "
           << "name : " << str << ", "
           << "year : " << value << "\n";
}
