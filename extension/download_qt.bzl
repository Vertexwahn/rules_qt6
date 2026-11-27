"""Repository rule that downloads and extracts a prebuilt Qt from the Qt online installer repository."""

load("//extension:qt_versions.bzl", "QT_VERSIONS")

# Mirrors of the Qt online installer repository (tried in order)
QT_BASE_URLS = ["https://download.qt.io/online/qtsdkrepository/"]

# The Qt archives are 7z archives - 7-Zip is used to extract them (https://github.com/ip7z/7zip/releases)
_7ZIP = {
    "linux_aarch64": ("https://github.com/ip7z/7zip/releases/download/26.06/7z2606-linux-arm64.tar.xz", "edcc408aacce77da5223728f2eceb5e9f6dc713b8a9df934ad21e2a7f7560627"),
    "linux_x86_64": ("https://github.com/ip7z/7zip/releases/download/26.06/7z2606-linux-x64.tar.xz", "2b539cf067b2ad48e1baa5093dbaa8818b73542d1222a0ffde9dc5f2922ea62e"),
    # Newest universal (arm64 and x86_64) build - the macOS build of 26.06 is arm64 only
    "macos": ("https://github.com/ip7z/7zip/releases/download/26.05/7z2605-mac.tar.xz", "12ef6830317743cfd3f0ab1724bde43fcc270d8b6d8564f8c12c2a2b7f993570"),
    "windows": ("https://github.com/ip7z/7zip/releases/download/26.06/7zr.exe", "e80db2dad715a6c5adabe292d31ed54e11f4e9b99ca349827b50573b175891bc"),
}

def _7zip(rctx):
    """Downloads 7-Zip for the host and returns the path of its executable."""
    host = rctx.os.name.lower()
    if host.startswith("windows"):
        key = "windows"
    elif host.startswith("mac"):
        key = "macos"
    elif rctx.os.arch in ("aarch64", "arm64"):
        key = "linux_aarch64"
    else:
        key = "linux_x86_64"

    url, sha256 = _7ZIP[key]
    if url.endswith(".exe"):
        rctx.download(url = url, sha256 = sha256, output = "_7zip/7zr.exe", executable = True)
        return rctx.path("_7zip/7zr.exe")
    rctx.download_and_extract(url = url, sha256 = sha256, output = "_7zip")
    return rctx.path("_7zip/7zz")

_QT_LIBRARIES = Label("//extension/qt:qt_libraries.bzl")

# rules_qt needs a target for each of its libraries - entries of a custom qt_libraries.bzl take precedence
_MERGED_QT_LIBRARIES = """\
load(":qt_libraries_custom.bzl", _CUSTOM = "QT_LIBRARIES")
load("@rules_qt//extension/qt:qt_libraries.bzl", _BUILT_IN = "QT_LIBRARIES")

_CUSTOM_NAMES = [library[0] for library in _CUSTOM]

QT_LIBRARIES = _CUSTOM + [library for library in _BUILT_IN if library[0] not in _CUSTOM_NAMES]
"""

def _adapt_custom_build_file(rctx, content):
    """Keeps BUILD files that are not provided by rules_qt (e.g. written for rules_qt 0.0.7) working."""
    build_file = rctx.attr.build_file

    # rules_qt 0.0.7 copied the qt_libraries.bzl next to the BUILD file into the repository, which the BUILD
    # file loads as `:qt_libraries.bzl` or `@rules_qt//:qt_libraries.bzl`
    directory = build_file.name.rpartition("/")[0]
    sibling = rctx.path(build_file.same_package_label(directory + "/qt_libraries.bzl" if directory else "qt_libraries.bzl"))
    if sibling.exists:
        rctx.file("qt_libraries_custom.bzl", rctx.read(sibling))
        rctx.file("qt_libraries.bzl", _MERGED_QT_LIBRARIES)
    else:
        rctx.file("qt_libraries.bzl", "load(\"{}\", _QT_LIBRARIES = \"QT_LIBRARIES\")\n\nQT_LIBRARIES = _QT_LIBRARIES\n".format(_QT_LIBRARIES))
    content = content.replace("@rules_qt//:qt_libraries.bzl", "//:qt_libraries.bzl")

    # qt_cc_binary and qt_cc_test depend on :qt_runtime on Windows
    if rctx.attr.platform == "windows" and "\"qt_runtime\"" not in content:
        content = "\n".join([
            "load(\"@rules_cc//cc:cc_library.bzl\", _rules_qt_cc_library = \"cc_library\")",
            content,
            "_rules_qt_cc_library(name = \"qt_runtime\", visibility = [\"//visibility:public\"])",
            "",
        ])
    return content

