#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curlMinimal gitMinimal jq nix-prefetch-github
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
GH_BRANCH=master

DL_URL_PREFIX=https://raw.githubusercontent.com/lovesegfault/nix-config
DL_URL_SUFFIX=nix/overlays/linux-lto.nix

API_DATA=$(curl -sS "https://api.github.com/repos/$GH_OWNER/$GH_REPO/commits/$GH_BRANCH")

DATE=$(echo "$API_DATA" | jq -r .commit.committer.date | head -c10)
REV=$(echo "$API_DATA" | jq -r .sha)
OLD_DATE=$(pkgAttr version | tail -c10)
OLD_REV=$(pkgAttr passthru.rev)

if [ "$DATE" = "$OLD_DATE" ]; then
  echo "Not updating version, already $OLD_DATE."
else
  echo "Updating $OLD_DATE -> $DATE in '$FILE'..."

  HASH=$(nix-prefetch-url "$DL_URL_PREFIX/$REV/$DL_URL_SUFFIX")
  OLD_HASH=$(pkgAttr src.outputHash)

  sed -i "$FILE" \
    -e "s $OLD_DATE $DATE " \
    -e "s $OLD_REV $REV " \
    -e "s $OLD_HASH $HASH "

  git commit "$FILE" -m "$ATTR: $OLD_DATE -> $DATE"
fi
