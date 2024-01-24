"""
Downloads QT using aqtinstall - Another Qt CLI Installer

https://github.com/miurahr/aqtinstall

Requires python to be installed.
"""

_MODULE_CONTENTS = """
module(
    name = "{}",
)

bazel_dep("rules_qt", v
"""

_PATHS = {
  "mac": "macos",
  "linux": "gcc_64",
  "win64_mingw": "mingw_64",
}

def _download_qt_impl(rctx):
    # Use python and aqtinstall to download the appropriate qt6 binaries

    #TODO: use rules_python's toolchain instead of system python3
    python3 = rctx.which("python3")
    if not python3:
        fail("Could not find python3 on system - please make sure you've installed python3 and has been added to PATH environment variable")

    if rctx.attr.type == "windows" and rctx.attr.windows_architecture == "":
        fail("When using windows as a download type, you need to provide a windows architecture to use")

    # Write the Requirements Lock file
    # TODO: We might be able to just point to it, instead of reading and writing
    requirements_lock = rctx.read(rctx.attr.requirements_txt)
    rctx.file(rctx.attr.requirements_txt.name, content = requirements_lock)

    # Install aqtinstall via pip
    # TODO: Install this to the sandbox directory instead of system
    package_path = "." if not rctx.attr.requirements_txt.package else rctx.attr.requirements_txt.package
    rctx.report_progress("Installing pip requirements for aqtinstall")
    arguments = [python3.realpath, "-m", "pip", "install", "--target", "pip", "-r", "{}/{}".format(package_path, rctx.attr.requirements_txt.name)]
    res = rctx.execute(arguments)
    if res.return_code != 0:
        fail("Failed to install pip aqtinstall:\n{}\n{}".format(" ".join([str(arg) for arg in arguments]), res.stderr))

    # Download the qt binaries to this directory
    rctx.report_progress("Downloading prebuilt QT libraries with aqt")
    qt_modules = [module.lower() for module in rctx.attr.qt_modules]
    arguments = [python3.realpath, "-m", "aqt", "install-qt", "-O", ".", rctx.attr.os, rctx.attr.type, rctx.attr.version, rctx.attr.windows_architecture, "-m", " ".join(qt_modules)]
    res = rctx.execute(arguments, environment = {"PYTHONPATH": "pip"})
    if res.return_code != 0:
        fail("Failed to download QT libraries:\n{}\n{}".format(" ".join([str(arg) for arg in arguments]), res.stderr))

    path_lookup = rctx.attr.os
    if rctx.attr.os == "windows":
        path_lookup = rctx.attr.windows_architecture

    # The downloaded files end up under 6.4.0/gcc_64 for linux, but the second
    # directory is different per OS. Symlink the relevant directory 
    # for usage in this repository.
    base_path = "{}/{}".format(rctx.attr.version, _PATHS[path_lookup])
    for entry in rctx.path(base_path).readdir():
        rctx.symlink(entry, entry.basename)

    # Write out bazel workspace files
    rctx.file("WORKSPACE", content = "")
    rctx.file("MODULE.bazel", content = "module(name = {})".format(rctx.attr.name))

    # Write the qt_libraries definition file. 
    qt_library_defs = rctx.read(rctx.attr._qt_libraries)
    rctx.file(rctx.attr._qt_libraries.name, content = qt_library_defs)

    # Write the toplevel BUILD.bazel file, removing the @rules_qt since the libraries def is contained therein
    build_file_contents = rctx.read(rctx.attr.build_file)
    rctx.file("BUILD.bazel", content = build_file_contents.replace("@rules_qt", ""))

download_qt = repository_rule(
    implementation=_download_qt_impl,
    attrs={
        "version": attr.string(default = "6.4.0"),
        "os": attr.string(default = "linux"), 
        "type": attr.string(default = "desktop"),
        "qt_modules": attr.string_list(default = ["all"]),
        "windows_architecture": attr.string(default = ""),
        "build_file": attr.label(default = "@rules_qt//:qt_linux_x86_64.BUILD"),
        "requirements_txt": attr.label(default = "@rules_qt//:requirements_lock.txt"),
        "_aqt": attr.label(default="//:aqt"),
        "_qt_libraries": attr.label(default = "@rules_qt//:qt_libraries.bzl"),
    }
)
