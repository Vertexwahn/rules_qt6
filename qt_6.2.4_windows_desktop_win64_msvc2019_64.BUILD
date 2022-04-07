load("@//:qt_libraries.bzl", "QT_LIBRARIES")

[
    cc_import(
        name = "qt_%s_windows_import" % name,
        # When being on Linux this glob will be empty
        hdrs = glob(["include/%s/**" % include_folder], allow_empty = True),
        interface_library = "lib/%s.lib" % library_name,
        shared_library = "bin/%s.dll" % library_name,
        target_compatible_with = ["@platforms//os:windows"],
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
    name = "plugin_files",
    srcs = glob(["plugins/**/*"]),
    visibility = ["//visibility:public"],
)
