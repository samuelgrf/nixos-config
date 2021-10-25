flakes:
with flakes;

flake-utils.lib.eachDefaultSystem (system: rec {

  pkgsImport = pkgs:
    import pkgs {
      inherit system;
      config = import ../main/nixpkgs.nix { pkgs = legacyPackages; };
      overlays = __attrValues self.overlays;
    };

  legacyPackages = pkgsImport nixpkgs;
  legacyPackages_master = pkgsImport nixpkgs-master;
  legacyPackages_unstable = pkgsImport nixpkgs-unstable;
})