def _download_qt_impl(rctx):
    version = rctx.attr.version
    if version not in QT_VERSIONS:
        fail("Qt {} is not supported. Supported versions: {}".format(version, ", ".join(QT_VERSIONS.keys())))
    if rctx.attr.platform not in QT_VERSIONS[version]:
        fail("Qt {} is not available for {}".format(version, rctx.attr.platform))
    archives = QT_VERSIONS[version][rctx.attr.platform]

    # Start all downloads at once - they run in parallel
    downloads = []
    for module, archive in sorted(archives.items()):
        output = "_archives/{}.7z".format(module)
        downloads.append((output, rctx.download(
            url = [base_url + archive["path"] for base_url in rctx.attr.base_urls],
            sha256 = archive["sha256"],
            output = output,
            block = False,
        )))

    seven_zip = _7zip(rctx)
    for output, download in downloads:
        download.wait()

        # Since 7-Zip 25.01, symbolic links that point to other links (e.g. libQt6Core.so -> libQt6Core.so.6 ->
        # libQt6Core.so.6.12.1) are not extracted by default - -snld20 allows them (the archives are verified by SHA-256)
        result = rctx.execute([seven_zip, "x", "-y", "-bd", "-snld20", output])
        if result.return_code != 0:
            fail("Failed to extract {}:\n{}\n{}".format(output, result.stdout, result.stderr))
        rctx.delete(output)
    rctx.delete("_archives")
    rctx.delete("_7zip")

    # Ensure ICU libraries are available under the lib directory for runtime lookup
    lib_dir = rctx.path("lib")
    if lib_dir.exists:
        for entry in rctx.path(".").readdir():
            if entry.basename.startswith("libicu") and not lib_dir.get_child(entry.basename).exists:
                rctx.symlink(entry, "lib/" + entry.basename)

    rctx.file("REPO.bazel", "")
    rctx.file("qt_version.bzl", "QT_VERSION = \"{}\"\n".format(version))
    content = rctx.read(rctx.attr.build_file)
    if rctx.attr.build_file.repo_name != _QT_LIBRARIES.repo_name:
        content = _adapt_custom_build_file(rctx, content)
    rctx.file("BUILD.bazel", content)

    # Mark the repository as reproducible so Bazel does not re-check file
    # modification timestamps between builds.  Without this, running the Qt app
    # via `bazel run` causes Windows to update NTFS metadata on plugin DLLs,
    # which Bazel incorrectly interprets as external modifications and triggers
    # a full re-download on the next build.
    if hasattr(rctx, "repo_metadata"):  # Bazel 8.3+
        return rctx.repo_metadata(reproducible = True)
    return None

download_qt = repository_rule(
    implementation = _download_qt_impl,
    doc = "Downloads the archives of a prebuilt Qt (see `extension/qt_versions.bzl`) and extracts them.",
    attrs = {
        "base_urls": attr.string_list(
            default = QT_BASE_URLS,
            doc = "Mirrors of the Qt online installer repository.",
        ),
        "build_file": attr.label(
            mandatory = True,
            doc = "BUILD file of the repository.",
        ),
        "platform": attr.string(
            mandatory = True,
            values = ["linux_aarch64", "linux_x86_64", "macos", "windows"],
            doc = "Platform of the prebuilt Qt.",
        ),
        "version": attr.string(
            mandatory = True,
            doc = "Qt version, e.g. 6.12.1.",
        ),
    },
)
