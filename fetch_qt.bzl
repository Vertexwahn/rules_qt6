#
#    Copyright 2021 Julian Amann
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#
#    SPDX-License-Identifier: Apache-2.0
#

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def fetch_qt6():
    ### Qt 6.1.0

    # downloaded via  python -m aqt install windows desktop win64_msvc2019_64
    http_archive(
        name = "qt_6.1.0_windows_desktop_win64_msvc2019_64",
        urls = ["http://vertexwahn.de/lfs/v1/qt_6.1.0_windows_desktop_win64_msvc2019_64.zip"],
        sha256 = "705684b672bc4305435f5a78c80399aef08f0120623b59c02f1298339c93fab4",
        strip_prefix = "6.1.0/msvc2019_64",
        build_file = "//:qt_6.1.0_windows_desktop_win64_msvc2019_64.BUILD",
    )

    # downloaded via python -m aqt install 6.1.0 linux desktop gcc_64
    http_archive(
        name = "qt_6.1.0_linux_desktop_gcc_64",
        urls = ["http://vertexwahn.de/lfs/v1/qt_6.1.0_linux_desktop_gcc_64.tar.xz"],
        sha256 = "334dfabef8d98cf6e61db304b1ff8e892c7ea7a02f0e238014203161498ef5b9",
        strip_prefix = "6.1.0/gcc_64",
        build_file = "//:qt_6.1.0_linux_desktop_gcc_64.BUILD",
    )
