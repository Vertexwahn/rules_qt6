
<!--
SPDX-FileCopyrightText: 2022-2025 Julian Amann <dev@vertexwahn.de>
SPDX-License-Identifier: Apache-2.0
-->


[![Support Ukraine](https://img.shields.io/badge/Support-Ukraine-FFD500?style=flat&labelColor=005BBB)](https://opensource.fb.com/support-ukraine) [<img src="docs/logo/bazel_logo.svg" alt="Bazel logo" width="24" height="24" />](https://bazel.build/) [<img src="docs/logo/qt-svgrepo-com.svg" alt="Qt logo" width="24" height="24" />](https://www.qt.io/product/qt6)

# Bazel rules for Qt6


## Goal 

The goal of these rules is to be able to build [Qt6](https://www.qt.io/product/qt6) applications using [Bazel](https://bazel.build/) on **Linux**, **macOS** and **Windows** without the need to preinstall Qt6. 
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
cd rules_qt6/tests
```

*Run Hello World demo with Windows 10/11 x64 with Visual Studio 2019:*

```shell
bazel run --config=vs2019 //hello_world:hello_world
```

*Run Hello World demo with Windows 10/11 x64 with Visual Studio 2022:*

```shell
bazel run --config=vs2022 //hello_world:hello_world
```

*Run Hello World demo with Ubuntu 22.04:*

```shell
bazel run --config=gcc11 //hello_world:hello_world
```

*Run Hello World demo with Ubuntu 24.04:*

```shell
bazel run --config=gcc13 //hello_world:hello_world
```

*Run Hello World demo with macOS:*

```shell
bazel run --config=macos //hello_world:hello_world
```

**Expected output**

The expected output should be similar (depending on your platform) to the following screenshots:

*Windows*

![Screenshot of HelloWorld demo on Windows 11](/docs/screenshots/hello_world_Windows11.png)

*Ubuntu*

![Screenshot of HelloWorld demo on Ubuntu 22.04](/docs/screenshots/hello_world_Ubuntu22.04.png)

*macOS*

![Screenshot of HelloWorld demo on macOS](/docs/screenshots/hello_world_macOS12_M1.png)

**More Examples**

More examples can be found in the [tests](tests) directory.

## Current status

These rules where tested with Bazel 8.x.
There is a chance that you get this also working with Bazel 7.x.
If you need support for older version of Bazel please checkout an older state of this repository.
Initially, this repository had support for Bazel 4.x.

When using these rules, 
a prebuild version of Qt is fetched from [vertexwahn.de](https://vertexwahn.de/).
Implementation details can be found in [fetch_qt.bzl](fetch_qt.bzl).

I created a [`.bazelrc`](tests/.bazelrc) file that contains different configs: `vs2019`, `vs2022`, `gcc11`, `gcc13`, and `macos`.
This is necessary since Qt6 requires at least C++17 standard enabled, and different C++ compilers require different flags to enable this.

## Contributions

Any improvements to the Qt6 build experience using Bazel are welcome. 
Maybe you have solved this problem already. 
In this case, 
I would appreciate it if you could share your efforts under some permissive license.
If you name no specific license I assume you are fine with the current used license of this project (Apache 2.0 License).

## Similar projects

| Project                                                                                               | Bzlmod Support | Platform Support      | Build Type  | Last Commit       |
| ----------------------------------------------------------------------------------------------------- | -------------- | --------------------- | ----------- | ----------------- |
| [aabtop/rules_qt](https://github.com/aabtop/rules_qt)                                                 | no             | Windows, Linux        | Prebuild    | June 21, 2021     |
| [bbreslauer/qt-bazel-example](https://github.com/bbreslauer/qt-bazel-example)                         | no             | Linux                 | Prebuild    | April 5, 2020     |
| [FirasRomaneh/QT5WithBazel](https://github.com/FirasRomaneh/QT5WithBazel)                             | no             | Linux                 | Prebuild    | August 2, 2022    |
| [gwkawano/bazel_qt](https://github.com/gwkawano/bazel_qt)                                             | no             | Linux                 | Prebuild    | June 5, 2020      |
| [jheaff1/rules_qt](https://github.com/jheaff1/rules_qt)                                               | no             | Linux, macOS, Windows | Prebuild    | June 19, 2023     |
| [justbuchanan/bazel_rules_qt](https://github.com/justbuchanan/bazel_rules_qt)                         | no             | Linux, macOS, Windows | Prebuild    | November 13, 2024 |
| [kklochkov/rules_qt](https://github.com/kklochkov/rules_qt)                                           | no             | Linux, macOS          | Prebuild    | February 21, 2024 |
| [The-OpenROAD-Project/qt_bazel_prebuilts](https://github.com/The-OpenROAD-Project/qt_bazel_prebuilts) | yes            | ???                   | From Source | Jul 15, 2025      |

## License

This work is published under Apache 2.0 License.

This work builds on top of [justbuchanan/bazel_rules_qt](https://github.com/justbuchanan/bazel_rules_qt) which is also licensed under Apache 2.0 and 
was forked from [bbreslauer/qt-bazel-example](https://github.com/bbreslauer/qt-bazel-example).
See here for details: https://github.com/justbuchanan/bazel_rules_qt/graphs/contributors

## Thanks to all contributors ❤

 <a href = "https://github.com/Vertexwahn/rules_qt6/graphs/contributors">
   <img src = "https://contrib.rocks/image?repo=Vertexwahn/rules_qt6"/>
 </a>
