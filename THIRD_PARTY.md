# Third-party components added by the Linux build

Upstream's own dependencies and attributions are listed in the app (About, Dependencies
and Attribution) and in the
[upstream README](https://github.com/Manhhao/Hoshi-Reader-Desktop#readme). This file
covers only what the Linux patches add. On Linux, the app's attribution page shows these
as well.

## Code and models

| Component | Used for | License | Link |
|---|---|---|---|
| **Hoshi Reader Android** (HuangAntimony) | The Sasayaki transcription pipeline (voice-activity segmentation, parallel recognition, stitching) is a port of its approach and constants. | GPL-3.0 | https://github.com/HuangAntimony/Hoshi-Reader-Android |
| **ReazonSpeech k2 v2** (Reazon Research) | Japanese speech recognition model, int8 build. Downloaded on first use from a pinned Hugging Face revision (`291488c8151be24d7da4bf7af26e533fad96e407`) and verified with SHA-256. Not included in this repository or in the package. | Apache-2.0 | https://huggingface.co/reazon-research/reazonspeech-k2-v2 |
| **sherpa-onnx** (k2-fsa) | Speech recognition runtime (Rust crate `sherpa-onnx` 1.13.8 and the prebuilt static library for the same version, linked into the binary). | Apache-2.0 | https://github.com/k2-fsa/sherpa-onnx |
| **ONNX Runtime** (Microsoft) | Inference engine contained in the sherpa-onnx static library. | MIT | https://github.com/microsoft/onnxruntime |
| **Symphonia** | Audio decoding (mp3, AAC/m4b/m4a, ALAC, FLAC, Ogg Vorbis, WAV) for transcription and duration reading. | MPL-2.0 | https://github.com/pdeljanov/Symphonia |
| **arboard** | Clipboard access on Wayland and X11. | MIT OR Apache-2.0 | https://github.com/1Password/arboard |
| **zbus-secret-service-keyring-store** | Stores Google Drive sign-in tokens in the desktop Secret Service (KWallet, GNOME Keyring). | MIT OR Apache-2.0 | https://github.com/open-source-cooperative/zbus-secret-service-keyring-store |
| **gtk-rs (gtk3-rs)** | Positioning context menus relative to the app window on Wayland. | MIT | https://github.com/gtk-rs/gtk3-rs |

The sherpa-onnx static library is downloaded from the official
[sherpa-onnx releases](https://github.com/k2-fsa/sherpa-onnx/releases) at package build
time and checked against a fixed SHA-256 in the [PKGBUILD](arch/PKGBUILD).

Transitive Rust dependencies pulled in by these crates are listed, with exact versions,
in `src-tauri/Cargo.lock` after the patches are applied.

## Libraries bundled in the AppImage

The Arch package uses the libraries installed on your system and bundles none of them.
The AppImage has to run on other distributions, so it carries its own copies of about
280 Ubuntu 24.04 packages. The main ones:

| Library | Used for | License |
|---|---|---|
| **WebKitGTK** (webkit2gtk-4.1, JavaScriptCore) | The web view the whole app runs in | LGPL-2.0/2.1-or-later and BSD-style |
| **GTK 3, GLib, Pango, Cairo, gdk-pixbuf** | Window, text layout, drawing | LGPL-2.0/2.1-or-later (Cairo: LGPL-2.1 or MPL-1.1) |
| **libsoup 3, glib-networking** | Networking inside the web view | LGPL-2.0/2.1-or-later |
| **GStreamer** (core, plugins base/good/bad, gst-libav) | Audiobook and word-audio playback | LGPL-2.0/2.1-or-later |
| **FFmpeg** (libavcodec, libavformat, …) | Audio decoding inside GStreamer | GPL-2.0-or-later as built by Ubuntu (FFmpeg itself is LGPL-2.1-or-later; Ubuntu enables its GPL parts) |
| **OpenSSL 3** | TLS | Apache-2.0 |
| **ICU** | Unicode and text segmentation | ICU license (MIT-style) |
| **SQLite** | Web view storage | Public domain |
| **libxml2** | XML parsing | MIT |

- **License texts:** every bundled package's license is inside the AppImage, in
  `usr/share/doc/<package>/copyright` (run the AppImage with `--appimage-extract` to
  unpack it).
- **Exact list:** every release has a `…AppImage.packages.md` file next to the
  AppImage that lists each bundled package with its exact version and source package.
- **Source code:** these are unmodified Ubuntu packages. Their source is available from
  Ubuntu with `apt-get source <source package>=<source version>`, or from each source
  package's page on [Launchpad](https://launchpad.net/ubuntu).

## Upstream components this build relies on

Hoshi Reader Desktop is distributed under the GNU General Public License v3.0
(`Cargo.toml` declares GPL-3.0-or-later). The patches in this repository are
distributed under the same terms. The complete corresponding source of a build is:
the upstream release tag named in the PKGBUILD, plus the patches in
[`arch/`](arch). For the AppImage, add the Ubuntu source packages listed in its
`…AppImage.packages.md` file (see above).
