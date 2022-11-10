#ifndef QML_DEMO_CPP_OBJECT
#define QML_DEMO_CPP_OBJECT

#include <QtCore/QObject>

class CppObject : public QObject {
  Q_OBJECT
  Q_PROPERTY(QString name READ getName WRITE setName NOTIFY nameChanged)
  Q_PROPERTY(int year READ getYear WRITE setYear NOTIFY yearChanged)
public:
  explicit CppObject(QObject *parent = nullptr);
  // 通过Q_INVOKEBLE宏标记的public函数可以在QML中访问
  Q_INVOKABLE void sendSignal(); //  发送信号
  void setName(const QString &name);
  const QString &getName() const;
  void setYear(int32_t year);
  int32_t getYear() const;
signals:
  void cppSignalA(); // 一个无参数信号
  void cppSignalB(const QString &str, int32_t value);
  void nameChanged(const QString &name);
  void yearChanged(int32_t year);
public slots:
  void cppSlotA();                                  //  一个无参数槽函数
  void cppSlotB(const QString &str, int32_t value); //  带参数槽函数
private:
  QString myName;
  int32_t myYear;
};

#endif /* QML_DEMO_CPP_OBJECT */
