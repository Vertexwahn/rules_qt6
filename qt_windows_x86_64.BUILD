load("@rules_cc//cc:cc_library.bzl", "cc_library")
load("@rules_qt//:qt_libraries.bzl", "QT_LIBRARIES")

# Get list of available DLLs
AVAILABLE_DLLS = glob(["bin/*.dll"])

# Create cc_import for libraries that have DLLs
[
    cc_import(
        name = "qt_%s_windows_import" % name,
        # When being on Linux this glob will be empty
        hdrs = glob(
            ["include/%s/**" % include_folder],
            allow_empty = True,
        ),
        interface_library = "lib/%s.lib" % library_name,
        shared_library = "bin/%s.dll" % library_name,
        target_compatible_with = ["@platforms//os:windows"],
    )
    for name, include_folder, library_name, _ in QT_LIBRARIES
    if "bin/%s.dll" % library_name in AVAILABLE_DLLS
]

# Create cc_library for all Qt modules
[
    cc_library(
        name = "qt_%s_windows" % name,
        # When being on Linux this glob will be empty
        hdrs = glob(
            ["include/%s/**" % include_folder],
            allow_empty = True,
        ),
        includes = [
            "include",
            "include/%s" % include_folder,
        ],
        target_compatible_with = ["@platforms//os:windows"],
        visibility = ["//visibility:public"],
        deps = [":qt_%s_windows_import" % name] if "bin/%s.dll" % library_name in AVAILABLE_DLLS else [],
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
    srcs = ["bin/uic.exe"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "moc",
    srcs = ["bin/moc.exe"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "rcc",
    srcs = ["bin/rcc.exe"],
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

filegroup(
    name = "bin_files",
    srcs = glob(
        ["bin/**/*"],
        allow_empty = True,
    ),
    visibility = ["//visibility:public"],
)

exports_files(
    ["qml", "plugins", "lib", "bin"],
    visibility = ["//visibility:public"],
)
