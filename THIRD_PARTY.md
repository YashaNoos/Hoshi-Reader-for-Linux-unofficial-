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
| **similar** | Text diff used to align the transcript with the book text. | Apache-2.0 | https://github.com/mitsuhiko/similar |
| **arboard** | Clipboard access on Wayland and X11. | MIT OR Apache-2.0 | https://github.com/1Password/arboard |
| **zbus-secret-service-keyring-store** | Stores Google Drive sign-in tokens in the desktop Secret Service (KWallet, GNOME Keyring). | MIT OR Apache-2.0 | https://github.com/open-source-cooperative/zbus-secret-service-keyring-store |
| **gtk-rs (gtk3-rs)** | Positioning context menus relative to the app window on Wayland. | MIT | https://github.com/gtk-rs/gtk3-rs |

The sherpa-onnx static library is downloaded from the official
[sherpa-onnx releases](https://github.com/k2-fsa/sherpa-onnx/releases) at package build
time and checked against a fixed SHA-256 in the [PKGBUILD](arch/PKGBUILD).

Transitive Rust dependencies pulled in by these crates are listed, with exact versions,
in `src-tauri/Cargo.lock` after the patches are applied.

## Upstream components this build relies on

Hoshi Reader Desktop is distributed under the GNU General Public License v3.0
(`Cargo.toml` declares GPL-3.0-or-later). The patches in this repository are
distributed under the same terms. The complete corresponding source of a build is:
the upstream release tag named in the PKGBUILD, plus the patches in
[`arch/`](arch).
