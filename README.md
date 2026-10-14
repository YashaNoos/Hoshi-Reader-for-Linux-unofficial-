# Hoshi Reader for Linux (unofficial)

> **This is an unofficial, community-made Linux port.** It is not made, endorsed or
> supported by the Hoshi Reader author. Please report problems with *this build*
> [here](../../issues), not to the upstream project.

[Hoshi Reader Desktop](https://github.com/Manhhao/Hoshi-Reader-Desktop) by
[Manhhao](https://github.com/Manhhao) is a Japanese EPUB reader with a pop-up
dictionary, Anki mining and audiobook support (Sasayaki), built with Tauri and Svelte.
Upstream ships macOS and Windows builds only. This repository holds a small set of
patches that make it build and run on Linux, plus the packaging to install it.

| | |
|---|---|
| **Based on upstream** | v1.1.2 |
| **Linux build revision** | 1.1.2-5 |
| **Platform** | Linux x86_64 |
| **Tested on** | Arch Linux, KDE Plasma (Wayland) |
| **License** | GPL-3.0-or-later, same as upstream |

## Install

### Arch Linux: build the package yourself

```sh
git clone https://github.com/YashaNoos/Hoshi-Reader-for-Linux-unofficial-.git
cd Hoshi-Reader-for-Linux-unofficial-/arch
makepkg -si
```

The first build takes about 10 minutes and a few GB of disk space and needs a network
connection (it downloads upstream's source at the matching release tag, applies the
patches in [`arch/`](arch), and fetches the Rust and Node dependencies).

### Arch Linux: pre-built package

Download the `.pkg.tar.zst` from the [Releases](../../releases) page, check it against
the `.sha256` file next to it, and install it:

```sh
sha256sum -c hoshi-reader-linux-*.pkg.tar.zst.sha256
sudo pacman -U hoshi-reader-linux-*.pkg.tar.zst
```

Pre-built packages are built by [GitHub Actions](.github/workflows/build-arch.yml) from
this repository in a clean Arch container. Arch is a rolling release: if a system
update breaks a pre-built package, rebuild it with `makepkg` or wait for a new release.

### AUR

An AUR package is planned.

### Other distributions

Not packaged yet. The patches should apply anywhere upstream's
[build requirements](https://github.com/Manhhao/Hoshi-Reader-Desktop#development)
are met (Rust, Node with pnpm, CMake, a C++23 compiler, WebKitGTK 4.1), but this is
untested. Help and reports are welcome.

## Limitations

Please read these before installing.

- **Google Drive sync does not work out of the box.** The official builds contain
  Google credentials that are not part of the public source, so a build from source
  cannot sign in. If you create your own Google Cloud OAuth client, you can build with
  `HOSHI_GOOGLE_CLIENT_ID` and `HOSHI_GOOGLE_CLIENT_SECRET` set (see the comment in the
  [PKGBUILD](arch/PKGBUILD)); sign-in tokens are kept in KWallet or GNOME Keyring. This path
  is implemented but **has not been tested**. If you rely on syncing with the iOS or
  Android apps, this build is not for you yet.
- **Sasayaki transcription** works, for Japanese audio only. On first use it downloads
  the ~160 MB ReazonSpeech model from Hugging Face into
  `~/.cache/de.manhhao.hoshi/Models/` and checks it with SHA-256. After that it runs
  fully offline. It was verified on short test audio (mp3, m4b, flac) but not on
  full-length audiobooks.
- **Tested on one setup:** Arch Linux with KDE Plasma on Wayland. Other desktops, X11
  and other distributions are unverified.
- **x86_64 only.**
- **No in-app updates.** The updater is disabled on Linux; update through your package
  manager or the Releases page.
- **Clipboard monitor:** copying exactly the same text twice in a row is not looked up
  a second time (Linux has no clipboard change counter, so changes are detected by
  comparing the text). Copy anything else in between and it works.
- **A Japanese font is required.** `noto-fonts-cjk` is a dependency; without it
  fontconfig falls back to a Chinese font.

## What is different from upstream

Each patch in [`arch/`](arch) is one self-contained change:

| Patch | What it does |
|---|---|
| `0001-linux-support` | Makes the app compile on Linux: clipboard, audio decoding, keyring storage for sign-in tokens. |
| `0002-linux-audio-loopback-server` | Audiobook playback. WebKitGTK cannot play `<audio>` from custom URL schemes, so audio is served through a small local loopback server. |
| `0003-linux-japanese-vertical-text` | Correct vertical Japanese text: rotated punctuation and long-vowel marks, Japanese instead of Chinese fonts, furigana placed like on Windows/macOS. |
| `0004-linux-desktop-file-dialog` | Uses your desktop's own file dialog (for example Dolphin on KDE) through xdg-desktop-portal when available. |
| `0005-update-tauri-2.12-wayland-titlebar` | Updates Tauri so the title bar buttons work on Wayland. |
| `0006-linux-sasayaki-transcription` | On-device Sasayaki transcription using sherpa-onnx and the ReazonSpeech model. |
| `0007-linux-wayland-context-menu` | Right-click menus open at the pointer on Wayland. |
| `0008-linux-attribution-and-updater` | Adds this build's components to the in-app attribution page and disables the updater on Linux. |
| `0009-linux-clipboard-monitor-reselect` | Clipboard monitor no longer resets the dictionary pane to the first word when you click another word in the search text. |
| `0010-linux-clipboard-read-off-main-thread` | Fixes a crash when copying text inside the app (for example from a definition) while the clipboard monitor is on. |

The compiler flags in the PKGBUILD work around newer GCC versions (15/16) breaking
upstream's C++ dictionary engine because of missing standard `#include`s.

To build **without** transcription, append `-- --no-default-features` to the
`pnpm tauri build` line in the PKGBUILD. That also drops the sherpa-onnx download.

## Where things are stored

- Library (books, dictionaries, fonts, statistics): `~/.local/share/de.manhhao.hoshi/`
- Transcription model: `~/.cache/de.manhhao.hoshi/Models/` (safe to delete)
- Audiobook files are **not copied**; the app remembers their path.

## Credits and third-party components

Everything that matters is Manhhao's work: this repository only adds the Linux layer.
The Sasayaki transcription pipeline is ported from
[Hoshi Reader Android](https://github.com/HuangAntimony/Hoshi-Reader-Android) by
HuangAntimony (GPL-3.0), and uses the
[ReazonSpeech](https://huggingface.co/reazon-research/reazonspeech-k2-v2) model by
Reazon Research (Apache-2.0) through [sherpa-onnx](https://github.com/k2-fsa/sherpa-onnx).
See [THIRD_PARTY.md](THIRD_PARTY.md) for the full list with licenses. The same list is
shown in the app under About, Dependencies and Attribution.

## Contributing

Bug reports are most useful with your distribution, desktop environment, whether you
use Wayland or X11, and the terminal output of `hoshi-reader`. If you can test another
distribution or desktop, please say so in an issue.

If Linux support is welcome upstream, these patches are meant to be easy to turn into
a pull request. If that happens, this repository will point there.

## License

GPL-3.0-or-later, the same as upstream. See [LICENSE](LICENSE).
