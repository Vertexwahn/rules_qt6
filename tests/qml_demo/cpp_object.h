#ifndef QML_DEMO_CPP_OBJECT
#define QML_DEMO_CPP_OBJECT

#include <QtCore/QObject>

class CppObject : public QObject {
  Q_OBJECT
  Q_PROPERTY(QString name READ getName WRITE setName NOTIFY nameChanged)
  Q_PROPERTY(int year READ getYear WRITE setYear NOTIFY yearChanged)
public:
  explicit CppObject(QObject *parent = nullptr);
  // use Q_INVOKABLE macro, we can use this function in qml
  Q_INVOKABLE void sendSignal(); //  send signal
  void setName(const QString &name);
  const QString &getName() const;
  void setYear(int32_t year);
  int32_t getYear() const;
signals:
  void cppSignalA(); // zero parameter signal
  void cppSignalB(const QString &str, int32_t value);
  void nameChanged(const QString &name);
  void yearChanged(int32_t year);
public slots:
  void cppSlotA();                                  //  zero parameter slo
  void cppSlotB(const QString &str, int32_t value); //  two parameter slot
private:
  QString myName;
  int32_t myYear;
};

#endif /* QML_DEMO_CPP_OBJECT */
