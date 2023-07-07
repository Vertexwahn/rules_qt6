load("@rules_qt//:qt_libraries.bzl", "QT_LIBRARIES")

[
    cc_library(
        name = "qt_%s_mac" % name,
        hdrs = glob(["include/%s/**" % include_folder]),  # allow_empty = True
        includes = [
            "include",
            "include/%s" % include_folder,
        ],
        linkopts = ["-F/opt/homebrew/lib"] + [
            "-framework %s" % library_name.replace("6", ""),  # macOS qt libs do not contain a 6 - e.g. instead of Qt6Core the lib is called QtCore
        ],
        target_compatible_with = ["@platforms//os:osx"],
        visibility = ["//visibility:public"],
    )
    for name, include_folder, library_name, _ in QT_LIBRARIES
]

cc_library(
    name = "qt_hdrs",
    hdrs = glob(["include/**"]),
    includes = [
        "include",
    ],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "uic",
    srcs = ["share/qt/libexec/uic"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "moc",
    srcs = ["share/qt/libexec/moc"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "rcc",
    srcs = ["share/qt/libexec/rcc"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "plugin_files",
    srcs = glob(["share/qt/plugins/**/*"]),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "qml_files",
    srcs = glob(["qml/**/*"]),
    visibility = ["//visibility:public"],
)
