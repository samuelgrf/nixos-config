#!/usr/bin/env bash

STABLE_REV="$(git ls-remote https://github.com/nixos/nixpkgs-channels nixos-20.03 | cut -f 1)"
UNSTABLE_REV="$(git ls-remote https://github.com/nixos/nixpkgs-channels nixos-unstable | cut -f 1)"
HOME_MANAGER_REV="$(git ls-remote https://github.com/rycee/home-manager.git master | cut -f 1)"

echo "{ config, lib, ... }:

with lib;

{
  options.channels = {
    stable = mkOption {
      type = types.attrs;
      default = builtins.fetchGit {
        name = \"nixos-20.03\";
        url = https://github.com/nixos/nixpkgs-channels.git;
        ref = \"refs/heads/nixos-20.03\";
        rev = \""$STABLE_REV"\";
      };
    };

    unstable = mkOption {
      type = types.attrs;
      default = builtins.fetchGit {
        name = \"nixos-unstable\";
        url = https://github.com/nixos/nixpkgs-channels.git;
        ref = \"refs/heads/nixos-unstable\";
        rev = \""$UNSTABLE_REV"\";
      };
    };

    home-manager = mkOption {
      type = types.attrs;
      default = builtins.fetchGit {
        name = \"home-manager\";
        url = https://github.com/rycee/home-manager.git;
        ref = \"refs/heads/master\";
        rev = \""$HOME_MANAGER_REV"\";
      };
    };
  };

  # https://discourse.nixos.org/t/variables-for-a-system/2342/12
  config._module.args.channels = config.channels;
}" > $(dirname "$0")/channels.nix
