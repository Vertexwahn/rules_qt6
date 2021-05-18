load("@bazel_skylib//lib:paths.bzl", "paths")

QT_LIBRARIES = [
    ("core", "QtCore", "Qt6Core", []),
    ("network", "QtNetwork", "Qt6Network", []),
    ("widgets", "QtWidgets", "Qt6Widgets", [":qt_core", ":qt_gui"]),
    ("quick", "QtQuick", "Qt6Quick", [":qt_gui", ":qt_qml"]),
    ("qml", "QtQml", "Qt6Qml", [":qt_core", ":qt_network"]),
    ("qml_models", "QtQmlModels", "Qt6QmlModels", []),
    ("gui", "QtGui", "Qt6Gui", [":qt_core"]),
    ("opengl", "QtOpenGL", "Qt6OpenGL", []),
]

[
    cc_import(
        name = "qt_%s_linux_import" % name,
        # When being on Linux this glob will be empty
        hdrs = glob(["include/%s/**" % include_folder], allow_empty = True),
        interface_library = "lib/lib%s.so" % library_name,
        shared_library = "lib/lib%s.so" % library_name,
        # Not available in cc_import (See: https://github.com/bazelbuild/bazel/issues/12745)
        #target_compatible_with = ["@platforms//os:linux"],
    )
    for name, include_folder, library_name, _ in QT_LIBRARIES
]

[
    cc_library(
        name = "qt_%s_linux" % name,
        # When being on Linux this glob will be empty
        hdrs = glob(["include/%s/**" % include_folder], allow_empty = True),
        includes = ["include"],
        # Available from Bazel 4.0.0
        target_compatible_with = ["@platforms//os:linux"],
        deps = [":qt_%s_linux_import" % name],
        visibility = ["//visibility:public"],
    )
    for name, include_folder, _, _ in QT_LIBRARIES
]

#[
#    cc_library(
#        name = "qt_%s_linux" % name,
#        # When being on Windows this glob will be empty
#        hdrs = glob(["include/%s/**" % include_folder], allow_empty = True),
#        includes = ["include"],
#        linkopts = ["-l%s" % library_name],
#        target_compatible_with = ["@platforms//os:linux"],
#        visibility = ["//visibility:public"],
#    )
#    for name, include_folder, library_name, _ in QT_LIBRARIES
#]

filegroup(
    name = "uic",
    srcs = ["libexec/uic"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "moc",
    srcs = ["libexec/moc"],
    visibility = ["//visibility:public"],
)
