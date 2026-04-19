#!/usr/bin/env bash
# Bump Cloudron package version to match upstream ZeroClaw release.
# Usage: scripts/bump-version.sh <semver without v, e.g. 0.7.4>
set -euo pipefail

NEW="${1:?usage: scripts/bump-version.sh <version>}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

MANIFEST="CloudronManifest.json"
CHANGELOG="CHANGELOG"

if [[ ! -f "$MANIFEST" ]]; then
  echo "error: $MANIFEST not found" >&2
  exit 1
fi

CURRENT="$(jq -r '.version' "$MANIFEST")"
if [[ "$CURRENT" == "$NEW" ]]; then
  echo "Already at $NEW — nothing to do."
  exit 1
fi

jq --arg v "$NEW" '.version = $v | .upstreamVersion = $v' "$MANIFEST" > "${MANIFEST}.tmp"
mv "${MANIFEST}.tmp" "$MANIFEST"

DF="Dockerfile"
if [[ -f "$DF" ]]; then
  python3 - "$NEW" "$DF" <<'PY'
import re
import sys
new, path = sys.argv[1], sys.argv[2]
text = open(path, encoding="utf-8").read()
updated, n = re.subn(
    r"^ARG ZEROCLAW_GIT_TAG=.*$",
    f"ARG ZEROCLAW_GIT_TAG=v{new}",
    text,
    count=1,
    flags=re.MULTILINE,
)
if n != 1:
    sys.exit(f"error: could not update ZEROCLAW_GIT_TAG in {path!r} (matches={n})")
open(path, "w", encoding="utf-8").write(updated)
PY
fi

BLOCK="## ${NEW} (packaged)

- Track upstream [v${NEW}](https://github.com/zeroclaw-labs/zeroclaw/releases/tag/v${NEW}).
"

if [[ -f "$CHANGELOG" ]]; then
  {
    head -n 2 "$CHANGELOG"
    printf '%s\n' "$BLOCK"
    tail -n +3 "$CHANGELOG"
  } > "${CHANGELOG}.tmp"
  mv "${CHANGELOG}.tmp" "$CHANGELOG"
else
  printf '# Changelog\n\n%s\n' "$BLOCK" > "$CHANGELOG"
fi

echo "Bumped package version: $CURRENT → $NEW"
