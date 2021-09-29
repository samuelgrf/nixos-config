#! /usr/bin/env nix-shell
#! nix-shell -i bash -p common-updater-scripts gitMinimal jq
set -euo pipefail

ATTR=nix-index-database
GIT_URL=https://github.com/Mic92/nix-index-database.git

VERSION=$(list-git-tags "$GIT_URL" 2>/dev/null | tail -1)
CHANGES=$(update-source-version "$ATTR" "$VERSION" --print-changes)

if [ "$CHANGES" != "[]" ]; then
  FILES=$(echo "$CHANGES" | jq -r '.[].files[]')
  OLD_VERSION=$(echo "$CHANGES" | jq -r '.[].oldVersion')
  git commit $FILES -m "overlays/$ATTR: $OLD_VERSION -> $VERSION"
fi
