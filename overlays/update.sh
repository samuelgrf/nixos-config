#! /usr/bin/env bash
set -eu

OVERLAY_DIR=$(dirname "$(readlink -f "$0")")
FLAKE_DIR="$OVERLAY_DIR/.."

cd "$FLAKE_DIR"
"overlays/gimpPlugins/update.sh"
"overlays/nix-index-database/update.sh"
