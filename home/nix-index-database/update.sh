#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curlMinimal jq
set -euo pipefail

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

API_DATA=$(curl https://api.github.com/repos/Mic92/nix-index-database/releases/latest)
RELEASE_TAG=$(echo "$API_DATA" | jq -r .tag_name)

DL_URL="https://github.com/Mic92/nix-index-database/releases/download/$RELEASE_TAG/files"
HASH=$(nix-prefetch-url "$DL_URL")

echo "{
  url = \"$DL_URL\";
  sha256 = \"$HASH\";
}" > "$SCRIPT_DIR/source.nix"
