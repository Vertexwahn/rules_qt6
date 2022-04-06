# Experimental Bazel rules for Qt6

## Goal 

The goal of this experiment is to be able to build Qt6 applications using Bazel on Windows, 
Linux and macOS without the need to preinstall Qt6. 
All the magic to set up Qt6 should be done by Bazel with as little effort as possible.

## Current status

This project is just a testbed for Qt6 with Bazel 5.1.0 and still experimental.

A prebuild version of Qt is fetched from my website:

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

I created a `.bazelrc` file that contains a config for `gcc9` and `vs2019`. This is needed since Qt6 needs at least C++17 standard enabled.

    # Setup compiler flags - required for Qt6 is at least C++17
    build:gcc9 --cxxopt=-std=c++2a
    build:gcc9 --cxxopt=-Wall
    build:gcc9 --cxxopt=-Werror

    build:vs2019 --cxxopt=/std:c++17
    build:vs2019 --enable_runfiles # https://github.com/bazelbuild/bazel/issues/8843
    build:vs2019 --copt=-DWIN32_LEAN_AND_MEAN
    build:vs2019 --copt=-DNOGDI
    build:vs2019 --host_copt=-DWIN32_LEAN_AND_MEAN
    build:vs2019 --host_copt=-DNOGDI

### Working with Linux using GCC9

    bazel run --config=gcc9 //:Qt6HelloWorld

Compilation works. Execution not.

When trying to run this `Qt6HelloWorld` demo this error gets reported:

    /home/user/.cache/bazel/_bazel_$USER/196a14423fc09522ef7bd657344d1cd0/execroot/Qt6Testbed/bazel-out/k8-fastbuild/bin/Qt6HelloWorld: error while loading shared libraries: libQt6Network.so.6: cannot open shared object file: No such file or directory

### Working with Windows using Visual Studio 2019

Copy `platforms` folder to bazel-out:

    bazel run --config=vs2019 //...

Run Qt6HelloWorld

    bazel run --config=vs2019 //:Qt6HelloWorld

Should display the following window:

![](window.png)

## Contributions

Any improvements to the Qt6 build experience using Bazel are welcome. 
Maybe you have solved this problem already. 
In this case, 
I would appreciate it when you could share your efforts under some permissive license.

## License

This work is puplished under Apache 2.0 License.
This work builds on top of https://github.com/justbuchanan/bazel_rules_qt

The original project is contained in the `third_party` folder of this project with all license notes included.

which is also licensed under Apache 2.0.
The copyright holders of the bazel_rules_qt repsoitory are:
- justbuchanan Justin Buchanan
- limdor Xavier Bonaventura
- dnewmarch

See here for details: https://github.com/justbuchanan/bazel_rules_qt/graphs/contributors