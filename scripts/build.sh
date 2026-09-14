#!/usr/bin/env bash
#
# Compiles the example resume to pdfs/resume.pdf and refreshes thumbnail.png
# from its first page.

set -euo pipefail

cd "$(dirname "$0")/.."

typst=${TYPST:-typst}
if ! command -v "$typst" >/dev/null 2>&1; then
  echo "error: '$typst' not found; set TYPST to the compiler to use" >&2
  exit 1
fi

mkdir -p pdfs

# `template/resume.typ` imports the package by name, so the working tree has to
# be installed locally before it can be compiled.
version=$(sed -n 's/^version = "\(.*\)"/\1/p' typst.toml)
packages="${XDG_DATA_HOME:-$HOME/.local/share}/typst/packages/preview/ttq-classic-resume"
rm -rf "$packages"
mkdir -p "$packages/$version"
cp -r src typst.toml "$packages/$version/"

echo "Compiling resume..."
"$typst" compile --font-path fonts --root . template/resume.typ pdfs/resume.pdf
echo "  ✓ $(pwd)/pdfs/resume.pdf"

# The thumbnail is the first page at 144 ppi, which is the size Typst Universe
# shows it at.
echo "Rendering thumbnail..."
"$typst" compile --font-path fonts --root . --format png --ppi 144 --pages 1 \
  template/resume.typ thumbnail.png
echo "  ✓ $(pwd)/thumbnail.png"
