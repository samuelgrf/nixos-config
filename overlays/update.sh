#! /usr/bin/env bash
set -euo pipefail

cd "$(dirname "$(realpath "$0")")"
./gimpPlugins/update.sh &
./nix-index-database/update.sh &
./spacemacs/update.sh
wait
