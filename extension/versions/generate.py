#!/usr/bin/env python3
#
#   SPDX-FileCopyrightText: Copyright 2026 Julian Amann <dev@vertexwahn.de>
#   SPDX-License-Identifier: Apache-2.0
#

"""Generates `extension/versions/<version>.bzl` for a Qt release.

The file lists the prebuilt Qt archives (path relative to the Qt online installer
repository and SHA-256) of every Qt module that rules_qt downloads, per OS.
Computing the SHA-256 downloads all archives (roughly 1-2 GB per Qt version).

Usage (Python 3.9+, no extra packages needed):

    python3 extension/versions/generate.py 6.12.1

Afterwards, add the new version to `extension/qt_versions.bzl`.
"""

import argparse
import concurrent.futures
import hashlib
import pathlib
import re
import sys
import time
import urllib.request

BASE_URL = "https://download.qt.io/online/qtsdkrepository/"

_ADDONS = [
    "qt3d",
    "qt5compat",
    "qtcharts",
    "qtconnectivity",
    "qtdatavis3d",
    "qtgraphs",
    "qtgrpc",
    "qthttpserver",
    "qtimageformats",
    "qtlanguageserver",
    "qtlocation",
    "qtlottie",
    "qtmultimedia",
    "qtnetworkauth",
    "qtpositioning",
    "qtquick3d",
    "qtquick3dphysics",
    "qtquickeffectmaker",
    "qtquicktimeline",
    "qtremoteobjects",
    "qtscxml",
    "qtsensors",
    "qtserialbus",
    "qtserialport",
    "qtshadertools",
    "qtspeech",
    "qtvirtualkeyboard",
    "qtwebchannel",
    "qtwebsockets",
    "qtwebview",
]

# "base" modules are archives of the main Qt package, "addons" have their own package
PLATFORMS = {
    "linux_aarch64": {
        "repository": "linux_arm64/desktop/",
        "arch": "linux_gcc_arm64",
        "base": ["icu", "qtbase", "qtdeclarative", "qtsvg"],
        "addons": _ADDONS + ["qtwaylandcompositor"],
    },
    "linux_x86_64": {
        "repository": "linux_x64/desktop/",
        "arch": "linux_gcc_64",
        "base": ["icu", "qtbase", "qtdeclarative", "qtsvg"],
        "addons": _ADDONS + ["qtwaylandcompositor"],
    },
    "macos": {
        "repository": "mac_x64/desktop/",
        "arch": "clang_64",
        "base": ["qtbase", "qtdeclarative", "qtsvg"],
        "addons": _ADDONS,
    },
    "windows": {
        "repository": "windows_x86/desktop/",
        "arch": "win64_msvc2022_64",
        "base": ["qtbase", "qtdeclarative", "qtsvg"],
        "addons": ["qt5compat"],
    },
}

# Archives whose name differs from the name of the Qt module
_ARCHIVE_NAMES = {"qtwaylandcompositor": "qtwayland-compositor"}


def _open(url, retries=4):
    for attempt in range(retries):
        try:
            return urllib.request.urlopen(url, timeout=120)
        except OSError as error:
            if attempt == retries - 1:
                raise RuntimeError("Failed to fetch {}: {}".format(url, error)) from error
            time.sleep(2**attempt)


def _list(url):
    """Returns the entries of a directory listing of download.qt.io."""
    with _open(url) as response:
        html = response.read().decode("utf-8")
    entries = re.findall(r'href="([^"?/][^"]*)"', html)
    return [entry for entry in entries if not entry.startswith("http")]


def _find_packages(platform, version):
    """Maps the package names of a Qt version (e.g. qt.qt6.6121.linux_gcc_64) to their URL."""
    info = PLATFORMS[platform]
    top = "{}{}qt6_{}/".format(BASE_URL, info["repository"], version.replace(".", ""))
    packages = {}
    for directory in _list(top):
        if not directory.endswith("/"):
            continue
        for package in _list(top + directory):
            if package.endswith("." + info["arch"] + "/"):
                packages[package.rstrip("/")] = top + directory + package
    if not packages:
        raise RuntimeError("No Qt {} packages found for {} at {}".format(version, platform, top))
    return packages


def _find_archive(packages, package, module):
    if package not in packages:
        raise RuntimeError("Package {} does not exist".format(package))
    archive_name = _ARCHIVE_NAMES.get(module, module)
    pattern = re.compile(r"^\d+\.\d+\.\d+-\d+-\d+{}-.*\.7z$".format(re.escape(archive_name)))
    matches = [archive for archive in _list(packages[package]) if pattern.match(archive)]
    if len(matches) != 1:
        raise RuntimeError("Expected one {} archive in {}, found: {}".format(module, packages[package], matches))
    return packages[package] + matches[0]


def _sha256(url):
    for attempt in range(4):
        try:
            digest = hashlib.sha256()
            with _open(url) as response:
                for chunk in iter(lambda: response.read(1 << 20), b""):
                    digest.update(chunk)
            return digest.hexdigest()
        except (OSError, RuntimeError):
            if attempt == 3:
                raise
            time.sleep(2**attempt)


def collect(version, platforms, jobs):
    """Returns {platform: {module: (path, sha256)}} of the Qt archives of `version`."""
    urls = {}
    for platform in platforms:
        info = PLATFORMS[platform]
        print("Listing Qt {} packages for {}...".format(version, platform), file=sys.stderr)
        packages = _find_packages(platform, version)
        prefix = "qt.qt6.{}.".format(version.replace(".", ""))
        for module in info["base"]:
            urls[(platform, module)] = _find_archive(packages, prefix + info["arch"], module)
        for module in info["addons"]:
            package = "{}addons.{}.{}".format(prefix, module, info["arch"])
            urls[(platform, module)] = _find_archive(packages, package, module)

    print("Computing SHA-256 of {} archives...".format(len(urls)), file=sys.stderr)
    with concurrent.futures.ThreadPoolExecutor(max_workers=jobs) as executor:
        hashes = dict(zip(urls, executor.map(_sha256, urls.values())))

    archives = {platform: {} for platform in platforms}
    for (platform, module), url in urls.items():
        archives[platform][module] = (url[len(BASE_URL):], hashes[(platform, module)])
    return archives


def render(version, archives):
    """Returns the content of `<version>.bzl`."""
    lines = [
        '"""Prebuilt Qt {0} archives (generated by `python3 extension/versions/generate.py {0}`)."""'.format(version),
        "",
        "QT = {",
    ]
    for platform in sorted(archives):
        lines.append('    "{}": {{'.format(platform))
        for module, (path, sha256) in sorted(archives[platform].items()):
            lines.append('        "{}": {{'.format(module))
            lines.append('            "path": "{}",'.format(path))
            lines.append('            "sha256": "{}",'.format(sha256))
            lines.append("        },")
        lines.append("    },")
    lines.append("}")
    return "\n".join(lines) + "\n"


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("version", help="Qt version, e.g. 6.12.1")
    parser.add_argument("--jobs", type=int, default=8, help="number of parallel downloads")
    args = parser.parse_args()
    if not re.fullmatch(r"6\.\d+\.\d+", args.version):
        parser.error("expected a Qt 6 version like 6.12.1")

    output = pathlib.Path(__file__).resolve().parent / "{}.bzl".format(args.version)
    archives = collect(args.version, PLATFORMS, args.jobs)
    output.write_text(render(args.version, archives), encoding="utf-8", newline="\n")
    print("Wrote {}".format(output), file=sys.stderr)


if __name__ == "__main__":
    main()
