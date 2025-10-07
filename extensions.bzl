load("@rules_qt//:fetch_qt.bzl", "fetch_qt6")
load("@rules_qt//:extensions/qt.bzl", "aqt_install")

def _qt_impl(ctx):
    for mod in ctx.modules:
        if mod.name == "rules_qt":
            fetch_qt6()

_fetch = tag_class(attrs = {})

qt = module_extension(
    implementation = _qt_impl,
    tag_classes = {
        "fetch": _fetch,
    },
)

# Export the aqt_install extension for Windows builds
qt_aqt = aqt_install
