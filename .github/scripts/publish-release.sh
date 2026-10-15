#!/usr/bin/env bash
# Publishes (or completes) the GitHub release for a tag with the Arch package, the
# AppImage and their checksums.
#   usage: publish-release.sh <tag> <dir>
# Files are collected from anywhere under <dir>, so the layout inside the downloaded
# artifacts does not matter. Fails if the Arch package is missing. If the release
# already exists (for example one drafted or published from the GitHub web page), the
# files are uploaded to it instead, replacing any with the same name.
# Needs GH_TOKEN and GITHUB_REPOSITORY.
set -euo pipefail

tag=$1
dir=$2

echo "Files found under $dir:"
find "$dir" -type f -printf '  %P (%s bytes)\n'

mapfile -t files < <(find "$dir" -type f \( \
    -name '*.pkg.tar.zst' -o -name '*.pkg.tar.zst.sha256' \
    -o -name '*.AppImage' -o -name '*.AppImage.sha256' -o -name '*.AppImage.packages.md' \
  \) | sort)

if ! printf '%s\n' "${files[@]}" | grep -q '\.pkg\.tar\.zst$'; then
  echo "::error title=Publish release::No Arch package (.pkg.tar.zst) found under $dir"
  exit 1
fi

# two files with the same name would overwrite each other on the release
dupes=$(printf '%s\n' "${files[@]##*/}" | sort | uniq -d)
if [ -n "$dupes" ]; then
  echo "::error title=Publish release::Same file name found twice: $dupes"
  exit 1
fi

echo "Publishing to $tag:"
printf '  %s\n' "${files[@]##*/}"

if gh release view "$tag" --repo "$GITHUB_REPOSITORY" >/dev/null 2>&1; then
  echo "Release $tag already exists: uploading the files to it"
  gh release upload "$tag" --repo "$GITHUB_REPOSITORY" --clobber "${files[@]}"
else
  gh release create "$tag" \
    --repo "$GITHUB_REPOSITORY" \
    --title "Hoshi Reader for Linux $tag (unofficial)" \
    --notes "Unofficial Linux build of Hoshi Reader Desktop. **Arch Linux:** package, see the README for installation and the list of limitations; verify with the .sha256 file, then install with \`sudo pacman -U\`. **Other distributions:** experimental AppImage (if attached), built on Ubuntu 24.04, needs glibc 2.39 or newer; verify with the .sha256 file, then \`chmod +x\` it and run it." \
    "${files[@]}"
fi
