# Prebuild Qt versions

As mentioned in the README a prebuild version of Qt is fetch from [vertexwahn.de](https://vertexwahn.de/).

This document explains how the archive of the prebuild version is generated.

## Linux

    pip3 install aqtinstall 
    python3 -m aqt install --outputdir $HOME/Qt 6.2.4 linux desktop
    cd $HOME/Qt
    tar cf - "6.2.4" | xz -z - > qt_6.2.4_linux_desktop_gcc_64.tar.xz

## Windows

    python -m pip install aqtinstall
    python -m aqt install --outputdir C:\\Qt 5.12.10 windows desktop win64_msvc2017_64
