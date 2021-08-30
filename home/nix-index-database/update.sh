#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curlMinimal jq

set -euo pipefail

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
SOURCE_FILE="$SCRIPT_DIR/source.nix"
sourceAttr () { nix-instantiate --eval -E "(import \"$SOURCE_FILE\").$1" | xargs; }

API_DATA=$(curl -sS https://api.github.com/repos/Mic92/nix-index-database/releases/latest)
DL_URL=$(echo "$API_DATA" | jq -r '.assets[0].browser_download_url')
OLD_DL_URL=$(sourceAttr url)

if [ "$DL_URL" = "$OLD_DL_URL" ]; then
  echo "Already up to date."
else
  HASH=$(nix-prefetch-url "$DL_URL")
  OLD_HASH=$(sourceAttr sha256)
  sed -i "s,$OLD_DL_URL,$DL_URL," "$SOURCE_FILE"
  sed -i "s,$OLD_HASH,$HASH," "$SOURCE_FILE"
fi
