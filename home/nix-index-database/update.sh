#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curlMinimal gitMinimal jq

set -euo pipefail

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
SOURCE_FILE="$SCRIPT_DIR/source.nix"
sourceAttr () { nix-instantiate --eval -E "(import \"$SOURCE_FILE\").$1" | xargs; }

API_URL=https://api.github.com/repos/Mic92/nix-index-database/releases/latest
DL_URL_PREFIX=https://github.com/Mic92/nix-index-database/releases/download
DL_URL_SUFFIX=index-x86_64-linux

RELEASE=$(curl -sS "$API_URL" | jq -r .tag_name)
OLD_RELEASE=$(sourceAttr release)

if [ "$RELEASE" = "$OLD_RELEASE" ]; then
  echo "Already up to date."
else
  HASH=$(nix-prefetch-url "$DL_URL_PREFIX/$RELEASE/$DL_URL_SUFFIX")
  OLD_HASH=$(sourceAttr src.sha256)

  sed -i "s,$OLD_RELEASE,$RELEASE," "$SOURCE_FILE"
  sed -i "s,$OLD_HASH,$HASH," "$SOURCE_FILE"

  git commit "$SOURCE_FILE" -m "home/nix-index-database: $OLD_RELEASE -> $RELEASE"
fi
