#include "qml_demo/cpp_object.h"
#include <QtCore/QDir>
#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>

int main(int argc, char *argv[]) {
  QGuiApplication app(argc, argv);
  qDebug() << "App path : " << QDir::currentPath();
  QQmlApplicationEngine engine;

  engine.addImportPath("qrc:/qml_demo/qml");

  qmlRegisterType<CppObject>("CppObject", 1, 0, "CppObject");

  engine.load(QUrl(QStringLiteral("qrc:/qml_demo/main.qml")));
  if (engine.rootObjects().isEmpty()) {
    return -1;
  }
  return app.exec();
}
