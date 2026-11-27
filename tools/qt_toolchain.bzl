"""Toolchain that provides the Qt tools moc, rcc and uic."""

QtToolchainInfo = provider(
    doc = "Information about how to invoke the Qt tools.",
    fields = {
        "files": "Files needed to run the tools given by the deprecated `*_cmd` attributes (depset)",
        "moc": "File of the Meta-Object Compiler (None if `moc_cmd` is used)",
        "moc_path": "Path of the Meta-Object Compiler (None if not available)",
        "rcc": "File of the Resource Compiler (None if `rcc_cmd` is used)",
        "rcc_path": "Path of the Resource Compiler (None if not available)",
        "uic": "File of the User Interface Compiler (None if `uic_cmd` is used)",
        "uic_path": "Path of the User Interface Compiler (None if not available)",
    },
)

def _tool(ctx, name):
    file = getattr(ctx.file, name)
    if file:
        return file, file.path
    cmd = getattr(ctx.attr, name + "_cmd")
    return None, (ctx.expand_location(cmd, ctx.attr.data) if cmd else None)

def _qt_toolchain_impl(ctx):
    moc, moc_path = _tool(ctx, "moc")
    rcc, rcc_path = _tool(ctx, "rcc")
    uic, uic_path = _tool(ctx, "uic")
    return [platform_common.ToolchainInfo(
        qtinfo = QtToolchainInfo(
            files = depset(ctx.files.data),
            moc = moc,
            moc_path = moc_path,
            rcc = rcc,
            rcc_path = rcc_path,
            uic = uic,
            uic_path = uic_path,
        ),
    )]

qt_toolchain = rule(
    implementation = _qt_toolchain_impl,
    attrs = {
        "data": attr.label_list(allow_files = True, doc = "Files referenced by the deprecated `*_cmd` attributes."),
        "moc": attr.label(allow_single_file = True, cfg = "exec", doc = "Qt Meta-Object Compiler."),
        "moc_cmd": attr.string(doc = "Deprecated - use `moc`. Path of the Meta-Object Compiler."),
        "rcc": attr.label(allow_single_file = True, cfg = "exec", doc = "Qt Resource Compiler."),
        "rcc_cmd": attr.string(doc = "Deprecated - use `rcc`. Path of the Resource Compiler."),
        "uic": attr.label(allow_single_file = True, cfg = "exec", doc = "Qt User Interface Compiler."),
        "uic_cmd": attr.string(doc = "Deprecated - use `uic`. Path of the User Interface Compiler."),
    },
)

def register_qt_toolchains(name = "register_qt_toolchains"):
    native.register_toolchains(
        "@rules_qt//tools:qt_linux_toolchain",
        "@rules_qt//tools:qt_linux_aarch64_toolchain",
        "@rules_qt//tools:qt_windows_toolchain",
        "@rules_qt//tools:qt_osx_toolchain",
        "@rules_qt//tools:qt_osx_M1_toolchain",
    )
