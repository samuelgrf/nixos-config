{
  inputs = {
    flake-compat.url = "github:edolstra/flake-compat";
    flake-utils.url = "github:numtide/flake-utils";
    # TODO Get from `release-21.11` channel when available.
    home-manager.url = "github:nix-community/home-manager";
    # TODO Get from `nixos-21.11` channel when available.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    flake-compat.flake = false;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    pre-commit-hooks.inputs.flake-utils.follows = "flake-utils";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
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
