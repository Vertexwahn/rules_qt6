load("@rules_qt//:download_qt.bzl", "download_qt")

def _aqt_install_impl(mctx):
    for mod in mctx.modules:
        for arg in mod.tags.install:
            if arg.os == "windows" and not arg.windows_architecture:
                fail("When using windows as a download type, you need to provide a windows architecture to use")
            print("Installing Qt {} for {} ({})".format(arg.version, arg.os, arg.target_sdk))
            download_qt(
                name = arg.name,
                version = arg.version,
                os = arg.os,
                target_sdk = arg.target_sdk,
                build_file = arg.build_file,
                windows_architecture = arg.windows_architecture,
                modules = arg.modules,
            )

_install = tag_class(
    attrs = {
        "name": attr.string(default = "qt"),
        "version": attr.string(default = "6.4.0"),
        "os": attr.string(default = "linux"),
        "target_sdk": attr.string(default = "desktop"),
        "build_file": attr.label(default = "@rules_qt//:qt_windows_x86_64.BUILD"),
        "windows_architecture": attr.string(default = ""),
        "modules": attr.string_list(default = []),
    },
)

_tag_classes = {
    "install": _install,
}

aqt_install = module_extension(
    implementation = _aqt_install_impl,
    tag_classes = _tag_classes,
)