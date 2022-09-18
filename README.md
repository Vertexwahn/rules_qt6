
<!--
SPDX-FileCopyrightText: 2022 Julian Amann <dev@vertexwahn.de>
SPDX-License-Identifier: Apache-2.0
-->

[![Support Ukraine](https://img.shields.io/badge/Support-Ukraine-FFD500?style=flat&labelColor=005BBB)](https://opensource.fb.com/support-ukraine)

# Bazel rules for Qt6

## Goal 

The goal of these rules is to be able to build Qt6 applications using [Bazel](https://bazel.build/) on Windows, 
Linux and macOS without the need to preinstall Qt6. 
All the magic to set up Qt6 should be done by Bazel with as little effort as possible.

## Current status

Currently, on macOS, these rules need a preinstalled version of Qt on the system (`brew install qt@6 && brew link qt@6`).

On Windows and Linux it should be possible to run `bazel run --config=gcc9 //:Qt6HelloWorld` without the need to preinstall Bazel.

For more advanced uses of Qt (e.g. using `uic`) these rule do currently not work.
These rules require at least Bazel 4.0.0 to work.
With some small modifications, you can get work these rules also on earlier versions of Bazel.

This project is just a testbed for Qt6 with Bazel 5.1.0 and is still experimental.

A prebuild version of Qt is fetched from [vertexwahn.de](https://vertexwahn.de/):

    def fetch_qt6():
        ### Qt 6.2.4

        http_archive(
            name = "qt_6.2.4_windows_desktop_win64_msvc2019_64",
            urls = ["https://vertexwahn.de/lfs/v1/qt_6.2.4_windows_desktop_win64_msvc2019_64.zip"],
            sha256 = "705684b672bc4305435f5a78c80399aef08f0120623b59c02f1298339c93fab4",
            strip_prefix = "6.2.4/msvc2019_64",
            build_file = "//:qt_6.2.4_windows_desktop_win64_msvc2019_64.BUILD",
        )

        http_archive(
            name = "qt_6.2.4_linux_desktop_gcc_64",
            urls = ["https://vertexwahn.de/lfs/v1/qt_6.2.4_linux_desktop_gcc_64.tar.xz"],
            sha256 = "334dfabef8d98cf6e61db304b1ff8e892c7ea7a02f0e238014203161498ef5b9",
            strip_prefix = "6.2.4/gcc_64",
            build_file = "//:qt_6.2.4_linux_desktop_gcc_64.BUILD",
        )

I created a `.bazelrc` file that contains a config for `gcc9`, `vs2019`, and ``vs2022`. This is needed since Qt6 needs at least C++17 standard enabled.
For more details have a look at [.bazelrc](bazelrc).

### Working with Linux using GCC9

    bazel run --config=gcc9 //:Qt6HelloWorld

![Screenshot of HelloWorld demo on Ubuntu 20.04](/docs/screenshots/Ubuntu20.04.png)

### Working with Windows using Visual Studio 2019

Run Qt6HelloWorld

    bazel run --config=vs2019 //:Qt6HelloWorld

Should display the following window:

![Screenshot of HelloWorld demo on Windows 10](/docs/screenshots/Windows10.png)

### macOS

    bazel run --config=macos //:Qt6HelloWorld

![Screenshot of HelloWorld demo on macOS](/docs/screenshots/macOS12.png)
## Contributions

Any improvements to the Qt6 build experience using Bazel are welcome. 
Maybe you have solved this problem already. 
In this case, 
I would appreciate it if you could share your efforts under some permissive license.

## Similar projects

- [aabtop/rules_qt](https://github.com/aabtop/rules_qt)
- [bbreslauer/qt-bazel-example](https://github.com/bbreslauer/qt-bazel-example)
- [justbuchanan/bazel_rules_qt](https://github.com/justbuchanan/bazel_rules_qt)

## License

This work is published under Apache 2.0 License.

This work builds on top of https://github.com/justbuchanan/bazel_rules_qt which is also licensed under Apache 2.0.
See here for details: https://github.com/justbuchanan/bazel_rules_qt/graphs/contributors

## Thanks to all contributors ❤

 <a href = "https://github.com/Vertexwahn/rules_qt6/graphs/contributors">
   <img src = "https://contrib.rocks/image?repo=Vertexwahn/rules_qt6"/>
 </a>
