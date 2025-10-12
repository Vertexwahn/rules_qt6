#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

# Copied from https://github.com/bazel-contrib/rules-template (at hash 2154387cb9c634b68139f6e280dba10fc08e9f75)
# Available under Apache-2.0 license
# Copyright belongs to contributors of rules-template (see https://github.com/bazel-contrib/rules-template/graphs/contributors)
# Some modification where applied with are also available under Apache-2.0 license

# Set by GH actions, see
# https://docs.github.com/en/actions/learn-github-actions/environment-variables#default-environment-variables
TAG=${GITHUB_REF_NAME}
# The prefix is chosen to match what GitHub generates for source archives
PREFIX="rules_qt6-${TAG}"
ARCHIVE="rules_qt6-$TAG.tar.gz"
git archive --format=tar --prefix=${PREFIX}/ ${TAG} | gzip > $ARCHIVE
SHA=$(shasum -a 256 $ARCHIVE | awk '{print $1}')

cat << EOF
## Using Bzlmod
Add to your `MODULE.bazel` file:
\`\`\`starlark
bazel_dep(name = "rules_qt", version = "${TAG}")

qt = use_extension("@rules_qt//:extensions.bzl", "qt")
qt.fetch()
use_repo(
    qt,
    "qt_linux_x86_64",
    "qt_mac_aarch64",
    "qt_windows_x86_64",
)

register_toolchains(
    "@rules_qt//tools:all"
)

EOF

#awk 'f;/--SNIP--/{f=1}' e2e/smoke/WORKSPACE.bazel
echo "\`\`\`"
