load("@rules_cc//cc:cc_library.bzl", "cc_library")
load("@rules_qt//:qt_libraries.bzl", "QT_LIBRARIES")

[
    cc_library(
        name = "qt_%s_linux" % name,
        srcs = glob([
            "lib/lib%s.so*" % library_name,
            "lib/libicu*.so*",
        ]),
        hdrs = glob([
            "include/%s/**" % include_folder,
        ]),
        includes = [
            "include",
            "include/%s" % include_folder,
        ],
        target_compatible_with = ["@platforms//os:linux"],
        visibility = ["//visibility:public"],
    )
    for name, include_folder, library_name, _ in QT_LIBRARIES
]

cc_library(
    name = "qt_hdrs",
    hdrs = glob([
        "include/**",
    ]),
    includes = [
        "include",
    ],
    visibility = ["//visibility:public"],
)

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

filegroup(
    name = "rcc",
    srcs = ["libexec/rcc"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "plugin_files",
    srcs = glob(["plugins/**/*"]),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "qml_files",
    srcs = glob(["qml/**/*"]),
    visibility = ["//visibility:public"],
)

exports_files(
    ["qml", "plugins", "lib"],
    visibility = ["//visibility:public"],
)
