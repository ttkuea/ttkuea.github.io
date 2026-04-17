#!/usr/bin/env bash
set -euo pipefail

assert_file_exists() {
  local path="$1"
  if [[ ! -f "$path" ]]; then
    echo "Missing file: $path"
    exit 1
  fi
}

assert_contains() {
  local path="$1"
  local pattern="$2"
  if ! rg -q "$pattern" "$path"; then
    echo "Expected pattern '$pattern' not found in $path"
    exit 1
  fi
}

assert_file_exists "index.html"
assert_file_exists "styles.css"
assert_file_exists "script.js"
assert_file_exists "assets/headshot-placeholder.svg"

assert_contains "index.html" "id=\"about\""
assert_contains "index.html" "id=\"projects\""
assert_contains "index.html" "id=\"experience\""
assert_contains "index.html" "id=\"contact\""
assert_contains "index.html" "mailto:"
assert_contains "index.html" "linkedin.com"

echo "site structure checks passed"
