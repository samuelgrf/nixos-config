# TODO Remove on NixOS 21.11.
{ config, lib, pkgs, utils, ... }:

with lib;
with (import ../../../flake-compat.nix).inputs;

recursiveUpdate
(import "${home-manager}/nixos" { inherit config lib pkgs utils; }) {

  options.home-manager.sharedModules.type = with types;
    listOf (mkOptionType {
      name = "submodule";
      inherit (submodule { }) check;
      merge = lib.options.mergeOneOption;
      description = "Home Manager modules";
    });
}
