# regex

This example shows how to make use of `qt_cc_test`.

## How to test?

### macOS

```shell
bazel test --config=macos //regex:main
```

### Ubuntu 24.04

```shell
bazel test --config=gcc13 //regex:main
```

### Windows

```shell
bazel test --config=vs2022 //regex:main
```
