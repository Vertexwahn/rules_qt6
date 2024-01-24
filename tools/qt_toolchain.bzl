QtToolchainInfo = provider(
    doc = "Information about how to invoke qt tools.",
    fields = ["rcc_path", "uic_path", "moc_path", "data"],
)

def _qt_toolchain_impl(ctx):
    expand_rcc_path = ctx.expand_location(ctx.attr.rcc_cmd, ctx.attr.data)
    expand_uic_path = ctx.expand_location(ctx.attr.uic_cmd, ctx.attr.data)
    expand_moc_path = ctx.expand_location(ctx.attr.moc_cmd, ctx.attr.data)
    toolchain_info = platform_common.ToolchainInfo(
        qtinfo = QtToolchainInfo(
            rcc_path = expand_rcc_path,
            uic_path = expand_uic_path,
            moc_path = expand_moc_path,
            data = ctx.attr.data,
        ),
    )
    return [toolchain_info]

qt_toolchain = rule(
    implementation = _qt_toolchain_impl,
    attrs = {
        "rcc_cmd": attr.string(),
        "uic_cmd": attr.string(),
        "moc_cmd": attr.string(),
        "data": attr.label_list(allow_files = True),
    },
)

def register_qt_toolchains():
    native.register_toolchains(
        "@rules_qt//tools:qt_linux_toolchain",
        "@rules_qt//tools:qt_windows_toolchain",
        "@rules_qt//tools:qt_osx_toolchain",
        "@rules_qt//tools:qt_osx_M1_toolchain",
    )
