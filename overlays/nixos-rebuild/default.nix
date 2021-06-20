{ nixpkgs-unstable }:

_: prev:
with prev; {

  nixos-rebuild = nixos-rebuild.overrideAttrs (_: {
    src =
      "${nixpkgs-unstable}/pkgs/os-specific/linux/nixos-rebuild/nixos-rebuild.sh";
  });

}
