{ home-manager, nixpkgs, ... }: {

  lib = import "${home-manager}/modules/lib/stdlib-extended.nix" nixpkgs.lib
    // import ../lib { inherit (nixpkgs) lib; };
}
