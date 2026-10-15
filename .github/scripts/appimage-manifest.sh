#!/usr/bin/env bash
# Lists the Ubuntu packages whose files are bundled in an AppImage, with their exact
# versions and where to get their source code (for the LGPL/GPL source requirements).
# usage: appimage-manifest.sh APPDIR OUTPUT.md
set -euo pipefail
appdir=$1 out=$2

{
  # packages linuxdeploy copied a copyright file for
  ls "$appdir/usr/share/doc"
  # packages owning any bundled library, plugin or helper (GStreamer plugins have no
  # copyright file in the AppDir, so they are only found this way)
  # Matched by the file's real path on the build system: a file name alone also matches
  # -dev symlinks and same-named files of other packages (e.g. GTK 4 print backends).
  find "$appdir/usr/lib" -type f \( -name '*.so' -o -name '*.so.*' -o -perm -u+x \) -printf '%P\n' |
    sort -u | while read -r rel; do
      for base in /usr/lib/x86_64-linux-gnu /lib/x86_64-linux-gnu /usr/lib /lib; do
        [ -e "$base/$rel" ] || continue
        real=$(realpath "$base/$rel")
        # dpkg may record the file under /lib or /usr/lib (merged /usr)
        { dpkg -S "$real" 2>/dev/null || dpkg -S "${real/#\/usr\/lib\//\/lib\/}" 2>/dev/null || true; } |
          cut -d: -f1 | tr ',' '\n'
        continue 2
      done
      # elsewhere (e.g. pulseaudio/, libproxy/ subfolders): by name, ignoring -dev symlinks
      { dpkg -S "*/${rel##*/}" 2>/dev/null || true; } | cut -d: -f1 | tr ',' '\n' | grep -v -- '-dev$' || true
    done
} | tr -d ' ' | sed 's/:amd64$//' | sort -u |
  { xargs dpkg-query -W -f='${Package}\t${Version}\t${source:Package}\t${source:Version}\n' 2>/dev/null || true; } |
  sort -u > /tmp/manifest.tsv

{
  echo "# Packages bundled in this AppImage"
  echo
  echo "Built on $(. /etc/os-release; echo "$PRETTY_NAME"). Each package's license is in"
  echo "\`/usr/share/doc/<package>/copyright\` inside the AppImage (or on the source page)."
  echo "Source code: \`apt-get source <source package>=<source version>\` on Ubuntu, or the"
  echo "source package's Launchpad page (all published versions are listed there)."
  echo
  echo "| Package | Version | Source package | Source version |"
  echo "|---|---|---|---|"
  while IFS=$'\t' read -r pkg ver src srcver; do
    echo "| $pkg | $ver | [$src](https://launchpad.net/ubuntu/+source/$src) | $srcver |"
  done < /tmp/manifest.tsv
} > "$out"
echo "$(wc -l < /tmp/manifest.tsv) packages -> $out"
missing=$(cut -f1 /tmp/manifest.tsv | while read -r p; do
  [ -f "$appdir/usr/share/doc/$p/copyright" ] || echo "$p"; done | tr '\n' ' ')
if [ -n "$missing" ]; then
  echo "::warning title=License files missing from the AppImage::$missing"
fi
