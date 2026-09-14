#!/usr/bin/env bash
#
# Compiles the example resume and the test suite.
#
# Warnings are treated as failures: an unavailable font or a deprecated call
# only ever shows up as a warning, and either one would reach users as a
# silently wrong document.

set -uo pipefail

cd "$(dirname "$0")/.."
root=$(pwd)

typst=${TYPST:-typst}
if ! command -v "$typst" >/dev/null 2>&1; then
  echo "error: '$typst' not found; set TYPST to the compiler to use" >&2
  exit 1
fi

out=$(mktemp -d)
trap 'rm -rf "$out"' EXIT

failures=0

fail() {
  echo "  ✗ $1"
  failures=$((failures + 1))
}

# `template/resume.typ` imports the package the way a user would, so install the
# working tree into the local package directory before compiling it.
version=$(sed -n 's/^version = "\(.*\)"/\1/p' typst.toml)
packages="${XDG_DATA_HOME:-$HOME/.local/share}/typst/packages/preview/ttq-classic-resume"
rm -rf "$packages"
mkdir -p "$packages/$version"
cp -r src typst.toml "$packages/$version/"

echo "Testing ttq-classic-resume $version with $("$typst" --version)"
echo

# Compiles a file that is expected to succeed without warnings.
compile() {
  local input=$1
  local name
  name=$(basename "$input" .typ)
  local log="$out/$name.log"

  if ! "$typst" compile --font-path fonts --root "$root" "$input" "$out/$name.pdf" \
    >"$log" 2>&1; then
    fail "$input failed to compile"
    sed 's/^/    /' "$log"
  elif [ -s "$log" ]; then
    fail "$input compiled with warnings"
    sed 's/^/    /' "$log"
  else
    echo "  ✓ $input"
  fi
}

# Compiles a file that is expected to be rejected, and checks that the error
# mentions the given text so that a failure for the wrong reason is caught.
compile_error() {
  local input=$1
  local expected=$2
  local name
  name=$(basename "$input" .typ)
  local log="$out/$name.log"

  if "$typst" compile --font-path fonts --root "$root" "$input" "$out/$name.pdf" \
    >"$log" 2>&1; then
    fail "$input compiled, but was expected to fail"
  elif ! grep -qF "$expected" "$log"; then
    fail "$input failed without mentioning '$expected'"
    sed 's/^/    /' "$log"
  else
    echo "  ✓ $input (rejected as expected)"
  fi
}

echo "Documents that must compile cleanly:"
compile template/resume.typ
for file in tests/*.typ; do
  compile "$file"
done

echo
echo "Documents that must be rejected:"
compile_error tests/errors/unknown-option.typ "unknown option"
compile_error tests/errors/mixed-grid-items.typ "cannot be mixed"
compile_error tests/errors/incomplete-grid-item.typ "every item must be"
compile_error tests/errors/bad-columns.typ "positive integer"

echo
if [ "$failures" -gt 0 ]; then
  echo "$failures check(s) failed."
  exit 1
fi
echo "All checks passed."
