#! /usr/bin/env bash
set -euo pipefail

cd "$(dirname "$(realpath "$0")")"
./dxvk-async/update.sh
./gimpPlugins/update.sh
./linux-lto/update.sh
./nix-index-database/update.sh
./wine-lutris/update.sh
./yt-dlp/update.sh
