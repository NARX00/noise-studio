#!/usr/bin/env sh
# check-site.sh — verify the live site is up AND serving the exact file you published.
#
# This does two things:
#   1. Uptime:    confirms the URL responds with HTTP 200.
#   2. Integrity: confirms the served file's SHA-256 matches index.html.sha256.
#                 This is the important one — it detects tampering, a bad deploy,
#                 or a stale/incorrect version being served.
#
# Usage:
#   ./check-site.sh https://your-project.pages.dev
#   ./check-site.sh                      # uses $SITE_URL env var
#
# Exit codes: 0 = all good, 1 = down/unreachable, 2 = hash mismatch (investigate!)

set -eu

URL="${1:-${SITE_URL:-}}"
SUMFILE="index.html.sha256"

if [ -z "$URL" ]; then
  echo "Usage: $0 https://your-site.example" >&2
  exit 1
fi

if [ ! -f "$SUMFILE" ]; then
  echo "Error: $SUMFILE not found. Run this from the repository root." >&2
  exit 1
fi

EXPECTED=$(cut -d' ' -f1 "$SUMFILE")

# --- 1. uptime: fetch and check status ---
TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT

STATUS=$(curl -sS -L -o "$TMP" -w '%{http_code}' --max-time 20 "$URL" 2>/dev/null) || STATUS="000"
[ -z "$STATUS" ] && STATUS="000"

if [ "$STATUS" != "200" ]; then
  echo "DOWN: $URL returned HTTP $STATUS"
  exit 1
fi
echo "UP:   $URL responded 200"

# --- 2. integrity: hash what was actually served ---
if command -v sha256sum >/dev/null 2>&1; then
  ACTUAL=$(sha256sum "$TMP" | cut -d' ' -f1)
elif command -v shasum >/dev/null 2>&1; then
  ACTUAL=$(shasum -a 256 "$TMP" | cut -d' ' -f1)
else
  echo "Error: no sha256sum or shasum available." >&2
  exit 1
fi

if [ "$ACTUAL" = "$EXPECTED" ]; then
  echo "OK:   served file matches published fingerprint"
  echo "      $EXPECTED"
  exit 0
else
  echo "MISMATCH: the live site is NOT serving the file you published!"
  echo "  expected: $EXPECTED"
  echo "  actual:   $ACTUAL"
  echo ""
  echo "  Likely causes, in order:"
  echo "   1. You edited index.html but forgot to run ./release.sh before pushing."
  echo "   2. A deploy is still propagating (wait a minute, re-run)."
  echo "   3. Something is serving a modified file. Investigate immediately."
  exit 2
fi
