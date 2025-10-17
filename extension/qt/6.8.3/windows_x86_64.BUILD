load("@rules_cc//cc:cc_import.bzl", "cc_import")
load("@rules_cc//cc:cc_library.bzl", "cc_library")
load("@rules_qt//:qt_libraries.bzl", "QT_LIBRARIES")

# Create a mapping of available libraries by checking what .lib files exist
_available_libs = glob(["lib/Qt6*.lib"])
_available_lib_names = [lib.replace("lib/", "").replace(".lib", "") for lib in _available_libs]

[
    cc_import(
        name = "qt_%s_windows_import" % name,
        hdrs = glob(
            ["include/%s/**" % include_folder],
            allow_empty = True,
        ),
        interface_library = "lib/%s.lib" % library_name,
        shared_library = "bin/%s.dll" % library_name,
        target_compatible_with = ["@platforms//os:windows"],
    )
    for name, include_folder, library_name, _ in QT_LIBRARIES
    if library_name in _available_lib_names
]

[
    cc_library(
        name = "qt_%s_windows" % name,
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
        deps = [":qt_%s_windows_import" % name],
    )
    for name, include_folder, library_name, _ in QT_LIBRARIES
    if library_name in _available_lib_names
]

# Create stub libraries for Qt modules that don't exist on Windows
# This prevents build failures when code depends on `:qt` which includes all modules
[
    cc_library(
        name = "qt_%s_windows" % name,
        target_compatible_with = ["@platforms//os:windows"],
        visibility = ["//visibility:public"],
        tags = ["manual"],  # Don't build unless explicitly requested
    )
    for name, _, library_name, _ in QT_LIBRARIES
    if library_name not in _available_lib_names
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

exports_files(
    ["qml", "plugins", "lib"],
    visibility = ["//visibility:public"],
)