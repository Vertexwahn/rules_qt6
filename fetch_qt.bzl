"""qt library fetch"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def fetch_qt6():
    """function which fetch remote prebuild qt libraries for Linux and macOS
    Windows uses aqt-based fetching instead.
    """

    http_archive(
        name = "qt_linux_x86_64",
        urls = [
            "https://vertexwahn.de/lfs/v1/qt_6.4.0_linux_desktop_gcc_64.tar.xz",
        ],
        sha256 = "809919895e2ac0567df9290676d4ec6cd1ed39c432dc5da0722b3104681fd376",
        strip_prefix = "6.4.0/gcc_64",
        build_file = "@rules_qt//:qt_linux_x86_64.BUILD",
    )

    http_archive(
        name = "qt_mac_aarch64",
        urls = [
            "https://vertexwahn.de/lfs/v1/qt_6.8.0_mac_aarch64_gamepad.tar.xz",
        ],
        sha256 = "07be3436bfb31b3a2e629907ca39a8652febe563046094cdc7373b7ff28228c4",
        strip_prefix = "Qt-6.8.0",
        build_file = "@rules_qt//:qt_mac_aarch64.BUILD",
    )
