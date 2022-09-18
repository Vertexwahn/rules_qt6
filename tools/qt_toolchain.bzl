QtToolchainInfo = provider(
    doc = "Information about how to invoke qt tools.",
    fields = ["rcc_path", "uic_path", "moc_path"],
)

def _qt_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        qtinfo = QtToolchainInfo(
            rcc_path = ctx.attr.rcc_path,
            uic_path = ctx.attr.uic_path,
            moc_path = ctx.attr.moc_path,
        ),
    )
    return [toolchain_info]

qt_toolchain = rule(
    implementation = _qt_toolchain_impl,
    attrs = {
        "rcc_path": attr.string(),
        "uic_path": attr.string(),
        "moc_path": attr.string(),
    },
)

def register_qt_toolchains():
    native.register_toolchains(
        "@de_vertexwahn_rules_qt6//tools:qt_linux_toolchain",
        "@de_vertexwahn_rules_qt6//tools:qt_windows_toolchain",
        "@de_vertexwahn_rules_qt6//tools:qt_osx_toolchain",
        "@de_vertexwahn_rules_qt6//tools:qt_osx_M1_toolchain",
    )
