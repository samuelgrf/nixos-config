_: prev: {

  # Aliases referenced in nixpkgs,
  # neeeded when setting `nixpkgs.config.allowAliases = false;`.
  # TODO Remove when:
  # https://github.com/NixOS/nixpkgs/pull/116351 &
  # https://github.com/NixOS/nixpkgs/pull/116352
  # are merged and available.
  breeze-plymouth =
    prev.plasma5.breeze-plymouth; # Referenced at nixos/modules/system/boot/plymouth.nix:12:25
  xlibs = prev.xorg; # Referenced at pkgs/games/steam/fhsenv.nix:146:5

}
