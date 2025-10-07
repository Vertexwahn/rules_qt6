load("@bazel_skylib//rules:diff_test.bzl", "diff_test")
load("@aspect_bazel_lib//lib:write_source_files.bzl", "write_source_file")

def _qt_installer_impl(ctx):
    args = ["install-qt"]
    args += ["--bzl-config-out", ctx.outputs.bzl_out.path]
    args += ["--bzl-update-target", "@{}//{}:{}.update".format(ctx.label.workspace_name, ctx.label.package, ctx.label.name)]
    args += [ctx.attr.os, ctx.attr.target_sdk, ctx.attr.version]
    
    if ctx.attr.modules:
        args.append("-m")
        args += ctx.attr.modules

    ctx.actions.run(
        executable = ctx.executable._qt_installer,
        inputs = [],
        outputs = [ctx.outputs.bzl_out],
        arguments = args,
        progress_message = "Generating %s" % ctx.label.name,
        tools = [
            ctx.attr._qt_installer.default_runfiles.files,
        ],
        execution_requirements = {
            "requires-network": "1",
        },
    )

_qt_installer = rule(
    implementation = _qt_installer_impl,
    attrs = {
        "modules": attr.string_list(
            default = [],
            doc = "QT Modules to download using aqtinstaller's -m option",
        ),
        "os": attr.string(
            doc = "OS argument to pass to bqtinstaller to generate URLs and hashes for.",
        ),
        "target_sdk": attr.string(
            default = "desktop",
            doc = "sdk target argument to pass to bqtinstaller to generate URLs and hashes for.",
        ),
        "version": attr.string(
            doc = "QT Version argument to pass to bqtinstaller to generate URLs and hashes for.",
        ),
        "bzl_out": attr.output(
            doc = "Output .bzl file to generate URLs and Hashes to qt modules",
        ),
        "_qt_installer": attr.label(
            executable = True,
            cfg = "exec",
            default = Label("//bqtinstaller"),
        ),
    },
    doc = "Generates a .bzl file with a variable containing a dictionary of all qt modules, their urls, and their sha256.",
)

def qt_installer(name, os, target_sdk, version, bzl_out, modules = [], **kwargs):
    _qt_installer(
        name = name,
        os = os,
        target_sdk = target_sdk,
        version = version,
        bzl_out = bzl_out + ".tmp",
        modules = modules,
    )

    write_source_file(
        name = name + ".update",
        in_file = name,
        out_file = bzl_out,
    )