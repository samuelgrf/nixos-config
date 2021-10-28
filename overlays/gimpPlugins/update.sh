#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nix-update

nix-update --commit -f ./nix-update-compat 'gimpPlugins.bimp'
