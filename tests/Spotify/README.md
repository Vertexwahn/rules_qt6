# Spotify Demo

The code for this demo was copied from [Qt QML Book](https://www.qt.io/product/qt6/qml-book/ch13-networking-authentication) and can be found [here](https://github.com/qmlbook/qt6book/blob/main/docs/ch13-networking/src/oauth/main.cpp).
The code is available under the following license ([BSD-3-Clause](https://opensource.org/license/bsd-3-clause/)):

```
Copyright (c) 2012-2021, Juergen Bocklage Ryannel and Johan Thelin
All rights reserved.

Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, 
   this list of conditions and the following disclaimer in the documentation 
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors
   may be used to endorse or promote products derived from this software 
   without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```

A copy of the LICNESE file can be found [here](LICENSE).

## Current state

This demo does currently not working and shows a limitation of these Bazel rules

The CMake variant of

```python
qt_add_qml_module(SpotifyOAuth
    VERSION 1.0.0
    URI Spotify
    QML_FILES
        main.qml
    SOURCES
        spotifyapi.h spotifyapi.cpp
        spotifymodel.h spotifymodel.cpp
)
```

is missing in these rules.

Maybe there is some workaround to work with the generated file (i.e. `qmldir` and `SpotifyOAuth.qmltypes`)

## How to run?

### macOS

```bash
bazel run --config=macos //Spotify:SpotifyOAuth
```
