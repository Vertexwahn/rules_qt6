"""Rules and macros to build Qt applications."""

load("@rules_cc//cc:cc_binary.bzl", "cc_binary")
load("@rules_cc//cc:cc_library.bzl", "cc_library")
load("@rules_cc//cc:cc_test.bzl", "cc_test")

_TOOLCHAIN_TYPE = "@rules_qt//tools:toolchain_type"

def _qt_tool(ctx, name):
    """Returns the executable of the Qt tool `name` (moc, rcc or uic) and the files needed to run it."""
    info = ctx.toolchains[_TOOLCHAIN_TYPE].qtinfo
    executable = getattr(info, name, None) or getattr(info, name + "_path", None)
    if not executable:
        fail("The Qt toolchain does not provide `{}`".format(name))
    return executable, getattr(info, "files", None) or depset()

def _execution_requirements(ctx):
    return {tag: "1" for tag in ctx.attr.tags}

def _gen_ui_header(ctx):
    executable, tools = _qt_tool(ctx, "uic")
    ctx.actions.run(
        inputs = [ctx.file.ui_file],
        outputs = [ctx.outputs.ui_header],
        arguments = [ctx.file.ui_file.path, "-o", ctx.outputs.ui_header.path],
        executable = executable,
        tools = tools,
        execution_requirements = _execution_requirements(ctx),
        mnemonic = "QtUic",
        progress_message = "Generating %{output}",
    )
    return [OutputGroupInfo(ui_header = depset([ctx.outputs.ui_header]))]

gen_ui_header = rule(
    implementation = _gen_ui_header,
    attrs = {
        "ui_file": attr.label(allow_single_file = True, mandatory = True),
        "ui_header": attr.output(),
    },
    toolchains = [_TOOLCHAIN_TYPE],
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
        tags = kwargs.get("tags"),
    )
    cc_library(
        name = name,
        hdrs = [":%s_uic" % name],
        deps = deps,
        target_compatible_with = target_compatible_with,
        **kwargs
    )

def _gen_moc(ctx):
    executable, tools = _qt_tool(ctx, "moc")
    ctx.actions.run(
        inputs = [ctx.file.hdr],
        outputs = [ctx.outputs.out],
        arguments = [ctx.file.hdr.path, "-o", ctx.outputs.out.path, "-f" + ctx.attr.include],
        executable = executable,
        tools = tools,
        execution_requirements = _execution_requirements(ctx),
        mnemonic = "QtMoc",
        progress_message = "Generating %{output}",
    )
    return [DefaultInfo(files = depset([ctx.outputs.out]))]

gen_moc = rule(
    implementation = _gen_moc,
    doc = "Runs the Qt Meta-Object Compiler (moc) on a header.",
    attrs = {
        "hdr": attr.label(allow_single_file = True, mandatory = True, doc = "Header with Q_OBJECT classes."),
        "include": attr.string(mandatory = True, doc = "Path of the header in the `#include` of the generated file."),
        "out": attr.output(mandatory = True, doc = "Generated C++ file."),
    },
    toolchains = [_TOOLCHAIN_TYPE],
)

def _gencpp(ctx):
    resource_files = [(f, ctx.actions.declare_file(f.path)) for f in ctx.files.files]
    for target_file, output in resource_files:
        ctx.actions.symlink(
            output = output,
            target_file = target_file,
        )

    executable, tools = _qt_tool(ctx, "rcc")
    ctx.actions.run(
        inputs = [resource for _, resource in resource_files] + [ctx.file.qrc],
        outputs = [ctx.outputs.cpp],
        arguments = ["--name", ctx.attr.resource_name, "--output", ctx.outputs.cpp.path, ctx.file.qrc.path],
        executable = executable,
        tools = tools,
        execution_requirements = _execution_requirements(ctx),
        mnemonic = "QtRcc",
        progress_message = "Generating %{output}",
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
    toolchains = [_TOOLCHAIN_TYPE],
)

def _gencpp2(ctx):
    executable, tools = _qt_tool(ctx, "rcc")
    ctx.actions.run(
        inputs = ctx.files.files + [ctx.file.qrc],
        outputs = [ctx.outputs.cpp],
        arguments = ["--name", ctx.attr.resource_name, "--output", ctx.outputs.cpp.path, ctx.file.qrc.path],
        executable = executable,
        tools = tools,
        execution_requirements = _execution_requirements(ctx),
        mnemonic = "QtRcc",
        progress_message = "Generating %{output}",
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
    toolchains = [_TOOLCHAIN_TYPE],
)

