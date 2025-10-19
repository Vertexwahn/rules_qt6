"""Repository rule helpers for fetching Qt archives via aqt."""

load("@bazel_skylib//lib:paths.bzl", "paths")

# The qt_modules.bzl file is auto-generated based on the qt_modules() def in
# the root BUILD.bazel file.
load("//extension:qt_modules.bzl", "QT_MODULES")

# Qt 6.4.0 and earlier use these paths
_PATHS_6_4_0 = {
    "mac": "macos",
    "macos": "macos",
    "linux": "gcc_64",
    "win64_mingw": "mingw_64",
    "win64_msvc2022": "msvc2022_64",
}

# Qt 6.8.3 and later use these paths
_PATHS_6_8_3 = {
    "mac": "macos",
    "macos": "macos",
    "linux": "linux_gcc_64",
    "win64_mingw": "mingw_64",
    "win64_msvc2022": "win64_msvc2022_64",
}

def _get_paths_for_version(version):
    """Returns the appropriate paths dictionary for the given Qt version."""

    # Parse version to compare
    version_parts = version.split(".")
    major = int(version_parts[0])
    minor = int(version_parts[1])

    # Qt 6.8.3 and later use different paths
    if major > 6 or (major == 6 and minor >= 8):
        return _PATHS_6_8_3
    return _PATHS_6_4_0

