"""qt library fetch"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def fetch_qt6():
    """function which fetch remote prebuild qt libraries or use local qt(in macos)
    """

    http_archive(
        name = "qt_windows_x86_64",
        urls = [
            "https://dl.dropboxusercontent.com/scl/fi/a75eyqtu0542t203eyie2/qt_6.8.0_windows_msvc2022_64_gamepad.zip?rlkey=l2ucxa4by8c8tp3xioqoamm89&dl=0",
        ],
        sha256 = "59aa42d34a1b5f15dfc915830a1dbebd90c7b418cf1b726eff8d0fa2766d9827",
        build_file = "@rules_qt//:qt_windows_x86_64.BUILD",
    )

    http_archive(
        name = "qt_linux_x86_64",
        urls = [
            "https://dl.dropboxusercontent.com/scl/fi/n5aelrs4qg6lweuitb795/qt_6.8.0_linux_desktop_gcc_64_gamepad.tar.xz?rlkey=miuhkfeat53z7xk85y8abi7o3&dl=0",
        ],
        sha256 = "fc18569262fa23c19009a66cfe39ce5761c8e99bc161820cb971be0beec0bb8b",
        strip_prefix = "Qt-6.8.0",
        build_file = "@rules_qt//:qt_linux_x86_64.BUILD",
    )

    http_archive(
        name = "qt_mac_aarch64",
        urls = [
            "https://dl.dropboxusercontent.com/scl/fi/8io4wc9cx2kd2vfwswjmg/qt_6.8.0_mac_aarch64_gamepad.tar.xz?rlkey=afkk9qrub9i1gmelv7vktgtci&dl=0",
        ],
        sha256 = "07be3436bfb31b3a2e629907ca39a8652febe563046094cdc7373b7ff28228c4",
        strip_prefix = "Qt-6.8.0",
        build_file = "@rules_qt//:qt_mac_aarch64.BUILD",
    )
