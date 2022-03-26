#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curlMinimal gitMinimal jq
set -euo pipefail

cd "$(dirname "$(realpath "$0")")"

pkgAttr () {
    nix eval --impure --raw --expr '
    let flake = __getFlake (toString ../../../..);
    in with flake.legacyPackages.${__currentSystem}.'"$ATTR; $1"
}

FILE=$(realpath ./default.nix)
ATTR=linux-lto-overlay

GH_OWNER=lovesegfault
GH_REPO=nix-config
GH_PATH=nix/overlays/linux-lto.nix

API_DATA=$(curl -sS "https://api.github.com/repos/$GH_OWNER/$GH_REPO/commits?path=$GH_PATH&per_page=1")

DATE=$(echo "$API_DATA" | jq -r '.[].commit.committer.date' | head -c10)
REV=$(echo "$API_DATA" | jq -r '.[].sha')
OLD_DATE=$(pkgAttr version | tail -c10)
OLD_REV=$(pkgAttr passthru.rev)

if [ "$REV" = "$OLD_REV" ]; then
  echo "Not updating version, already $OLD_DATE."
else
  echo "Updating $OLD_DATE -> $DATE in '$FILE'..."

  HASH=$(nix-prefetch-url "https://raw.githubusercontent.com/$GH_OWNER/$GH_REPO/$REV/$GH_PATH")
  OLD_HASH=$(pkgAttr src.outputHash)

  sed -i "$FILE" \
    -e "s $OLD_DATE $DATE " \
    -e "s $OLD_REV $REV " \
    -e "s $OLD_HASH $HASH "

  git commit "$FILE" -m "$ATTR: $OLD_DATE -> $DATE"
fi
