{ flakes }:

_: prev: {

  amdvlkUnstable = prev.callPackage
    "${flakes.nixpkgs-unstable}/pkgs/development/libraries/amdvlk" { };

}
