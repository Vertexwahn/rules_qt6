QT_LIBRARIES = [
    ("core", "QtCore", "Qt6Core", []),
    ("network", "QtNetwork", "Qt6Network", []),
    ("widgets", "QtWidgets", "Qt6Widgets", [":qt_core", ":qt_gui"]),
    ("quick", "QtQuick", "Qt6Quick", [":qt_gui", ":qt_qml"]),
    ("qml", "QtQml", "Qt6Qml", [":qt_core", ":qt_network"]),
    ("qml_models", "QtQmlModels", "Qt6QmlModels", []),
    ("gui", "QtGui", "Qt6Gui", [":qt_core", ":qt_dbus"]),
    ("opengl", "QtOpenGL", "Qt6OpenGL", [":qt_dbus"]),
    ("dbus", "QtDBus", "Qt6DBus", []),
]