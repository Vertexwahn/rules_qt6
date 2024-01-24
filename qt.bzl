"""qt common rules"""

load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_library", "cc_test")

def get_execution_requirements(ctx):
    exec_requirements = {}
    for elem in ctx.attr.tags:
        exec_requirements[elem] = "1"
    return exec_requirements

def _gen_ui_header(ctx):
    info = ctx.toolchains["@rules_qt//tools:toolchain_type"].qtinfo

    args = [ctx.file.ui_file.path, "-o", ctx.outputs.ui_header.path]

    deps = []
    for dep in info.data:
        deps += dep[DefaultInfo].files.to_list()

    ctx.actions.run(
        inputs = deps + [ctx.file.ui_file],
        outputs = [ctx.outputs.ui_header],
        arguments = args,
        executable = info.uic_path,
        execution_requirements = get_execution_requirements(ctx),
    )

    return [OutputGroupInfo(ui_header = depset([ctx.outputs.ui_header]))]

gen_ui_header = rule(
    implementation = _gen_ui_header,
    attrs = {
        "ui_file": attr.label(allow_single_file = True, mandatory = True),
        "ui_header": attr.output(),
    },
    toolchains = ["@rules_qt//tools:toolchain_type"],
)

def qt_ui_library(name, ui, deps, target_compatible_with = [], **kwargs):
    """Compiles a QT UI file and makes a library for it.

    Args:
      name: A name for the rule.
      ui: The ui file to compile.
      deps: cc_library dependencies for the library.
      target_compatible_with: A list of constraint_values that must be satisfied by the target
        platform in order for this toolchain to be selected for a target building for that platform.
      **kwargs: extra args pass to cc_library
    """
    tags = kwargs.get("tags", [])
    if "manual" not in tags:
        tags += ["manual"]

    gen_ui_header(
        name = "%s_uic" % name,
        ui_file = ui,
        ui_header = "ui_%s.h" % ui.split(".")[0],
        target_compatible_with = target_compatible_with,
        tags = tags,
    )
    cc_library(
        name = name,
        hdrs = [":%s_uic" % name],
        deps = deps,
        target_compatible_with = target_compatible_with,
        **kwargs
    )

def _gencpp(ctx):
    info = ctx.toolchains["@rules_qt//tools:toolchain_type"].qtinfo

    resource_files = [(f, ctx.actions.declare_file(f.path)) for f in ctx.files.files]
    for target_file, output in resource_files:
        ctx.actions.symlink(
            output = output,
            target_file = target_file,
        )

    args = ["--name", ctx.attr.resource_name, "--output", ctx.outputs.cpp.path, ctx.file.qrc.path]

    deps = []
    for dep in info.data:
        deps += dep[DefaultInfo].files.to_list()

    ctx.actions.run(
        inputs = deps + [resource for _, resource in resource_files] + [ctx.file.qrc],
        outputs = [ctx.outputs.cpp],
        arguments = args,
        executable = info.rcc_path,
        execution_requirements = get_execution_requirements(ctx),
    )
    return [OutputGroupInfo(cpp = depset([ctx.outputs.cpp]))]

gencpp = rule(
    implementation = _gencpp,
    attrs = {
        "resource_name": attr.string(),
        "files": attr.label_list(allow_files = True, mandatory = False),
        "qrc": attr.label(allow_single_file = True, mandatory = True),
        "cpp": attr.output(),
    },
    toolchains = ["@rules_qt//tools:toolchain_type"],
)

def _gencpp2(ctx):
    info = ctx.toolchains["@rules_qt//tools:toolchain_type"].qtinfo

    resource_files = ctx.files.files

    args = ["--name", ctx.attr.resource_name, "--output", ctx.outputs.cpp.path, ctx.file.qrc.path]

    deps = []
    for dep in info.data:
        deps += dep[DefaultInfo].files.to_list()

    ctx.actions.run(
        inputs = deps + [resource for resource in resource_files] + [ctx.file.qrc],
        outputs = [ctx.outputs.cpp],
        arguments = args,
        executable = info.rcc_path,
        execution_requirements = get_execution_requirements(ctx),
    )
    return [OutputGroupInfo(cpp = depset([ctx.outputs.cpp]))]

