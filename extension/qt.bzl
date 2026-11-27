"""Module extension that provides a prebuilt Qt for Linux, macOS and Windows.

Usage in `MODULE.bazel`:

    qt = use_extension("@rules_qt//extension:qt.bzl", "fetch")
    qt.install(version = "6.12.1")  # Optional - defaults to the newest supported LTS release

Qt is only downloaded for the platforms a build needs. If you reference the Qt repositories
directly (e.g. `@qt_linux_x86_64//:plugins`), add them via `use_repo(qt, ...)`.
"""

load("//extension:download_qt.bzl", "QT_BASE_URLS", "download_qt")
load("//extension:qt_versions.bzl", "DEFAULT_QT_VERSION", "QT_VERSIONS")

# Repositories that are always created and the platform of their prebuilt Qt
_REPOSITORIES = {
    "qt_linux_aarch64": "linux_aarch64",
    "qt_linux_x86_64": "linux_x86_64",
    "qt_mac_aarch64": "macos",  # Qt for macOS consists of universal binaries (arm64 and x86_64)
    "qt_mac_x86_64": "macos",
    "qt_windows_x86_64": "windows",
}

_BUILD_FILES = {
    "linux_aarch64": Label("//extension/qt:linux.BUILD"),
    "linux_x86_64": Label("//extension/qt:linux.BUILD"),
    "macos": Label("//extension/qt:macos.BUILD"),
    "windows": Label("//extension/qt:windows.BUILD"),
}

# Older values of `os`
_OS_ALIASES = {"linux": "linux_x86_64"}

def _repository(platform, version = "", build_file = None, base_urls = []):
    version = version or DEFAULT_QT_VERSION
    if version not in QT_VERSIONS:
        fail("Qt {} is not supported by rules_qt. Supported versions: {}".format(
            version,
            ", ".join(QT_VERSIONS.keys()),
        ))

    # rules_qt used to provide one BUILD file per Qt version and platform, e.g.
    # @rules_qt//extension:qt/6.8.3/linux_x86_64.BUILD - those are replaced by the built-in ones
    if build_file == None or build_file.repo_name == _BUILD_FILES[platform].repo_name:
        build_file = _BUILD_FILES[platform]
    return struct(
        platform = platform,
        version = version,
        build_file = build_file,
        base_urls = base_urls or QT_BASE_URLS,
    )

def _repositories_of_tag(tag):
    """Returns {repository name: platform} of the repositories configured by `tag`."""
    platform = _OS_ALIASES.get(tag.os, tag.os)
    if tag.name:
        # rules_qt 0.0.7 defaulted to os = "linux"
        platform = platform or _REPOSITORIES.get(tag.name, "linux_x86_64")
        if tag.name in _REPOSITORIES and _REPOSITORIES[tag.name] != platform:
            fail("qt.install: repository '{}' is for os = \"{}\"".format(tag.name, _REPOSITORIES[tag.name]))
        return {tag.name: platform}
    if tag.build_file and not platform:
        fail("qt.install: `build_file` requires `os` to be set")
    return {name: p for name, p in _REPOSITORIES.items() if not platform or p == platform}

def _specificity(tag):
    """Tags with `name` are more specific than tags with only `os`, which are more specific than tags without both."""
    if tag.name:
        return 2
    if tag.os:
        return 1
    return 0

def _fetch_impl(mctx):
    repositories = {}

    # The root module comes first and takes precedence over other modules
    for mod in mctx.modules:
        configured = {}  # repository name -> specificity of the tag that configured it

        # More specific tags take precedence over less specific tags of the same module
        for tag in sorted(mod.tags.install, key = lambda tag: -_specificity(tag)):
            specificity = _specificity(tag)
            for name, platform in _repositories_of_tag(tag).items():
                if name in configured:
                    if configured[name] == specificity:
                        fail("qt.install: Qt repository '{}' is configured more than once by {}".format(
                            name,
                            "the root module" if mod.is_root else "module '{}'".format(mod.name),
                        ))
                    continue
                configured[name] = specificity
                if name not in repositories:
                    repositories[name] = _repository(platform, tag.version, tag.build_file, tag.base_urls)

    for name, platform in _REPOSITORIES.items():
        if name not in repositories:
            repositories[name] = _repository(platform)

    for name, repository in repositories.items():
        download_qt(
            name = name,
            platform = repository.platform,
            version = repository.version,
            build_file = repository.build_file,
            base_urls = repository.base_urls,
        )

    return mctx.extension_metadata(reproducible = True)

_install = tag_class(
    doc = "Selects the Qt version. Without `os`, it applies to all platforms.",
    attrs = {
        "base_urls": attr.string_list(
            doc = "Mirrors of https://download.qt.io/online/qtsdkrepository/ to download Qt from (tried in order).",
        ),
        "build_file": attr.label(
            doc = "Custom BUILD file for the Qt repository (requires `os`). Defaults to the BUILD file provided by rules_qt.",
        ),
        "name": attr.string(
            doc = "Name of the Qt repository. Only needed to create an additional repository - " +
                  "rules_qt always creates " + ", ".join(_REPOSITORIES.keys()) + ". " +
                  "Without `os`, the platform of the repository with this name is used (default: linux_x86_64).",
        ),
        "os": attr.string(
            doc = "Only configure Qt for this platform (`linux` is the same as `linux_x86_64`).",
            values = ["", "linux", "linux_aarch64", "linux_x86_64", "macos", "windows"],
        ),
        "target_sdk": attr.string(
            doc = "Deprecated - only `desktop` is supported.",
            values = ["", "desktop"],
        ),
        "version": attr.string(
            doc = "Qt version. Defaults to " + DEFAULT_QT_VERSION + ". Supported: " + ", ".join(QT_VERSIONS.keys()),
        ),
        "windows_architecture": attr.string(
            doc = "Deprecated - only `win64_msvc2022` (MSVC 2022, x86_64) is supported.",
            values = ["", "win64_msvc2022"],
        ),
    },
)

fetch = module_extension(
    implementation = _fetch_impl,
    doc = "Downloads a prebuilt Qt. Creates the repositories " + ", ".join(_REPOSITORIES.keys()) + ".",
    tag_classes = {"install": _install},
)
