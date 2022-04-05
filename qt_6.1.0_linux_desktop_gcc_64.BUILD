load("@bazel_skylib//lib:paths.bzl", "paths")
load("@//:qt_libraries.bzl", "QT_LIBRARIES")

[
    cc_library(
        name = "qt_%s_linux" % name,
        hdrs = glob(["include/%s/**" % include_folder]),
        srcs = glob([
            "lib/lib%s.so*" % library_name,
            "lib/libicu*.so*",
        ]),
        includes = ["include"],
        # Available from Bazel 4.0.0
        target_compatible_with = ["@platforms//os:linux"],
        visibility = ["//visibility:public"],
    )
    for name, include_folder, library_name, _ in QT_LIBRARIES
]

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
    name = "plugin_files",
    srcs = glob(["plugins/**/*"]),
    visibility = ["//visibility:public"],
)