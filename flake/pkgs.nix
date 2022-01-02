{ emacs-overlay, flake-utils, nixpkgs, nixpkgs-emacs, nixpkgs-master
, nixpkgs-unstable, self, ... }:
with self;
({

  pkgsImport = { pkgs, system, ... }@args:
    import pkgs {
      inherit system;
      config = args.config or (import ../config/shared/nixpkgs.nix {
        pkgs = legacyPackages.${system};
      });
      overlays = [ emacs-overlay.overlay ] ++ __attrValues overlays;
    };

  overlays = import ../overlays { inherit lib; };
}

  // flake-utils.lib.eachDefaultSystem (system: {

    legacyPackages = pkgsImport {
      inherit system;
      pkgs = nixpkgs;
    };
    legacyPackages_emacs = pkgsImport {
      inherit system;
      pkgs = nixpkgs-emacs;
    };
    legacyPackages_master = pkgsImport {
      inherit system;
      pkgs = nixpkgs-master;
    };
    legacyPackages_unstable = pkgsImport {
      inherit system;
      pkgs = nixpkgs-unstable;
    };
  }))
