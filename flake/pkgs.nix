{ emacs-overlay, flake-utils, nixpkgs, nixpkgs-emacs, nixpkgs-master
, nixpkgs-unstable, self, ... }:
with self;
({

  pkgsImport = { pkgs, system, ... }@args:
    import pkgs {
      inherit system;
      config = args.config or (import ../config/nixpkgs {
        pkgs = legacyPackages.${system};
      });
      overlays = args.overlays or ([
        (_final: _prev: { PREV = import pkgs { inherit system; }; })
        emacs-overlay.overlay
      ] ++ __attrValues overlays);
    };

  overlays = import ../config/nixpkgs/overlays { inherit lib; };
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
