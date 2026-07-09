#!/usr/bin/env sh
# release.sh — regenerate the SHA-256 checksum for index.html and sync it into
# README.md and index.html.sha256, so the published fingerprint always matches
# the shipped file. Run this after ANY edit to index.html, before committing.
#
# Usage:   ./release.sh
# Works on macOS and Linux. (Windows users: see release.ps1)

set -eu

FILE="index.html"
SUMFILE="index.html.sha256"
README="README.md"

if [ ! -f "$FILE" ]; then
  echo "Error: $FILE not found. Run this from the repository root." >&2
  exit 1
fi

# --- compute SHA-256 (support both Linux sha256sum and macOS shasum) ---
if command -v sha256sum >/dev/null 2>&1; then
  HASH=$(sha256sum "$FILE" | cut -d' ' -f1)
elif command -v shasum >/dev/null 2>&1; then
  HASH=$(shasum -a 256 "$FILE" | cut -d' ' -f1)
else
  echo "Error: no sha256sum or shasum found." >&2
  exit 1
fi

echo "SHA-256($FILE) = $HASH"

# --- write the checksum file in the standard 'HASH  FILE' format ---
printf '%s  %s\n' "$HASH" "$FILE" > "$SUMFILE"
echo "Wrote $SUMFILE"

# --- update the 64-hex-char fingerprint inside README.md, if present ---
if [ -f "$README" ]; then
  # replace any 64-char hex string that is followed by (optional space) index.html
  # and also any standalone 64-char hex in the fenced block. We match the exact
  # 'HASH  index.html' line the README uses.
  if grep -Eq '[0-9a-f]{64}  index\.html' "$README"; then
    # portable in-place edit via temp file
    tmp=$(mktemp)
    sed -E "s/[0-9a-f]{64}  index\.html/$HASH  index.html/g" "$README" > "$tmp"
    mv "$tmp" "$README"
    echo "Updated fingerprint in $README"
  else
    echo "Note: no 'HASH  index.html' line found in $README to update." >&2
  fi
fi

echo "Done. Review changes, then: git add -A && git commit -m 'release: update build + checksum'"
