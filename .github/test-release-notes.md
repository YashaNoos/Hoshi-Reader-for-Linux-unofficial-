# Interface zoom 100% (issue #3)

**Test build, not a regular release.** Made for [issue #3](https://github.com/YashaNoos/Hoshi-Reader-for-Linux-unofficial-/issues/3): blurry popup text on every other scroll step.

This is the 1.2.0-2 AppImage with one change: the interface zoom is 100% instead of 110%. Everything looks about 10% smaller than usual; that is expected. If the blur is gone at 100%, the zoom is what triggers it.

**How to test**

1. Verify and start it, without any `WEBKIT_…` variables:
   ```sh
   sha256sum -c Hoshi-Reader-for-Linux-1.2.0-2-test-zoom-100-x86_64.AppImage.sha256
   chmod +x Hoshi-Reader-for-Linux-1.2.0-2-test-zoom-100-x86_64.AppImage
   ./Hoshi-Reader-for-Linux-1.2.0-2-test-zoom-100-x86_64.AppImage
   ```
2. Look up a word and scroll the popup step by step with the mouse wheel. Does the text still turn blurry on every other step?

It uses the same library and settings as 1.2.0-2, so you can switch back at any time. This pre-release will be removed once the test is done.