def _download_qt_impl(rctx):
    if rctx.os.name.startswith("windows"):
        # On Windows, download 7zr.exe standalone executable from the internet
        # Normalize Windows OS name (e.g., "windows 11" -> "windows")
        normalized_os = "windows"
        host_platform = "{}-{}".format(normalized_os, rctx.os.arch)
        _url = rctx.attr.url_7z[host_platform]
        _sha = rctx.attr.sha256_7z[host_platform]
        rctx.download(
            url = _url,
            sha256 = _sha,
            output = "archiver_7z/7zr.exe",
        )
        archiver_bin = rctx.path("archiver_7z/7zr.exe")
    elif rctx.os.name.startswith("mac"):
        # On macOS, try to use system 7zz first
        result = rctx.execute(["which", "7zz"])
        if result.return_code == 0:
            archiver_bin = rctx.path(result.stdout.strip())
        else:
            # Fallback: download 7z
            host_platform = "{}-{}".format(rctx.os.name, rctx.os.arch)
            _url = rctx.attr.url_7z[host_platform]
            _sha = rctx.attr.sha256_7z[host_platform]
            rctx.download_and_extract(
                url = _url,
                sha256 = _sha,
                output = "archiver_7z",
            )
            archiver_bin = rctx.path("archiver_7z/7zz")
    else:
        # On Linux, download and extract 7z
        host_platform = "{}-{}".format(rctx.os.name, rctx.os.arch)
        _url = rctx.attr.url_7z[host_platform]
        _sha = rctx.attr.sha256_7z[host_platform]
        rctx.download_and_extract(
            url = _url,
            sha256 = _sha,
            output = "archiver_7z",
        )
        archiver_bin = rctx.path("archiver_7z/7zz")

    # Get modules for the specified version and platform
    version = rctx.attr.version
    platform = rctx.attr.os
    
    if platform not in QT_MODULES:
        fail("Platform {} not found in QT_MODULES. Available platforms: {}".format(
            platform,
            ", ".join(QT_MODULES.keys()),
        ))
    
    if version not in QT_MODULES[platform]:
        available_versions = list(QT_MODULES[platform].keys())
        fail("Qt version {} not found for platform {}. Available versions: {}".format(
            version,
            platform,
            ", ".join(available_versions),
        ))

    version_modules = QT_MODULES[platform][version]

    # We have to write our own download_and_extract() because the one in ctx
    # doesn't support 7z decompress & that's what qt modules are downloaded as.
    for _qt_module, download_info in version_modules.items():
        res = rctx.download(
            url = download_info["url"],
            sha256 = download_info["sha256"],
            output = "archives/{}".format(paths.basename(download_info["url"])),
        )
        if not res.success:
            fail("Failed to download:\n{}\n{}".format(download_info["url"], res.stderr))

        archive = paths.basename(download_info["url"])
        if rctx.os.name.startswith("windows"):
            arguments = [archiver_bin.realpath, "x"]
        else:
            arguments = [archiver_bin.realpath, "x"]
        arguments += ["archives/{}".format(archive), "-o{}".format(".")]
        res = rctx.execute(arguments)
        if res.return_code != 0:
            fail("Failed to decompress archive:\n{}\n{}".format(" ".join([str(arg) for arg in arguments]), res.stderr))

    path_lookup = rctx.attr.os
    if rctx.attr.os == "windows":
        path_lookup = rctx.attr.windows_architecture

    # Get the appropriate paths for this Qt version
    _PATHS = _get_paths_for_version(rctx.attr.version)

    # Qt 6.4.0 extracts to version/platform subdirectories (e.g., 6.4.0/gcc_64)
    # Qt 6.8.3+ extracts directly to the root directory
    # Try the versioned path first, fall back to root if it doesn't exist
    base_path = "{}/{}".format(rctx.attr.version, _PATHS[path_lookup])

    if not rctx.path(base_path).exists:
        # Qt 6.8.3+ style: files are in the root
        base_path = "."

    if base_path == ".":
        # For flat structure, symlink all top-level directories
        for entry in rctx.path(".").readdir():
            # Skip special files and the archives directory
            if entry.basename not in ["WORKSPACE", "MODULE.bazel", "archives", "archiver_7z"]:
                if not rctx.path(entry.basename).exists:
                    rctx.symlink(entry, entry.basename)
    else:
        # For versioned structure, symlink from the version subdirectory
        for entry in rctx.path(base_path).readdir():
            rctx.symlink(entry, entry.basename)

    # Ensure ICU libraries are available under the lib directory for runtime lookup
    lib_dir = rctx.path("lib")
    if lib_dir.exists:
        for entry in rctx.path(".").readdir():
            if not entry.basename.startswith("libicu"):
                continue
            dest = lib_dir.get_child(entry.basename)
            if not dest.exists:
                rctx.symlink(entry, "lib/{}".format(entry.basename))

    # Write out bazel workspace files
    rctx.file("WORKSPACE", content = "")
    rctx.file("MODULE.bazel", content = "module(name = {})".format(rctx.attr.name))

    # Write the qt_libraries definition file from the same directory as the build_file
    build_file_dir = "/".join(str(rctx.attr.build_file).split("/")[:-1])
    qt_libraries_path = build_file_dir + "/qt_libraries.bzl"
    qt_library_defs = rctx.read(Label(qt_libraries_path))
    rctx.file("qt_libraries.bzl", content = qt_library_defs)

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
        "build_file": attr.label(default = "@rules_qt//:qt_linux_x86_64.BUILD"),
        "url_7z": attr.string_dict(default = {
            "linux-amd64": "https://github.com/ip7z/7zip/releases/download/23.01/7z2301-linux-x64.tar.xz",
            "linux-aarch64": "https://github.com/ip7z/7zip/releases/download/23.01/7z2301-linux-arm64.tar.xz",
            "mac os x-aarch64": "https://github.com/ip7z/7zip/releases/download/23.01/7z2301-mac.tar.xz",
            "mac os x-x86_64": "https://github.com/ip7z/7zip/releases/download/23.01/7z2301-mac.tar.xz",
            "windows-amd64": "https://github.com/ip7z/7zip/releases/download/23.01/7zr.exe",
            "windows-x86_64": "https://github.com/ip7z/7zip/releases/download/23.01/7zr.exe",
        }),
        "sha256_7z": attr.string_dict(default = {
            "linux-amd64": "23babcab045b78016e443f862363e4ab63c77d75bc715c0b3463f6134cbcf318",
            "linux-aarch64": "34e938fc4ba8ca6a835239733d9c1542ad8442cc037f43ca143a119bdf322b63",
            "mac os x-aarch64": "343eae9ccbbd8f68320adaaa3c87e0244cf39fad0fbec6b9d2cd3e5b0f8a5fbf",
            "mac os x-x86_64": "343eae9ccbbd8f68320adaaa3c87e0244cf39fad0fbec6b9d2cd3e5b0f8a5fbf",
            "windows-amd64": "72c98287b2e8f85ea7bb87834b6ce1ce7ce7f41a8c97a81b307d4d4bf900922b",
            "windows-x86_64": "72c98287b2e8f85ea7bb87834b6ce1ce7ce7f41a8c97a81b307d4d4bf900922b",
        }),
        "_qt_libraries": attr.label(default = None, allow_single_file = True),
    },
)
