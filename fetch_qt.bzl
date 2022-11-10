"""qt library fetch"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def fetch_qt6():
    ### Qt 6.4.0
    http_archive(
        name = "qt_6.4.0_windows_desktop_win64_msvc2019_64",
        urls = [
            "https://vertexwahn.de/lfs/v1/qt_6.4.0_windows_desktop_win64_msvc2019_64.zip",
        ],
        sha256 = "e3c20b441ddd8bb803e46de32bf2fc5563fda125409d62dcd12b5647ae5a9c7e",
        strip_prefix = "6.4.0/msvc2019_64",
        build_file = "@rules_qt//:qt_6.4.0_windows_desktop_win64_msvc2019_64.BUILD",
    )

    #native.new_local_repository(
    #    name = "qt_6.4.0_windows_desktop_win64_msvc2019_64",
    #    path = "C:\\Qt\\6.4.0\\msvc2019_64",
    #    build_file = "@rules_qt//:qt_6.4.0_windows_desktop_win64_msvc2019_64.BUILD",
    #)

    ### Qt 6.2.4
    http_archive(
        name = "qt_6.2.4_linux_desktop_gcc_64",
        urls = [
            "https://vertexwahn.de/lfs/v1/qt_6.2.4_linux_desktop_gcc_64.tar.xz",
        ],
        sha256 = "50f969898d0112c9035ff9833fca52bad7f6ba95e6d837add15ff9f22badbd69",
        strip_prefix = "6.2.4/gcc_64",
        build_file = "@rules_qt//:qt_6.2.4_linux_desktop_gcc_64.BUILD",
    )

    #http_archive(
    #    name = "qt_6.2.4_mac_desktop_clang_64",
    #    urls = ["https://vertexwahn.de/lfs/v1/qt_6.2.4_mac_desktop_clang_64.zip"],
    #    sha256 = "9543aa178a6fe6aa138e4319fb07a106375b7fef11be150d154d5c1b8a321721",
    #    strip_prefix = "6.2.4/macos",
    #    build_file = "@rules_qt////:qt_6.2.4_mac_desktop_clang_64.BUILD",
    #)

    # On macOS we make use of an system installed Qt6
    # installation works via:
    # $ brew install qt@6
    # $ brew link qt@6
    # Note: brew will not necessarily install the exact Qt version 6.2.4

    # Check if paht exists
    native.new_local_repository(
        name = "qt_6.2.4_mac_desktop_clang_64",
        path = "/usr/local/opt/qt@6",  #"/usr/local/opt/qt@6",
        build_file = "@rules_qt//:qt_6.2.4_mac_desktop_clang_64.BUILD",
    )

    native.new_local_repository(
        name = "qt_6.4.0_mac_desktop_clang_64_M1",
        path = "/opt/homebrew/Cellar/qt/6.3.2",  #"/usr/local/opt/qt@6",
        build_file = "@rules_qt//:qt_6.4.0_mac_desktop_clang_64_M1.BUILD",
    )
