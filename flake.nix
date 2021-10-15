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
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
    nixpkgs-master.url = "github:NixOS/nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "/nixpkgs";
    };
  };

  outputs = { home-manager, nixpkgs, nixpkgs-master, nixpkgs-unstable
    , pre-commit-hooks, ... }@flakes: rec {

      system = "x86_64-linux";

      lib = nixpkgs.lib // import ./lib {
        inherit pkgs;
        lib = nixpkgs.lib;
      };

      overlays = import ./overlays { inherit pkgs-unstable; };

      pkgsImport = pkgs:
        import pkgs {
          inherit system;
          config = import ./main/nixpkgs-config.nix { inherit pkgs; };
          overlays = __attrValues overlays;
        };

      pkgs = pkgsImport nixpkgs;
      pkgs-master = pkgsImport nixpkgs-master;
      pkgs-unstable = pkgsImport nixpkgs-unstable;
      legacyPackages.${system} = pkgs;

      checks.${system}.pre-commit-check = pre-commit-hooks.lib.${system}.run {
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

      devShell.${system} = pkgs.mkShell {
        shellHook = checks.${system}.pre-commit-check.shellHook + ''
          if [ -L .pre-commit-config.yaml ]; then >/dev/null \
            nix-store \
              --add-root .pre-commit-config.yaml \
              -r .pre-commit-config.yaml
          fi
        '';
      };

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
            let
              _module.args = pkgs // {
                inherit flakes pkgs-master pkgs-unstable;
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

      specialArgs = { inherit lib; };

      nixosConfigurations = {
        amethyst = lib.nixosSystem {
          inherit system specialArgs;
          modules = with nixosModules; [ default amethyst ];
        };

        beryl = lib.nixosSystem {
          inherit system specialArgs;
          modules = with nixosModules; [ default beryl ];
        };
      };

    };

}
