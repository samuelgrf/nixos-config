#! /usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
./gimpPlugins/update.sh &
./nix-index-database/update.sh &
wait
