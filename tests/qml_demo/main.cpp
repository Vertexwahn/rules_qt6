#include "qml_demo/cpp_object.h"
#include <QtCore/QDir>
#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>

int main(int argc, char *argv[]) {
  QGuiApplication app(argc, argv);
  qDebug() << "App path : " << QDir::currentPath();
  QQmlApplicationEngine engine;

  QString qml2_import_path = qgetenv("QML2_IMPORT_PATH");
  QString import_path;

  if (QDir::isRelativePath(qml2_import_path)) {
    import_path = QDir::currentPath() + "/" + qml2_import_path;
  } else {
    import_path = qml2_import_path;
  }
  qDebug() << "import path : " << import_path;

  engine.addImportPath(import_path);

  qmlRegisterType<CppObject>("CppObject", 1, 0, "CppObject");

  engine.load(QUrl(QStringLiteral("qrc:/qml_demo/main.qml")));
  if (engine.rootObjects().isEmpty()) {
    return -1;
  }
  return app.exec();
}
