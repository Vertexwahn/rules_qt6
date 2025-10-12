# Test Core5Compat

This example shows how to make use of `qt_cc_test`.

## How to test?

### macOS

```shell
bazel test --config=macos //core5_compat:main
```

### Ubuntu 24.04

```shell
bazel test --config=gcc13 //core5_compat:main
```

### Windows

```shell
bazel test --config=vs2022 //core5_compat:main
```
