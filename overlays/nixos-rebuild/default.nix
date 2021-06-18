{ nixpkgs-master }:

_: prev:
with prev; {

  nixos-rebuild = nixos-rebuild.overrideAttrs (_: {
    src =
      "${nixpkgs-master}/pkgs/os-specific/linux/nixos-rebuild/nixos-rebuild.sh";
  });

}
