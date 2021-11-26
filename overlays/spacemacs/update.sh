#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curlMinimal gitMinimal jq nix-prefetch-github
set -euo pipefail

pkgAttr () {
  nix eval --impure --raw --expr '
    let flake = __getFlake (toString ../..);
    in with flake.legacyPackages.${__currentSystem}.spacemacs;
  '"$1"
}

cd "$(dirname "$(realpath "$0")")"
FILE=$(realpath ./default.nix)

OWNER=syl20bnr
REPO=spacemacs
API_DATA=$(curl -sS "https://api.github.com/repos/$OWNER/$REPO/commits/develop")

DATE=$(echo "$API_DATA" | jq -r .commit.committer.date | head -c10)
REV=$(echo "$API_DATA" | jq -r .sha)
OLD_DATE=$(pkgAttr version | tail -c10)
OLD_REV=$(pkgAttr src.rev)

if [ "$DATE" = "$OLD_DATE" ]; then
  echo "Not updating version, already $OLD_DATE."
else
  echo "Updating $OLD_DATE -> $DATE in '$FILE'..."

  HASH=$(nix-prefetch-github "$OWNER" "$REPO" --rev "$REV" | jq -r .sha256)
  OLD_HASH=$(pkgAttr src.outputHash)

  sed -i "$FILE" \
    -e "s $OLD_DATE $DATE " \
    -e "s $OLD_REV $REV " \
    -e "s $OLD_HASH $HASH "

  git commit "$FILE" -m "spacemacs: $OLD_DATE -> $DATE"
fi
