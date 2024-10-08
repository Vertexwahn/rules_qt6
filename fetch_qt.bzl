"""qt library fetch"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def fetch_qt6():
    """function which fetch remote prebuild qt libraries or use local qt(in macos)
    """

    http_archive(
        name = "qt_windows_x86_64",
        urls = [
            "https://dl.dropboxusercontent.com/scl/fi/5u79o4iqx7ija38h075rd/qt_6.7.3_windows_msvc2022_64_gamepad.zip?rlkey=c3gg9a4xw5s8ewyrnqz5gh82p&dl=0",
        ],
        sha256 = "6cfec811307a9dea55fc11d24f6c6f828a8cacf39e12ff13740efb0b227cb2c1",
        build_file = "@rules_qt//:qt_windows_x86_64.BUILD",
    )

    #native.new_local_repository(
    #    name = "qt_windows_x86_64",
    #    path = "C:\\Qt\\6.4.0\\msvc2019_64",
    #    build_file = "@rules_qt//:qt_windows_x86_64.BUILD",
    #)

    http_archive(
        name = "qt_linux_x86_64",
        urls = [
            "https://dl.dropboxusercontent.com/scl/fi/0qf3lcph52a3dfsf9gszb/qt_6.7.3_linux_desktop_gcc_64_gamepad.tar.xz?rlkey=aya7qoj1354ep1iunddgu8f6m&dl=0",
        ],
        sha256 = "101dfab81e1b41d582476df5bf27c355871754b94597a72ad3eefe711aea43af",
        strip_prefix = "Qt-6.7.3",
        build_file = "@rules_qt//:qt_linux_x86_64.BUILD",
    )

    #http_archive(
    #    name = "qt_mac_x86_64",
    #    urls = ["https://vertexwahn.de/lfs/v1/qt_mac_x86_64.zip"],
    #    sha256 = "9543aa178a6fe6aa138e4319fb07a106375b7fef11be150d154d5c1b8a321721",
    #    strip_prefix = "6.2.4/macos",
    #    build_file = "@rules_qt////:qt_mac_x86_64.BUILD",
    #)

    # On macOS we make use of an system installed Qt6
    # installation works via:
    # $ brew install qt@6
    # $ brew link qt@6

    # Check if path exists
    # native.new_local_repository(
    #     name = "qt_mac_x86_64",
    #     path = "/usr/local/opt/qt@6",  #"/usr/local/opt/qt@6",
    #     build_file = "@rules_qt//:qt_mac_x86_64.BUILD",
    # )

    # native.new_local_repository(
    #     name = "qt_mac_aarch64",
    #     path = "/opt/homebrew/",  # after brew link, is't ok just use /opt/homebrew
    #     build_file = "@rules_qt//:qt_mac_aarch64.BUILD",
    # )
