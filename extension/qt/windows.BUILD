# BUILD file of the Qt repository for Windows (x86_64, MSVC) created by the `qt` module extension
load("@rules_cc//cc:cc_import.bzl", "cc_import")
load("@rules_cc//cc:cc_library.bzl", "cc_library")
load("@rules_qt//extension/qt:qt_libraries.bzl", "QT_LIBRARIES")

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
        tags = ["manual"],  # Don't build unless explicitly requested
        target_compatible_with = ["@platforms//os:windows"],
        visibility = ["//visibility:public"],
    )
    for name, _, library_name, _ in QT_LIBRARIES
    if library_name not in _available_lib_names
]

# Qt plugins (e.g. QML modules) depend on Qt libraries that an application does not link itself.
# qt_cc_binary and qt_cc_test depend on this target, so that all (release) Qt DLLs are copied next to the binary.
_dll_names = [dll[len("bin/"):-len(".dll")] for dll in glob(
    ["bin/Qt6*.dll"],
    allow_empty = True,
)]

_release_dll_names = [
    dll
    for dll in _dll_names
    if not (dll.endswith("d") and dll[:-1] in _dll_names) and dll in _available_lib_names
]

[
    cc_import(
        name = "%s_runtime" % dll,
        interface_library = "lib/%s.lib" % dll,
        shared_library = "bin/%s.dll" % dll,
        target_compatible_with = ["@platforms//os:windows"],
    )
    for dll in _release_dll_names
]

cc_library(
    name = "qt_runtime",
    target_compatible_with = ["@platforms//os:windows"],
    visibility = ["//visibility:public"],
    deps = [":%s_runtime" % dll for dll in _release_dll_names],
)

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
    name = "dll_files",
    srcs = glob(["bin/*.dll"]),
    visibility = ["//visibility:public"],
)

exports_files(
    [
        "qml",
        "plugins",
        "lib",
    ],
    visibility = ["//visibility:public"],
)
