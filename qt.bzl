"""qt common rules"""

load("@rules_cc//cc:cc_binary.bzl", "cc_binary")
load("@rules_cc//cc:cc_library.bzl", "cc_library")
load("@rules_cc//cc:cc_test.bzl", "cc_test")
load("@rules_shell//shell:sh_binary.bzl", "sh_binary")

def _gen_ui_header(ctx):
    info = ctx.toolchains["@rules_qt//tools:toolchain_type"].qtinfo

    args = [ctx.file.ui_file.path, "-o", ctx.outputs.ui_header.path]

    exec_requirements = {}
    for elem in ctx.attr.tags:
        exec_requirements[elem] = "1"

    ctx.actions.run(
        inputs = [ctx.file.ui_file],
        outputs = [ctx.outputs.ui_header],
        arguments = args,
        executable = info.uic_path,
        execution_requirements = exec_requirements,
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
    gen_ui_header(
        name = "%s_uic" % name,
        ui_file = ui,
        ui_header = "ui_%s.h" % ui.split(".")[0],
        target_compatible_with = target_compatible_with,
        tags = ["local"],
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
    exec_requirements = {}
    for elem in ctx.attr.tags:
        exec_requirements[elem] = "1"

    ctx.actions.run(
        inputs = [resource for _, resource in resource_files] + [ctx.file.qrc],
        outputs = [ctx.outputs.cpp],
        arguments = args,
        executable = info.rcc_path,
        execution_requirements = exec_requirements,
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
    exec_requirements = {}
    for elem in ctx.attr.tags:
        exec_requirements[elem] = "1"
    ctx.actions.run(
        inputs = [resource for resource in resource_files] + [ctx.file.qrc],
        outputs = [ctx.outputs.cpp],
        arguments = args,
        executable = info.rcc_path,
        execution_requirements = exec_requirements,
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
    exec_requirements = {}
    for elem in ctx.attr.tags:
        exec_requirements[elem] = "1"
    ctx.actions.run_shell(
        command = " ".join(cmd),
        outputs = [qrc_output],
        execution_requirements = exec_requirements,
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

    outfile = name + "_gen.cpp"
    gencpp2(
        name = name + "_gen",
        resource_name = rsrc_name,
        files = files,
        qrc = qrc_file,
        cpp = outfile,
        target_compatible_with = target_compatible_with,
        tags = ["local"],
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

    outfile = name + "_gen.cpp"
    gencpp(
        name = name + "_gen",
        resource_name = rsrc_name,
        files = files,
        qrc = qrc_file,
        cpp = outfile,
        target_compatible_with = target_compatible_with,
        tags = [
            "local",
        ],
    )
    cc_library(
        name = name,
        srcs = [outfile],
        alwayslink = 1,
        target_compatible_with = target_compatible_with,
        **kwargs
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
    _moc_srcs = []
    for hdr in hdrs:
        header_path = "%s/%s" % (native.package_name(), hdr) if len(native.package_name()) > 0 else hdr
        moc_name = "moc_%s" % hdr.rsplit(".", 1)[0]
        native.genrule(
            name = moc_name,
            srcs = [hdr],
            outs = [moc_name + ".cpp"],
            cmd = select({
                "@platforms//os:linux": "$(location @qt_linux_x86_64//:moc) $(locations %s) -o $@ -f'%s'" % (hdr, header_path),
                "@platforms//os:windows": "$(location @qt_windows_x86_64//:moc) $(locations %s) -o $@ -f'%s'" % (hdr, header_path),
                "@rules_qt//:osx_x86_64": "$(location @qt_mac_x86_64//:moc) $(locations %s) -o $@ -f'%s'" % (hdr, header_path),
                "@rules_qt//:osx_arm64": "$(location @qt_mac_aarch64//:moc) $(locations %s) -o $@ -f'%s'" % (hdr, header_path),
            }),
            tools = select({
                "@platforms//os:linux": ["@qt_linux_x86_64//:moc"],
                "@platforms//os:windows": ["@qt_windows_x86_64//:moc"],
                "@rules_qt//:osx_arm64": ["@qt_mac_aarch64//:moc"],
                "@rules_qt//:osx_x86_64": ["@qt_mac_x86_64//:moc"],
            }),
            target_compatible_with = target_compatible_with,
        )
        _moc_srcs.append(":" + moc_name)
    cc_library(
        name = name,
        srcs = srcs + _moc_srcs,
        hdrs = hdrs + normal_hdrs,
        textual_hdrs = _moc_srcs,
        deps = deps,
        copts = copts + select({
            "@platforms//os:windows": [],
            "//conditions:default": ["-fPIC"],
        }),
        target_compatible_with = target_compatible_with,
        **kwargs
    )

qt_plugin_data = select({
    "@platforms//os:linux": [
        "@qt_linux_x86_64//:qml",
        "@qt_linux_x86_64//:plugins",
        "@qt_linux_x86_64//:lib",
        "@qt_linux_x86_64//:modules_files",
        "@qt_linux_x86_64//:metatypes_files",
    ],
    "@rules_qt//:osx_x86_64": [
        "@qt_mac_x86_64//:plugins",
        "@qt_mac_x86_64//:qml",
        "@qt_mac_x86_64//:lib",
        "@qt_mac_x86_64//:modules_files",
        "@qt_mac_x86_64//:metatypes_files",
    ],
    "@rules_qt//:osx_arm64": [
        "@qt_mac_aarch64//:plugins",
        "@qt_mac_aarch64//:qml",
        "@qt_mac_aarch64//:lib",
        "@qt_mac_aarch64//:modules_files",
        "@qt_mac_aarch64//:metatypes_files",
    ],
    "@platforms//os:windows": [
        "@qt_windows_x86_64//:plugins",
        "@qt_windows_x86_64//:qml",
        "@qt_windows_x86_64//:plugin_files",
        "@qt_windows_x86_64//:qml_files",
    ],
})

def update_dict(source, env):
    result = {}
    result.update(source)
    result.update(env)
    return result

LINUX_ENV_DATA = {
    "QT_QPA_PLATFORM": "xcb",
    "QT_QPA_PLATFORM_PLUGIN_PATH": "$(location @qt_linux_x86_64//:plugins)/platforms",
    "QML2_IMPORT_PATH": "$(location @qt_linux_x86_64//:qml)",
    "QT_PLUGIN_PATH": "$(location @qt_linux_x86_64//:plugins)",
}

MAC_X64_ENV_DATA = {
    "QT_QPA_PLATFORM_PLUGIN_PATH": "$(location @qt_mac_x86_64//:plugins)/platforms",
    "QML2_IMPORT_PATH": "$(location @qt_mac_x86_64//:qml)",
    "QT_PLUGIN_PATH": "$(location @qt_mac_x86_64//:plugins)",
}

WINDOWS_ENV_DATA = {
    "QT_QPA_PLATFORM_PLUGIN_PATH": "$(location @qt_windows_x86_64//:plugins)/platforms",
    "QML2_IMPORT_PATH": "$(location @qt_windows_x86_64//:qml)",
    "QT_PLUGIN_PATH": "$(location @qt_windows_x86_64//:plugins)",
}

MAC_M1_ENV_DATA = {
    "QT_QPA_PLATFORM_PLUGIN_PATH": "$(location @qt_mac_aarch64//:plugins)/platforms",
    "QML2_IMPORT_PATH": "$(location @qt_mac_aarch64//:qml)",
    "QT_PLUGIN_PATH": "$(location @qt_mac_aarch64//:plugins)",
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

    # On Linux, we need a wrapper to set LD_LIBRARY_PATH at runtime
    # because $(location) in env doesn't work correctly for dynamic library loading
    binary_name = name + "_bin" if select({"@platforms//os:linux": True, "//conditions:default": False}) else name
    pkg = native.package_name()
    binary_runfiles_path = pkg + "/" + binary_name if pkg else binary_name

    cc_binary(
        name = binary_name,
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

    # Only create wrapper for Linux to set LD_LIBRARY_PATH
    wrapper_script = name + "_wrapper.sh"
    native.genrule(
        name = name + "_gen_wrapper",
        srcs = [binary_name] + qt_plugin_data,
        outs = [wrapper_script],
        cmd = """
cat > $@ << 'WRAPPER_EOF'
#!/bin/bash
SCRIPT_DIR="$$(cd "$$(dirname "$$0")" && pwd)"
if [ -e "$$SCRIPT_DIR/""" + name + """.runfiles" ]; then
    RUNFILES_DIR="$$SCRIPT_DIR/""" + name + """.runfiles"
elif [ -e "$$0.runfiles" ]; then
    RUNFILES_DIR="$$0.runfiles"
else
    RUNFILES_DIR="$$SCRIPT_DIR"
fi

# Set LD_LIBRARY_PATH for QML plugin loading (required for dynamic library loading)
export LD_LIBRARY_PATH="$$RUNFILES_DIR/rules_qt++fetch+qt_linux_x86_64/lib:$$LD_LIBRARY_PATH"

# Set Qt environment variables using runfiles paths
export QT_QPA_PLATFORM="xcb"
export QT_QPA_PLATFORM_PLUGIN_PATH="$$RUNFILES_DIR/rules_qt++fetch+qt_linux_x86_64/plugins/platforms"
export QML2_IMPORT_PATH="$$RUNFILES_DIR/rules_qt++fetch+qt_linux_x86_64/qml"
export QT_PLUGIN_PATH="$$RUNFILES_DIR/rules_qt++fetch+qt_linux_x86_64/plugins"

# Run the binary
exec "$$RUNFILES_DIR/_main/""" + binary_runfiles_path + """" "$$@"
WRAPPER_EOF
chmod +x $@
""",
        target_compatible_with = ["@platforms//os:linux"],
    )
    sh_binary(
        name = name + "_sh",
        srcs = [wrapper_script],
        data = [binary_name] + qt_plugin_data + data,
        target_compatible_with = ["@platforms//os:linux"],
    )

    # Use wrapper on Linux, direct binary on other platforms
    native.alias(
        name = name,
        actual = select({
            "@platforms//os:linux": ":" + name + "_sh",
            "//conditions:default": ":" + binary_name,
        }),
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