gencpp2 = rule(
    implementation = _gencpp2,
    attrs = {
        "resource_name": attr.string(),
        "files": attr.label_list(allow_files = True, mandatory = False),
        "qrc": attr.label(allow_single_file = True, mandatory = True),
        "cpp": attr.output(),
    },
    toolchains = ["@rules_qt//tools:toolchain_type"],
)

# generate a qrc file that lists each of the input files.
def _genqrc(ctx):
    qrc_output = ctx.outputs.qrc
    qrc_content = "<RCC>\n  <qresource prefix=\\\"/\\\">"

    for f in ctx.files.files:
        qrc_content += "\n    <file>%s</file>" % f.path

    qrc_content += "\n  </qresource>\n</RCC>"
    cmd = ["echo", "\"%s\"" % qrc_content, ">", qrc_output.path]

    ctx.actions.run_shell(
        command = " ".join(cmd),
        outputs = [qrc_output],
        execution_requirements = get_execution_requirements(ctx),
    )
    return [OutputGroupInfo(qrc = depset([qrc_output]))]

genqrc = rule(
    implementation = _genqrc,
    attrs = {
        "files": attr.label_list(allow_files = True, mandatory = True),
        "qrc": attr.output(),
    },
)

def qt_resource_via_qrc(name, qrc_file, files, target_compatible_with = [], **kwargs):
    """Creates a cc_library containing the contents of all input files using qt's `rcc` tool.

    Args:
      name: rule name
      qrc_file: qt qrc file
      files: a list of files to be included in the resource bundle
      target_compatible_with: A list of constraint_values that must be satisfied by the target
        platform in order for this toolchain to be selected for a target building for that platform.
      **kwargs: extra args to pass to the cc_library
    """

    # every resource cc_library that is linked into the same binary needs a
    # unique 'name'.
    rsrc_name = native.package_name().replace("/", "_") + "_" + name

    tags = kwargs.get("tags", [])
    if "manual" not in tags:
        tags += ["manual"]

    outfile = name + "_gen.cpp"
    gencpp2(
        name = name + "_gen",
        resource_name = rsrc_name,
        files = files,
        qrc = qrc_file,
        cpp = outfile,
        target_compatible_with = target_compatible_with,
        tags = tags,
    )
    cc_library(
        name = name,
        srcs = [outfile],
        alwayslink = 1,
        target_compatible_with = target_compatible_with,
        **kwargs
    )

def qt_resource(name, files, target_compatible_with = [], **kwargs):
    """Creates a cc_library containing the contents of all input files using qt's `rcc` tool.

    Args:
      name: rule name
      files: a list of files to be included in the resource bundle
      target_compatible_with: A list of constraint_values that must be satisfied by the target
        platform in order for this toolchain to be selected for a target building for that platform.
      **kwargs: extra args to pass to the cc_library
    """
    qrc_file = name + "_qrc.qrc"
    genqrc(name = name + "_qrc", files = files, qrc = qrc_file, target_compatible_with = target_compatible_with)

    # every resource cc_library that is linked into the same binary needs a
    # unique 'name'.
    rsrc_name = native.package_name().replace("/", "_") + "_" + name

    tags = kwargs.get("tags", [])
    if "manual" not in tags:
        tags += ["manual"]

    outfile = name + "_gen.cpp"
    gencpp(
        name = name + "_gen",
        resource_name = rsrc_name,
        files = files,
        qrc = qrc_file,
        cpp = outfile,
        target_compatible_with = target_compatible_with,
        tags = tags,
    )
    cc_library(
        name = name,
        srcs = [outfile],
        alwayslink = 1,
        target_compatible_with = target_compatible_with,
        **kwargs
    )

