{ nixpkgs-unstable }:

_: prev:
with prev; {

  amdvlkUnstable =
    callPackage "${nixpkgs-unstable}/pkgs/development/libraries/amdvlk" { };

}
