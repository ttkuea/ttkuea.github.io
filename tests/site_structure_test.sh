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

assert_not_contains() {
  local path="$1"
  local pattern="$2"
  if rg -q "$pattern" "$path"; then
    echo "Unexpected pattern '$pattern' found in $path"
    exit 1
  fi
}

assert_order() {
  local path="$1"
  local first_pattern="$2"
  local second_pattern="$3"
  local first_line
  local second_line
  first_line=$(rg -n "$first_pattern" "$path" | head -n 1 | cut -d: -f1 || true)
  second_line=$(rg -n "$second_pattern" "$path" | head -n 1 | cut -d: -f1 || true)
  if [[ -z "$first_line" || -z "$second_line" || "$first_line" -ge "$second_line" ]]; then
    echo "Expected '$first_pattern' to appear before '$second_pattern' in $path"
    exit 1
  fi
}

assert_file_exists "index.html"
assert_file_exists "styles.css"
assert_file_exists "script.js"
assert_file_exists "assets/pic.jpeg"

assert_contains "index.html" "id=\"about\""
assert_contains "index.html" "id=\"education\""
assert_contains "index.html" "id=\"experience\""
assert_contains "index.html" "id=\"contact\""
assert_contains "index.html" "mailto:"
assert_contains "index.html" "linkedin.com"
assert_contains "index.html" "class=\"timeline-item company-flow\""
assert_contains "index.html" "aria-label=\"Role progression at Agoda\""
assert_order "index.html" "Senior Software Engineer" "Associate Software Engineer"
assert_not_contains "index.html" "Contact Me"
assert_not_contains "index.html" "View Education"
assert_contains "styles.css" "repeating-linear-gradient"

echo "site structure checks passed"
