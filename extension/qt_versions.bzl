"""Qt versions supported by rules_qt (LTS releases only)."""

load("//extension/versions:6.12.1.bzl", QT_6_12_1 = "QT")
load("//extension/versions:6.8.3.bzl", QT_6_8_3 = "QT")

# Used if `qt.install` does not specify a version
DEFAULT_QT_VERSION = "6.12.1"

# Qt version -> OS -> Qt module -> archive (path relative to the Qt online installer repository and SHA-256)
QT_VERSIONS = {
    "6.12.1": QT_6_12_1,
    "6.8.3": QT_6_8_3,
}
