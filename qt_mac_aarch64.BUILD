load("@rules_cc//cc:cc_library.bzl", "cc_library")
load("@rules_qt//:qt_libraries.bzl", "QT_LIBRARIES")

[
    cc_library(
        name = "qt_%s_mac" % name,
        hdrs = glob(["lib/%s.framework/Headers/**" % include_folder], allow_empty = True),
        includes = [
            "lib/%s.framework/Headers" % include_folder,
        ],
        additional_linker_inputs = [":lib"],
        linkopts = ["-F $(location :lib)"] + [
            "-framework %s" % library_name.replace("6", ""),  # macOS qt libs do not contain a 6 - e.g. instead of Qt6Core the lib is called QtCore
            "-rpath $(rootpath :lib)",
        ],
        include_prefix = "%s" % include_folder,
        strip_include_prefix = "lib/%s.framework/Headers" % include_folder,
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
