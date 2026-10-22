# Short title of what this build tests (issue #N)

<!--
Template for test builds. On a test/<name> branch, replace this file's text, then run
Actions → "Build packages" → Run workflow on that branch. The first line (without "# ")
becomes the release title after "Test build: ", the rest becomes the release notes.
The AppImage is named Hoshi-Reader-for-Linux-<pkgver>-<pkgrel>-test-<name>-x86_64.AppImage
and published as the pre-release test-<name>. Delete the release, its tag and the branch
when the test is done.
-->

**Test build, not a regular release.** Made for [issue #N](https://github.com/YashaNoos/Hoshi-Reader-for-Linux-unofficial-/issues/N): one sentence describing the problem.

This is the current AppImage with one change: what this build changes, in plain words.

**How to test**

1. Verify and start it:
   ```sh
   sha256sum -c Hoshi-Reader-for-Linux-*-test-*-x86_64.AppImage.sha256
   chmod +x Hoshi-Reader-for-Linux-*-test-*-x86_64.AppImage
   ./Hoshi-Reader-for-Linux-*-test-*-x86_64.AppImage
   ```
2. What to try, and what result to report.

It uses the same library and settings as the regular release, so you can switch back at any time. This pre-release will be removed once the test is done.
