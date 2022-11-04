load("@rules_qt//:qt.bzl", "qt_cc_library", "qt_cc_binary", "qt_resource")

qt_resource(
    name = "qt_demo_qrc",
    files = [
        "main.qml",
    ],
)

qt_cc_library(
    name = "cpp_object",
    srcs = [
        "cpp_object.cpp",
    ],
    hdrs = [
        "cpp_object.h",
    ],
    deps = [
        "//:qt",
    ],
)

qt_cc_binary(
    name = "qt_demo",
    srcs = [
        "main.cpp",
    ],
    deps = [
        ":cpp_object",
        ":qt_demo_qrc",
    ],
)
