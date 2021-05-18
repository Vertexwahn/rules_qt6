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
        name = "qt_%s_windows_import" % name,
        # When being on Linux this glob will be empty
        hdrs = glob(["include/%s/**" % include_folder], allow_empty = True),
        interface_library = "lib/%s.lib" % library_name,
        shared_library = "bin/%s.dll" % library_name,
        # Not available in cc_import (See: https://github.com/bazelbuild/bazel/issues/12745)
        #target_compatible_with = ["@platforms//os:windows"],
    )
    for name, include_folder, library_name, _ in QT_LIBRARIES
]

[
    cc_library(
        name = "qt_%s_windows" % name,
        # When being on Linux this glob will be empty
        hdrs = glob(["include/%s/**" % include_folder], allow_empty = True),
        includes = ["include"],
        # Available from Bazel 4.0.0
        target_compatible_with = ["@platforms//os:windows"],
        deps = [":qt_%s_windows_import" % name],
        visibility = ["//visibility:public"],
    )
    for name, include_folder, _, _ in QT_LIBRARIES
]

filegroup(
    name = "platform_files",
    srcs = [
        #"plugins/platforms/qdirect2d.dll",
        #"plugins/platforms/qdirect2dd.dll",
        #"plugins/platforms/qminimal.dll",
        #"plugins/platforms/qminimald.dll",
        #"plugins/platforms/qoffscreen.dll",
        #"plugins/platforms/qoffscreend.dll",
        "plugins/platforms/qwindows.dll",
        #"plugins/platforms/qwindowsd.dll"
    ],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "uic",
    srcs = ["bin/uic.exe"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "moc",
    srcs = ["bin/moc.exe"],
    visibility = ["//visibility:public"],
)
