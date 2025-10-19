# AGENTS.md

## Testing

To test this rules there are real tests - those can be executed via:

`cd tests && bazel test --config=gcc13 //...`

Note the Bazel config depends on the use operating system and compiler setup.
Use `--config=gcc13` for Ubuntu 24.04 and GCC13,
use `--config=vs2022` for Windows and Visual Studio 2022,
and use `--config=macos` for macOS and Apple Clang.

Besies real test, there a also some test project located in the tests folder.

A minimal criteria for change and modification to this codebase is to ensure that 
the project in the tests folder can be build without any problems, i.e.:


```shell
bazel build --config=gcc13 //hello_world:hello_world
bazel build --config=gcc13 //horch:main
bazel run --config=gcc13 //moc_test:main
bazel build --config=gcc13 //qml_demo:qt_demo
bazel build --config=gcc13 //uic_demo:main
```

You should also be able to run this binary:

```shell
bazel run --config=gcc13 //moc_test:main
```

The following command should print the current used version of Qt:

```shell
bazel run --config=gcc13 //version_test:version_test
```

Furhtermore, the follow test should succeed:

```shell
bazel test --config=gcc13 //...
```

You can also run the following targets:

```shell
bazel run --config=gcc13 //hello_world:hello_world
```

This should show a Window that shows the current used Qt version.
Once the user closes the Windows the application will end.