# generate a qrc file that lists each of the input files.
def _genqrc(ctx):
    content = "<RCC>\n  <qresource prefix=\"/\">"
    for f in ctx.files.files:
        content += "\n    <file>%s</file>" % f.path
    content += "\n  </qresource>\n</RCC>\n"
    ctx.actions.write(output = ctx.outputs.qrc, content = content)
    return [OutputGroupInfo(qrc = depset([ctx.outputs.qrc]))]

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
        tags = kwargs.get("tags"),
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
        tags = kwargs.get("tags"),
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
        gen_moc(
            name = moc_name,
            hdr = hdr,
            include = header_path,
            out = moc_name + ".cpp",
            target_compatible_with = target_compatible_with,
            tags = kwargs.get("tags"),
        )
        _moc_srcs.append(":" + moc_name)
    cc_library(
        name = name,
        srcs = srcs + _moc_srcs,
        hdrs = hdrs + normal_hdrs,
        textual_hdrs = _moc_srcs,
        deps = deps,
        copts = _copts(copts),
        target_compatible_with = target_compatible_with,
        **kwargs
    )

# Labels are resolved relative to rules_qt - users only need `use_repo` for repositories they reference directly
_LINUX_AARCH64 = Label("//:linux_aarch64")
_LINUX_X86_64 = Label("//:linux_x86_64")
_OSX_ARM64 = Label("//:osx_arm64")
_OSX_X86_64 = Label("//:osx_x86_64")
_WINDOWS = Label("@platforms//os:windows")

def _plugin_data(repository, targets = ["qml", "plugins", "lib", "modules_files", "metatypes_files"]):
    return [Label("{}//:{}".format(repository, target)) for target in targets]

qt_plugin_data = select({
    _LINUX_AARCH64: _plugin_data("@qt_linux_aarch64"),
    _LINUX_X86_64: _plugin_data("@qt_linux_x86_64"),
    _OSX_ARM64: _plugin_data("@qt_mac_aarch64"),
    _OSX_X86_64: _plugin_data("@qt_mac_x86_64"),
    _WINDOWS: _plugin_data("@qt_windows_x86_64", ["plugins", "qml", "plugin_files", "qml_files"]),
})

def update_dict(source, env):
    result = {}
    result.update(source)
    result.update(env)
    return result

def _env_data(repository):
    plugins = Label(repository + "//:plugins")
    return {
        "QT_QPA_PLATFORM_PLUGIN_PATH": "$(location {})/platforms".format(plugins),
        "QML2_IMPORT_PATH": "$(location {})".format(Label(repository + "//:qml")),
        "QT_PLUGIN_PATH": "$(location {})".format(plugins),
    }

LINUX_AARCH64_ENV_DATA = update_dict({"QT_QPA_PLATFORM": "xcb"}, _env_data("@qt_linux_aarch64"))

LINUX_X86_64_ENV_DATA = update_dict({"QT_QPA_PLATFORM": "xcb"}, _env_data("@qt_linux_x86_64"))

# Deprecated - use LINUX_X86_64_ENV_DATA
LINUX_ENV_DATA = LINUX_X86_64_ENV_DATA

MAC_M1_ENV_DATA = _env_data("@qt_mac_aarch64")

MAC_X64_ENV_DATA = _env_data("@qt_mac_x86_64")

WINDOWS_ENV_DATA = _env_data("@qt_windows_x86_64")

def _qt_env(env):
    return select({
        _LINUX_AARCH64: update_dict(LINUX_AARCH64_ENV_DATA, env),
        _LINUX_X86_64: update_dict(LINUX_X86_64_ENV_DATA, env),
        _OSX_ARM64: update_dict(MAC_M1_ENV_DATA, env),
        _OSX_X86_64: update_dict(MAC_X64_ENV_DATA, env),
        _WINDOWS: update_dict(WINDOWS_ENV_DATA, env),
    })

# Qt DLLs needed at runtime on Windows, e.g. by Qt plugins (Linux and macOS use the `lib` directory of `qt_plugin_data`)
_QT_RUNTIME = select({
    _WINDOWS: [Label("@qt_windows_x86_64//:qt_runtime")],
    "//conditions:default": [],
})

def _copts(copts):
    return copts + select({
        _WINDOWS: [],
        "//conditions:default": ["-fPIC"],
    })

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
    cc_binary(
        name = name,
        srcs = srcs,
        deps = (deps or []) + _QT_RUNTIME,
        copts = _copts(copts),
        data = qt_plugin_data + data,
        env = _qt_env(env),
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
    cc_test(
        name = name,
        srcs = srcs,
        deps = (deps or []) + _QT_RUNTIME,
        copts = _copts(copts),
        data = qt_plugin_data + data,
        env = _qt_env(env),
        **kwargs
    )
