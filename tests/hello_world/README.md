# How to run?

## Ubuntu


*Run Hello World demo with Ubuntu 20.04:*

```shell
bazel run --config=gcc9 //hello_world:hello_world
```

*Run Hello World demo with Ubuntu 22.04:*

```shell
bazel run --config=gcc11 //hello_world:hello_world
```

## Windows

```shell
bazel run --config=vs2019 //hello_world:hello_world
```

*Run Hello World demo with Windows 10/11 x64 with Visual Studio 2022:*

```shell
bazel run --config=vs2022 //hello_world:hello_world
```
