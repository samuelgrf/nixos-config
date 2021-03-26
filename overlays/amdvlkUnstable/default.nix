{ flakes }:

_: prev:
with prev; {

  amdvlkUnstable =
    callPackage "${flakes.nixpkgs-unstable}/pkgs/development/libraries/amdvlk"
    { };

}
