# Release process

Publishing to the [Bazel Central Registry](https://registry.bazel.build/modules/rules_qt) is automated via [publish-to-bcr](https://github.com/bazel-contrib/publish-to-bcr).

## Creating a release (e.g. 0.0.7)

1. Update `version` in `MODULE.bazel` (e.g. `0.0.7`) and commit to `main`.
2. Tag and push:

   ```shell
   git tag -a 0.0.7 -m "0.0.7"
   git push origin 0.0.7
   ```

3. Done. The `Release` workflow builds the archive, creates the GitHub release,
   and then opens a pull request against the BCR from the fork
   `Vertexwahn/bazel-central-registry`.
4. On the BCR pull request, click **"Ready for review"** once CI is green — this
   auto-approves the entry for merging.

## One-time setup (manual)

- Create a **classic** GitHub Personal Access Token with `repo` and `workflow`
  scopes and save it as the repository secret `BCR_PUBLISH_TOKEN`
  (Settings > Secrets and variables > Actions).
- Ensure the fork `Vertexwahn/bazel-central-registry` of
  [bazelbuild/bazel-central-registry](https://github.com/bazelbuild/bazel-central-registry) exists.

## Retry a failed BCR publish

Manually dispatch the **Publish to BCR** workflow from the GitHub Actions UI
and enter the tag name (e.g. `0.0.7`).
