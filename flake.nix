{

  # Remember to read the release notes before updating!
  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-21.05";
      inputs.nixpkgs.follows = "/nixpkgs";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-utils.url = "github:/numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
    nixpkgs-master.url = "github:NixOS/nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.flake-utils.follows = "/flake-utils";
      inputs.nixpkgs.follows = "/nixpkgs";
    };
  };

  outputs = flakes:
    with flakes.nixpkgs.lib;
    foldl' recursiveUpdate { } (map (file: import file flakes) [
      flake/checks.nix
      flake/pkgs.nix
      flake/nixos.nix
    ]);

}
