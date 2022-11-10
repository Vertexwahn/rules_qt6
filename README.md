
<!--
SPDX-FileCopyrightText: 2022 Julian Amann <dev@vertexwahn.de>
SPDX-License-Identifier: Apache-2.0
-->

[![Support Ukraine](https://img.shields.io/badge/Support-Ukraine-FFD500?style=flat&labelColor=005BBB)](https://opensource.fb.com/support-ukraine)

# Bazel rules for Qt6

## Goal 

The goal of these rules is to be able to build [Qt6](https://www.qt.io/product/qt6) applications using [Bazel](https://bazel.build/) on Windows, 
Linux and macOS without the need to preinstall Qt6. 
All the magic to set up Qt6 should be done by Bazel with as little effort as possible.

## Quick start

This project uses [Bazel](https://bazel.build/) as a build system. 
The current used version of Bazel is defined in [.bazelversion](tests/.bazelversion).

**Prerequisites:**

The following tools should be installed:
- [Git](https://git-scm.com/)
- [Bazel](https://bazel.build/install)
- A C++ compiler (GCC, Visual Studio, Clang, etc.)

**Checkout, build, and run:**

*All platforms:*

```shell
git clone https://github.com/Vertexwahn/rules_qt6
cd tests
```

*Run Hello World demo with Windows 10/11 x64 with Visual Studio 2019:*

```shell
bazel run --config=vs2019 //hello_world:hello_world
```

*Run Hello World demo with Windows 10/11 x64 with Visual Studio 2022:*

```shell
bazel run --config=vs2022 //hello_world:hello_world
```

*Run Hello World demo with Ubuntu 20.04:*

```shell
bazel run --config=gcc9 //hello_world:hello_world
```

*Run Hello World demo with Ubuntu 22.04:*

```shell
bazel run --config=gcc11 //hello_world:hello_world
```

*Run Hello World demo with macOS 11/12:*

```shell
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install qt@6 # Unfortunately a preinstalled version of Qt6 is still needed on macOS 
brew link qt@6
bazel run --config=macos //hello_world:hello_world
```

**Expected output**

The expected output should be similar (depending on your platform) to the following screenshots:

*Windows*

![Screenshot of HelloWorld demo on Windows 10](/docs/screenshots/hello_world_Windows11.png)

*Ubuntu*

![Screenshot of HelloWorld demo on Ubuntu 20.04](/docs/screenshots/hello_world_Ubuntu20.04.png)

*macOS*

![Screenshot of HelloWorld demo on macOS](/docs/screenshots/hello_world_macOS12.png)

## Current status

Currently, on macOS, these rules need a preinstalled version of Qt on the system (`brew install qt@6 && brew link qt@6`).
On Windows and Linux it should be possible to run `bazel run --config=[gcc9|gcc11|vs2019|vs2022] //hello_world:hello_world` without the need to preinstall Bazel.

These rules require at least Bazel 4.0.0 to work.
With some small modifications, you can get work these rules also on earlier versions of Bazel.

A prebuild version of Qt is fetched from [vertexwahn.de](https://vertexwahn.de/):

```starlark
def fetch_qt6():
    ### Qt 6.2.4

    http_archive(
        name = "qt_6.4.0_windows_desktop_win64_msvc2019_64",
        urls = ["https://vertexwahn.de/lfs/v1/qt_6.4.0_windows_desktop_win64_msvc2019_64.zip"],
        sha256 = "705684b672bc4305435f5a78c80399aef08f0120623b59c02f1298339c93fab4",
        strip_prefix = "6.2.4/msvc2019_64",
        build_file = "//:qt_6.4.0_windows_desktop_win64_msvc2019_64.BUILD",
    )

    http_archive(
        name = "qt_6.2.4_linux_desktop_gcc_64",
        urls = ["https://vertexwahn.de/lfs/v1/qt_6.2.4_linux_desktop_gcc_64.tar.xz"],
        sha256 = "334dfabef8d98cf6e61db304b1ff8e892c7ea7a02f0e238014203161498ef5b9",
        strip_prefix = "6.2.4/gcc_64",
        build_file = "//:qt_6.2.4_linux_desktop_gcc_64.BUILD",
    )
```

I created a [`.bazelrc`](tests/.bazelrc) file that contains a config for `vs2019`, `vs2022`, `gcc9`, `gcc11`, and ``macos`. 
This is needed since Qt6 needs at least C++17 standard enabled and different C++ compilers need different flags to enable this.

## Contributions

Any improvements to the Qt6 build experience using Bazel are welcome. 
Maybe you have solved this problem already. 
In this case, 
I would appreciate it if you could share your efforts under some permissive license.
If you name no specific license I assume you are fine with the current used license of this project (Apache 2.0 License).

## Similar projects

- [aabtop/rules_qt](https://github.com/aabtop/rules_qt)
- [bbreslauer/qt-bazel-example](https://github.com/bbreslauer/qt-bazel-example)
- [justbuchanan/bazel_rules_qt](https://github.com/justbuchanan/bazel_rules_qt)

## License

This work is published under Apache 2.0 License.

This work builds on top of [justbuchanan/bazel_rules_qt](https://github.com/justbuchanan/bazel_rules_qt) which is also licensed under Apache 2.0 and 
was forked from [bbreslauer/qt-bazel-example](https://github.com/bbreslauer/qt-bazel-example).
See here for details: https://github.com/justbuchanan/bazel_rules_qt/graphs/contributors

## Thanks to all contributors ❤

 <a href = "https://github.com/Vertexwahn/rules_qt6/graphs/contributors">
   <img src = "https://contrib.rocks/image?repo=Vertexwahn/rules_qt6"/>
 </a>