def _gen_moc_cc(ctx):
    info = ctx.toolchains["@rules_qt//tools:toolchain_type"].qtinfo
    package_path = "{}/{}".format(ctx.label.workspace_root, ctx.label.package)
    out_file = ctx.outputs.filename
    args = [ctx.file.hdr.path, "-o", "{}".format(out_file.path), "-f", "{}".format(ctx.file.hdr.path)]

    deps = []
    for dep in info.data:
        deps += dep[DefaultInfo].files.to_list()

    ctx.actions.run(
        inputs = ctx.files.hdr + deps,
        outputs = [out_file],
        arguments = args,
        executable = info.moc_path,
        execution_requirements = get_execution_requirements(ctx),
        mnemonic = "QtMocGen",
        progress_message = "Creating QT MOC: %s for %s" % (
            out_file,
            ctx.label,
        ),
        toolchain = "@rules_qt//tools:toolchain_type",
    )
    return [OutputGroupInfo(cpp = depset([ctx.outputs.filename]))]

gen_moc_cc = rule(
    implementation = _gen_moc_cc,
    attrs = {
        "hdr": attr.label(allow_single_file = True, mandatory = True),
        "filename": attr.output(mandatory = True),
    },
    toolchains = ["@rules_qt//tools:toolchain_type"],
)


def qt_cc_library(name, srcs, hdrs, normal_hdrs = [], deps = None, copts = [], target_compatible_with = [], **kwargs):
    """Compiles a QT library and generates the MOC for it.

    Args:
      name: A name for the rule.
      srcs: The cpp files to compile.
      hdrs: The header files that the MOC compiles to src.
      normal_hdrs: Headers which are not sources for generated code.
      deps: cc_library dependencies for the library.
      copts: cc_library copts
      target_compatible_with: A list of constraint_values that must be satisfied by the target
        platform in order for this toolchain to be selected for a target building for that platform.
      **kwargs: Any additional arguments are passed to the cc_library rule.
    """
    tags = kwargs.get("tags", [])
    if "manual" not in tags:
        tags += ["manual"]

    _moc_srcs = []
    for hdr in hdrs:
        moc_name = "%s_moc" % hdr.replace(".", "_")
        moc_src = moc_name + ".cc"
        gen_moc_cc(
            name = moc_name,
            hdr = hdr,
            filename = moc_src,
            tags = tags,
        )
        _moc_srcs.append(":" + moc_src)

    cc_library(
        name = name,
        srcs = srcs + _moc_srcs,
        hdrs = hdrs + normal_hdrs,
        deps = deps,
        copts = copts + select({
            "@platforms//os:windows": [],
            "//conditions:default": ["-fPIC"],
        }),
        target_compatible_with = target_compatible_with,
        **kwargs
    )

qt_plugin_data = select({
    "@platforms//os:linux": [Label("@qt_linux_x86_64//:plugin_files"), Label("@qt_linux_x86_64//:qml_files")],
    "@rules_qt//:osx_x86_64": [Label("@qt_mac_x86_64//:plugin_files"), Label("@qt_mac_x86_64//:qml_files")],
    "@rules_qt//:osx_arm64": [Label("@qt_mac_aarch64//:plugin_files"), Label("@qt_mac_aarch64//:qml_files")],
    "@platforms//os:windows": [Label("@qt_windows_x86_64//:plugin_files"), Label("@qt_windows_x86_64//:qml_files")],
})

def update_dict(source, env):
    result = {}
    result.update(source)
    result.update(env)
    return result

x86_workspace = Label("@qt_linux_x86_64//:plugin_files").workspace_root
x86_package = Label("@qt_linux_x86_64//:plugin_files").package
LINUX_ENV_DATA = {
    "QT_QPA_PLATFORM_PLUGIN_PATH": "{}/{}/plugins/platforms".format(x86_workspace, x86_package),
    "QML2_IMPORT_PATH": "{}/{}/qml".format(x86_workspace, x86_package),
    "QT_PLUGIN_PATH": "{}/{}/plugins".format(x86_workspace, x86_package),
}

mac_x86_workspace = Label("@qt_mac_x86_64//:plugin_files").workspace_root
mac_x86_package = Label("@qt_mac_x86_64//:plugin_files").package
MAC_X64_ENV_DATA = {
    "QT_QPA_PLATFORM_PLUGIN_PATH": "{}/{}/share/qt/plugins/platforms".format(mac_x86_workspace, mac_x86_package),
    "QML2_IMPORT_PATH": "{}/{}/qml".format(mac_x86_workspace, mac_x86_package),
    "QT_PLUGIN_PATH": "{}/{}/share/qt/plugins".format(mac_x86_workspace, mac_x86_package),
}

