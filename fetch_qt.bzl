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
    ### Qt 6.2.4

    http_archive(
        name = "qt_6.2.4_windows_desktop_win64_msvc2019_64",
        urls = ["https://vertexwahn.de/lfs/v1/qt_6.2.4_windows_desktop_win64_msvc2019_64.zip"],
        sha256 = "926b528de8470f2f4217c49a9c9acb29d9b1e649d27e1c7d59885e389e69e325",
        strip_prefix = "6.2.4/msvc2019_64",
        build_file = "//:qt_6.2.4_windows_desktop_win64_msvc2019_64.BUILD",
    )

    http_archive(
        name = "qt_6.2.4_linux_desktop_gcc_64",
        urls = ["https://vertexwahn.de/lfs/v1/qt_6.2.4_linux_desktop_gcc_64.tar.xz"],
        sha256 = "50f969898d0112c9035ff9833fca52bad7f6ba95e6d837add15ff9f22badbd69",
        strip_prefix = "6.2.4/gcc_64",
        build_file = "//:qt_6.2.4_linux_desktop_gcc_64.BUILD",
    )
