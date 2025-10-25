load("@rules_cc//cc:cc_library.bzl", "cc_library")
load("@rules_qt//:qt_libraries.bzl", "QT_LIBRARIES")

# Create a mapping of available frameworks by checking for header files in each framework
# We look for any file in the Headers directory to determine if a framework exists
_all_framework_headers = glob(["lib/*.framework/Headers/*"], allow_empty = True)
# Extract unique framework names from the header paths
_available_framework_names = {hdr.split("/")[1].replace(".framework", ""): True for hdr in _all_framework_headers}.keys()

# Convert Qt6XXX library names to QtXXX framework names (e.g., Qt6Core -> QtCore, Qt63DCore -> Qt3DCore)
_framework_names = {library_name: ("Qt" + library_name[3:] if library_name.startswith("Qt6") else library_name) for _, _, library_name, _ in QT_LIBRARIES}

[
    cc_library(
        name = "qt_%s_mac" % name,
        hdrs = glob(["lib/%s.framework/Headers/**" % include_folder], allow_empty = True),
        includes = [
            "lib/%s.framework/Headers" % include_folder,
        ],
        additional_linker_inputs = [":lib"],
        linkopts = ["-F $(location :lib)"] + [
            "-framework %s" % _framework_names[library_name],  # macOS qt libs do not contain a 6 - e.g. instead of Qt6Core the lib is called QtCore
            "-rpath $(rootpath :lib)",
        ],
        include_prefix = "%s" % include_folder,
        strip_include_prefix = "lib/%s.framework/Headers" % include_folder,
        target_compatible_with = ["@platforms//os:osx"],
        visibility = ["//visibility:public"],
    )
    for name, include_folder, library_name, _ in QT_LIBRARIES
    if _framework_names[library_name] in _available_framework_names
]

# Create stub libraries for Qt modules that don't exist on macOS
# This prevents build failures when code depends on `:qt` which includes all modules
[
    cc_library(
        name = "qt_%s_mac" % name,
        target_compatible_with = ["@platforms//os:osx"],
        visibility = ["//visibility:public"],
        tags = ["manual"],  # Don't build unless explicitly requested
    )
    for name, include_folder, library_name, _ in QT_LIBRARIES
    if _framework_names[library_name] not in _available_framework_names
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
    srcs = glob(["plugins/**/*"], allow_empty = True),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "qml_files",
    srcs = glob(["qml/**/*"], allow_empty = True),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "modules_files",
    srcs = glob(["modules/**/*"], allow_empty = True),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "metatypes_files",
    srcs = glob(["metatypes/**/*"], allow_empty = True),
    visibility = ["//visibility:public"],
)

exports_files(
    ["qml", "plugins", "lib", "share"],
    visibility = ["//visibility:public"],
)
