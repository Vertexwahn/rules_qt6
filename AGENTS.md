# AGENTS.md

## Testing

To test these rules, there are real tests - those can be executed via:

`cd tests && bazel test //...`

The settings for the used operating system and compiler (e.g. the C++ standard) are applied automatically
(see `common --enable_platform_specific_config` in `tests/.bazelrc`).

Besides real tests, there are also some test projects located in the tests folder.

A minimal criterion for changes and modifications to this codebase is to ensure that
the projects in the tests folder can be built without any problems, i.e.:

```shell
bazel build //hello_world:hello_world
bazel build //horch:main
bazel build //moc_test:main
bazel build //qml_demo:qt_demo
bazel build //uic_demo:main
```

You should also be able to run this binary:

```shell
bazel run //moc_test:main
```

The following command should print the current used version of Qt:

```shell
bazel run //version_test:version_test
```

Furthermore, the following test should succeed:

```shell
bazel test //...
```

You can also run the following targets:

```shell
bazel run //hello_world:hello_world
```

This should show a window that shows the current used Qt version.
Once the user closes the window, the application will end.

To test another supported Qt version (see `extension/qt_versions.bzl`), change the version in `qt.install(version = ...)` of `tests/MODULE.bazel`.

## Adding a Qt version

`python3 extension/versions/generate.py <version>` generates `extension/versions/<version>.bzl` (download paths and SHA-256 of all Qt archives).
Afterwards, add the version to `extension/qt_versions.bzl` (and update `DEFAULT_QT_VERSION` for a new LTS release).
Update the Qt versions (`qt`) in the CI matrix (`.github/workflows/bazel_build.yml`) and in `tests/MODULE.bazel` accordingly.
Only LTS releases of Qt are supported.
