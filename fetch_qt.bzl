"""qt library fetch"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def fetch_qt6():
    """function which fetch remote prebuild qt libraries or use local qt(in macos)
    """

    http_archive(
        name = "qt_windows_x86_64",
        urls = [
            "https://dl.dropboxusercontent.com/scl/fi/s96ot2qirkjqx3g5nctds/qt_6.5.1_windows_msvc2022_64.zip?rlkey=qq7cswbhtxcxg88emfyzb2s1k&dl=0",
        ],
        sha256 = "3e96d38afe95d32794fc98459379c063bb9f027379843b3d42ab58c68428e0e5",
        strip_prefix = "6.5.1/msvc2022_64",
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
            "https://dl.dropboxusercontent.com/scl/fi/1oscofwpr6kg0esb3ud9v/qt_6.5.1_linux_desktop_gcc_64.zip?rlkey=tmof818pcx8jl5lk2wznaowcs&dl=0",
        ],
        sha256 = "cd7a0190390d2ca68b5c06ac95d36af22836993233565acf2ec73b0f74d7c914",
        strip_prefix = "6.5.1/gcc_64",
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
    native.new_local_repository(
        name = "qt_mac_x86_64",
        path = "/usr/local/opt/qt@6",  #"/usr/local/opt/qt@6",
        build_file = "@rules_qt//:qt_mac_x86_64.BUILD",
    )

    native.new_local_repository(
        name = "qt_mac_aarch64",
        path = "/opt/homebrew/",  # after brew link, is't ok just use /opt/homebrew
        build_file = "@rules_qt//:qt_mac_aarch64.BUILD",
    )
