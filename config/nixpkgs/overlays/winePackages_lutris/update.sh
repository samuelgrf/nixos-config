#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nix-update

cd "$(dirname "$(realpath "$0")")"
nix-update --commit -f ../nix-update-compat -vr 'lutris-(.*)' 'winePackages_lutris.latest'
