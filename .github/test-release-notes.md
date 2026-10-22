# Whole-pixel wheel scrolling (issue #3)

**Test build, not a regular release.** Made for [issue #3](https://github.com/YashaNoos/Hoshi-Reader-for-Linux-unofficial-/issues/3): blurry text on every other mouse-wheel step.

This is the 1.2.0-2 AppImage (normal 110% zoom) with one change. On KDE, one wheel click reaches WebKit as 1.5 steps, and WebKit multiplies that by a step size taken from the window height. When that step size is odd, a click scrolls by something like 139.5 px, so every other click ends on a half pixel. This build rounds each wheel event to a whole number of pixels: the same window scrolls 140, 139, 140, … px per click. The total distance stays the same.

**How to test**

1. Verify and start it, without any other `WEBKIT_…` variables:
   ```sh
   sha256sum -c Hoshi-Reader-for-Linux-1.2.0-2-test-wheel-pixels-x86_64.AppImage.sha256
   chmod +x Hoshi-Reader-for-Linux-1.2.0-2-test-wheel-pixels-x86_64.AppImage
   ./Hoshi-Reader-for-Linux-1.2.0-2-test-wheel-pixels-x86_64.AppImage
   ```
2. Scroll a popup, the book (horizontal text) and Settings with the mouse wheel. Does the text still turn blurry on every other click?
3. To compare in the same build, start it with the rounding switched off. The blur should be back:
   ```sh
   HOSHI_WHEEL_SNAP=0 ./Hoshi-Reader-for-Linux-1.2.0-2-test-wheel-pixels-x86_64.AppImage
   ```
4. If it is still blurry with the rounding on, start it with `HOSHI_WHEEL_DEBUG=1` and scroll a few clicks. It prints one `hoshi wheel: …` line per wheel event in the terminal; please paste a few of them in the issue.

It uses the same library and settings as 1.2.0-2, so you can switch back at any time. This pre-release will be removed once the test is done.
