# Prebuilt Qt versions

As mentioned in the [README.md](../README.md) a prebuilt version of Qt is fetch from [vertexwahn.de](https://vertexwahn.de/).

This document explains how the archive of the prebuilt version is generated.

## Linux

    pip3 install aqtinstall
    cd $HOME/Qt
    python3 -m aqt install --outputdir $HOME/Qt 6.2.4 linux desktop
    tar cf - "6.2.4" | xz -z - > qt_6.2.4_linux_desktop_gcc_64.tar.xz

## Windows 64-bit x86

    python -m pip install aqtinstall
    aqt list-qt windows desktop --arch 6.2.4
    aqt install-qt windows desktop 6.2.0 win64_msvc2019_64 -m all

## macOS 12 Intel

    pip install aqtinstall
    aqt list-qt mac desktop --arch 6.2.4
    aqt install-qt mac desktop 6.2.4 clang_64
    # This is currently not done - but needs also to be done to get it working:
    cd 6.2.4/include
    ln -s ../lib/QtCore.framework/Headers QtCore
    ln -s ../lib/QtWidgets.framework/Headers QtWidgets
    ln -s ../lib/QtGui.framework/Headers QtGui
    # zip it
    mv 6.2.4.zip qt_6.2.4_mac_desktop_clang_64.zip

    brew install qt@6 # install qt 6.2.3_1 monterey
    cd .../external/qt_6.2.4_mac_desktop_clang_64/include