win_workspace = Label("@qt_windows_x86_64//:plugin_files").workspace_root
win_package = Label("@qt_windows_x86_64//:plugin_files").package
WINDOWS_ENV_DATA = {
    "QT_QPA_PLATFORM_PLUGIN_PATH": "{}/{}/plugins/platforms".format(win_workspace, win_package),
    "QML2_IMPORT_PATH": "{}/{}/qml".format(win_workspace, win_package),
    "QT_PLUGIN_PATH": "{}/{}/plugins".format(win_workspace, win_package),
}

mac_m1_workspace = Label("@qt_mac_aarch64//:plugin_files").workspace_root
mac_m1_package = Label("@qt_mac_aarch64//:plugin_files").package
MAC_M1_ENV_DATA = {
    "QT_QPA_PLATFORM_PLUGIN_PATH": "{}/{}/share/qt/plugins/platforms".format(mac_m1_workspace, mac_m1_package),
    "QML2_IMPORT_PATH": "{}/{}/qml".format(mac_m1_workspace, mac_m1_package),
    "QT_PLUGIN_PATH": "{}/{}/share/qt/plugins".format(mac_m1_workspace, mac_m1_package),
}

def qt_cc_binary(name, srcs, deps = None, copts = [], data = [], env = {}, **kwargs):
    """ cc_binary which depend on qt_cc_library or want to use qt tools

    Args:
      name: A name for the rule.
      srcs: The cpp files to compile.
      deps: cc_library dependencies for the library.
      copts: cc_library copts
      data: which data need to depend
      env: environment value
      **kwargs: Any additional arguments are passed to the cc_library rule.
    """
    linux_env_data = update_dict(LINUX_ENV_DATA, env)
    mac_x64_env_data = update_dict(MAC_X64_ENV_DATA, env)
    windows_env_data = update_dict(WINDOWS_ENV_DATA, env)
    mac_m1_env_data = update_dict(MAC_M1_ENV_DATA, env)
    cc_binary(
        name = name,
        srcs = srcs,
        deps = deps,
        copts = copts + select({
            "@platforms//os:windows": [],
            "//conditions:default": ["-fPIC"],
        }),
        data = qt_plugin_data + data,
        env = select({
            "@platforms//os:linux": linux_env_data,
            "@rules_qt//:osx_x86_64": mac_x64_env_data,
            "@rules_qt//:osx_arm64": mac_m1_env_data,
            "@platforms//os:windows": windows_env_data,
        }),
        **kwargs
    )

def qt_cc_test(name, srcs, deps = None, copts = [], data = [], env = {}, **kwargs):
    """ cc_test which depend on qt_cc_library or want to use qt tools

    Args:
      name: A name for the rule.
      srcs: The cpp files to compile.
      deps: cc_library dependencies for the library.
      copts: cc_test copts
      data: which data need to depend
      env: environment value
      **kwargs: Any additional arguments are passed to the cc_test rule.
    """
    linux_env_data = update_dict(LINUX_ENV_DATA, env)
    mac_x64_env_data = update_dict(MAC_X64_ENV_DATA, env)
    windows_env_data = update_dict(WINDOWS_ENV_DATA, env)
    mac_m1_env_data = update_dict(MAC_M1_ENV_DATA, env)
    cc_test(
        name = name,
        srcs = srcs,
        deps = deps,
        copts = copts + select({
            "@platforms//os:windows": [],
            "//conditions:default": ["-fPIC"],
        }),
        data = qt_plugin_data + data,
        env = select({
            "@platforms//os:linux": linux_env_data,
            "@rules_qt//:osx_x86_64": mac_x64_env_data,
            "@rules_qt//:osx_arm64": mac_m1_env_data,
            "@platforms//os:windows": windows_env_data,
        }),
        **kwargs
    )
