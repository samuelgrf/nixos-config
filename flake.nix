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

  outputs = { flake-utils, home-manager, nixpkgs, nixpkgs-master
    , nixpkgs-unstable, pre-commit-hooks, self, ... }@flakes:

    flake-utils.lib.eachDefaultSystem (system: rec {
      pkgsImport = pkgs:
        import pkgs {
          inherit system;
          config = import ./main/nixpkgs-config.nix { pkgs = legacyPackages; };
          overlays = __attrValues self.overlays;
        };

      legacyPackages = pkgsImport nixpkgs;
      legacyPackages_master = pkgsImport nixpkgs-master;
      legacyPackages_unstable = pkgsImport nixpkgs-unstable;

      checks.pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          nixfmt = {
            enable = true;
            excludes =
              [ "machines/.*/hardware-generated.nix" "overlays/default.nix" ];
          };
          nix-linter = {
            enable = true;
            excludes =
              [ "machines/.*/hardware-generated.nix" "overlays/default.nix" ];
          };
        };
        settings.nix-linter.checks =
          [ "BetaReduction" "EmptyVariadicParamSet" "UnneededAntiquote" ];
      };

      devShell = legacyPackages.mkShell {
        shellHook = checks.pre-commit-check.shellHook + ''
          if [ -L .pre-commit-config.yaml ]; then >/dev/null \
            nix-store \
              --add-root .pre-commit-config.yaml \
              -r .pre-commit-config.yaml
          fi
        '';
      };
    })

    // rec {
      lib = nixpkgs.lib // import ./lib { inherit (nixpkgs) lib; };

      overlays = import ./overlays;

      nixosModules = {
        default.imports = [
          home-manager.nixosModule
          main/chromium.nix
          main/firewall.nix
          main/kernel.nix
          main/misc.nix
          main/nix.nix
          main/packages.nix
          main/printing-scanning.nix
          main/services.nix
          main/terminal.nix
          main/user.nix

          ({ config, ... }:
            with self;
            let
              pkgs = legacyPackages.${config.nixpkgs.system};
              pkgs-master = legacyPackages_master.${config.nixpkgs.system};
              pkgs-unstable = legacyPackages_unstable.${config.nixpkgs.system};

              _module.args = pkgs // {
                inherit flakes pkgs pkgs-master pkgs-unstable;
                binPaths = import main/binpaths.nix {
                  inherit config lib pkgs pkgs-unstable;
                };
              };
            in {
              inherit _module;

              nixpkgs = { inherit pkgs; };

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs.lib = lib
                  // import "${home-manager}/modules/lib/stdlib-extended.nix"
                  lib;
                users.samuel.imports = [
                  home/modules/kde.nix
                  home/default-applications.nix
                  home/git.nix
                  home/kde
                  home/misc.nix
                  home/mpv.nix
                  home/nix-index-database
                  { inherit _module; }
                ];
              };
            })
        ];

        amethyst.imports = [
          machines/amethyst/configuration.nix
          machines/amethyst/hardware-generated.nix
          {
            home-manager.users.samuel.imports = [ machines/amethyst/home.nix ];
          }
        ];

        beryl.imports = [
          machines/beryl/configuration.nix
          machines/beryl/hardware-generated.nix
        ];
      };

      specialArgs = { inherit (self) lib; };

      nixosConfigurations = {
        amethyst = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = with nixosModules; [ default amethyst ];
        };

        beryl = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = with nixosModules; [ default beryl ];
        };
      };
    };

}
