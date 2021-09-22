{

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-21.05";
      inputs.nixpkgs.follows = "/nixpkgs";
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

      # The NixOS release to be compatible with for stateful data such as databases.
      stateVersion = "21.05";

      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;
      lib' = import ./lib { inherit lib pkgs; };

      checks.${system}.pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          nixfmt = {
            enable = true;
            excludes = [ ".*/source.nix" "machines/.*/hardware-generated.nix" ];
          };
          nix-linter = {
            enable = true;
            excludes = [ "machines/.*/hardware-generated.nix" ];
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
          main/general.nix
          main/kernel.nix
          main/misc.nix
          main/packages.nix
          main/printing-scanning.nix
          main/services.nix
          main/terminal.nix

          ({ config, lib, pkgs, pkgs-master, ... }:
            let
              pkgsImport = pkgs:
                import pkgs (removeAttrs config.nixpkgs [ "localSystem" ]);

              _module.args = pkgsImport nixpkgs // {
                binPaths = import main/binpaths.nix {
                  inherit config lib pkgs pkgs-master;
                };
                inherit flakes;
                pkgs-master = pkgsImport nixpkgs-master;
                pkgs-unstable = pkgsImport nixpkgs-unstable;
              };
            in {
              inherit _module;

              nix = {
                package = pkgs.nixUnstable;

                extraOptions = ''
                  experimental-features = nix-command flakes
                  flake-registry = /etc/nix/registry.json
                '';

                registry = __mapAttrs (id: flake: {
                  from = {
                    type = "indirect";
                    inherit id;
                  };
                  inherit flake;
                }) flakes;

                sshServe = {
                  enable = true;
                  keys = config.users.users.root.openssh.authorizedKeys.keys;
                };
              };

              environment.variables.NIX_PATH = with lib;
                mkForce (concatStringsSep ":"
                  (mapAttrsToList (name: path: "${name}=${path}") flakes));

              nixpkgs.overlays = import ./overlays;

              system = { inherit stateVersion; };

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs.lib =
                  import "${home-manager}/modules/lib/stdlib-extended.nix" lib;
                users.samuel.imports = [
                  home/modules/kde.nix
                  home/default-applications.nix
                  home/git.nix
                  home/kde
                  home/misc.nix
                  home/mpv.nix
                  home/nix-index-database
                  {
                    inherit _module;
                    home = { inherit stateVersion; };
                  }
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

      specialArgs.lib = lib // lib';

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
