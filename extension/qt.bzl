load("//extension:download_qt.bzl", "download_qt")

def _fetch_impl(mctx):
    # Track repositories already created to avoid duplicates
    repos_created = {}

    for mod in mctx.modules:
        for arg in mod.tags.install:
            if arg.target_sdk == "windows" and not arg.windows_architecture:
                fail("When using windows as a download type, you need to provide a windows architecture to use")

            # Only create the repository once, even if multiple modules request it
            if arg.name not in repos_created:
                download_qt(
                    name = arg.name,
                    version = arg.version,
                    os = arg.os,
                    target_sdk = arg.target_sdk,
                    build_file = arg.build_file,
                    windows_architecture = arg.windows_architecture,
                )
                repos_created[arg.name] = True

_install = tag_class(
    attrs = {
        "name": attr.string(default = "qt"),
        "version": attr.string(default = "6.8.3"),
        "os": attr.string(default = "linux"),  #TODO Make this cross with at least arm64/mac
        "target_sdk": attr.string(default = "desktop"),
        "build_file": attr.label(default = "@rules_qt//:qt_linux_x86_64.BUILD"),
        "windows_architecture": attr.string(default = ""),
    },
)

_tag_classes = {
    "install": _install,
}

fetch = module_extension(
    implementation = _fetch_impl,
    tag_classes = _tag_classes,
)
