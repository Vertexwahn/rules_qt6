"""Downloads QT using aqtinstall - Another Qt CLI Installer
https://github.com/miurahr/aqtinstall
Requires python to be installed.
"""

load("@bazel_skylib//lib:paths.bzl", "paths")

def _download_qt_impl(rctx):
    # First, download and install aqt
    aqt_result = rctx.execute([
        rctx.which("python"), "-m", "pip", "install", "aqtinstall==3.3.0"
    ])
    if aqt_result.return_code != 0:
        fail("Failed to install aqtinstall: {}".format(aqt_result.stderr))

    # Determine the Qt arch string for aqt
    arch = rctx.attr.windows_architecture if rctx.attr.windows_architecture else ""
    if not arch:
        if rctx.attr.os == "windows":
            arch = "win64_msvc2019_64"
        elif rctx.attr.os == "linux":
            arch = "gcc_64"
        elif rctx.attr.os == "mac":
            arch = "clang_64"

    # Use aqt to install Qt
    install_args = [
        rctx.which("python"), "-m", "aqt", "install-qt",
        "--outputdir", ".",
        rctx.attr.os,
        rctx.attr.target_sdk,
        rctx.attr.version,
        arch
    ]
    
    # Add modules if specified
    if rctx.attr.modules:
        install_args.extend(["-m"] + rctx.attr.modules)

    install_result = rctx.execute(install_args)
    if install_result.return_code != 0:
        fail("Failed to install Qt: {}".format(install_result.stderr))

    # Determine the installed Qt path based on OS and architecture
    if rctx.attr.os == "windows":
        # Extract the actual directory from the architecture (e.g., win64_msvc2022_64 -> msvc2022_64)
        arch_dir = arch.replace("win64_", "")
        qt_path = "{}/{}".format(rctx.attr.version, arch_dir)
    elif rctx.attr.os == "linux":
        qt_path = "{}/gcc_64".format(rctx.attr.version)
    elif rctx.attr.os == "mac":
        qt_path = "{}/macos".format(rctx.attr.version)
    else:
        fail("Unsupported OS: {}".format(rctx.attr.os))

    # Symlink the Qt directory contents to the repository root
    qt_dir = rctx.path(qt_path)
    if qt_dir.exists:
        for entry in qt_dir.readdir():
            rctx.symlink(entry, entry.basename)

    # Write out bazel workspace files
    rctx.file("WORKSPACE", content = "")
    rctx.file("MODULE.bazel", content = "module(name = \"{}\")".format(rctx.attr.name))

    # Write the qt_libraries definition file
    qt_library_defs = rctx.read(rctx.attr._qt_libraries)
    rctx.file(rctx.attr._qt_libraries.name, content = qt_library_defs)

    # Write the toplevel BUILD.bazel file, removing the @rules_qt since the libraries def is contained therein
    build_file_contents = rctx.read(rctx.attr.build_file)
    rctx.file("BUILD.bazel", content = build_file_contents.replace("@rules_qt", ""))

download_qt = repository_rule(
    implementation = _download_qt_impl,
    attrs = {
        "version": attr.string(default = "6.4.0"),
        "os": attr.string(default = "linux"),
        "target_sdk": attr.string(default = "desktop"),
        "windows_architecture": attr.string(default = ""),
        "modules": attr.string_list(default = []),
        "build_file": attr.label(default = "@rules_qt//:qt_linux_x86_64.BUILD"),
        "_qt_libraries": attr.label(default = "@rules_qt//:qt_libraries.bzl"),
    },
    environ = ["PATH", "PYTHONPATH"],
)