# Qt Version Test

This simple test prints the Qt version being used at compile time.

## Build and Run

```shell
bazel run --config=gcc13 //version_test:version_test
```

This will output the Qt version, major, minor, and patch numbers.
