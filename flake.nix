{
  inputs = {
    emacs-overlay.url =
      "github:nix-community/emacs-overlay/1f591ff5ed96777035f5f438bb77224d9a1cdf5d";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager/release-21.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    nixpkgs-emacs.url =
      "github:NixOS/nixpkgs/8a053bc2255659c5ca52706b9e12e76a8f50dbdd";
    nixpkgs-master.url = "github:NixOS/nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    spacemacs.url = "github:syl20bnr/spacemacs/develop";

    flake-compat.flake = false;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    pre-commit-hooks.inputs.flake-utils.follows = "flake-utils";
    spacemacs.flake = false;
  };

  outputs = flakes:
    with flakes.nixpkgs.lib;
    foldl' recursiveUpdate { } (map (file: import file flakes) [
      flake/checks.nix
      flake/home.nix
      flake/lib.nix
      flake/nixos.nix
      flake/pkgs.nix
      flake/userdata.nix
    ]);
}
