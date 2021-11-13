#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curlMinimal gitMinimal jq nix-prefetch-github
set -euo pipefail

cd "$(dirname "$(realpath "$0")")"

pkgAttr () {
  nix eval --impure --raw --expr '
    let flake = __getFlake (toString ../..);
    in with flake.legacyPackages.${__currentSystem}.spacemacs;
  '"$1"
}

OWNER="syl20bnr"
REPO="spacemacs"

API_DATA=$(curl -sS "https://api.github.com/repos/$OWNER/$REPO/commits/develop")
REV=$(echo "$API_DATA" | jq -r .sha)
DATE=$(echo "$API_DATA" | jq -r .commit.committer.date | head -c10)

OLD_REV=$(pkgAttr rev)
OLD_DATE=$(pkgAttr version | tail -c10)
OLD_HASH=$(pkgAttr sha256)

if [ "$DATE" = "$OLD_DATE" ]; then
    echo "Already up to date."
else
    HASH=$(nix-prefetch-github "$OWNER" "$REPO" --rev "$REV" | jq -r .sha256)
    sed -i "s,$OLD_REV,$REV," ./default.nix
    sed -i "s,$OLD_DATE,$DATE," ./default.nix
    sed -i "s,$OLD_HASH,$HASH," ./default.nix

    git commit ./default.nix -m "spacemacs: $OLD_DATE -> $DATE"
fi
