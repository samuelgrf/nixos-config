{

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-20.09";
      inputs.nixpkgs.follows = "/nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
    nixpkgs-master.url = "github:NixOS/nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "/nixpkgs";
    };
  };

  outputs = { home-manager, nixpkgs, nixpkgs-master, nixpkgs-unstable
    , pre-commit-hooks, self }@flakes:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;
    in {

      checks.${system}.pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          nixfmt = {
            enable = true;
            excludes = [ "machines/.*/hardware-generated.nix" ];
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
        inherit (self.checks.${system}.pre-commit-check) shellHook;
      };

      nixosConfigurations = let

        # The NixOS release to be compatible with for stateful data such as databases.
        stateVersion = "20.09";

        specialArgs.lib = lib // import ./lib { inherit lib pkgs; };

        defaultModules = [
          home-manager.nixosModules.home-manager
          main/chromium.nix
          main/general.nix
          main/kernel.nix
          main/misc.nix
          main/packages.nix
          main/printing-scanning.nix
          main/services.nix
          main/terminal.nix

          ({ config, pkgs, pkgs-unstable, ... }:
            let
              pkgsImport = pkgs:
                import pkgs (removeAttrs config.nixpkgs [ "localSystem" ]);

              _module.args = pkgsImport nixpkgs // {
                binPaths = import main/binpaths.nix {
                  inherit config pkgs pkgs-unstable;
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

                registry = lib.mapAttrs (id: flake: {
                  from = {
                    type = "indirect";
                    inherit id;
                  };
                  inherit flake;
                }) flakes;
              };

              nixpkgs.overlays = import ./overlays { inherit flakes; };

              system = { inherit stateVersion; };

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.samuel.imports = [
                  home/modules/kde.nix
                  home/default-applications.nix
                  home/git.nix
                  home/kde.nix
                  home/mpv.nix
                  home/proton.nix
                  {
                    inherit _module;
                    home = { inherit stateVersion; };
                  }
                ];
              };

              # TODO Remove on 21.05.
              # Import modules from nixpkgs-unstable.
              disabledModules = [ "programs/steam.nix" ];
              imports = [
                "${flakes.nixpkgs-unstable}/nixos/modules/programs/partition-manager.nix"
                "${flakes.nixpkgs-unstable}/nixos/modules/programs/steam.nix"
              ];
            })
        ];
      in {

        amethyst = lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            machines/amethyst/configuration.nix
            machines/amethyst/hardware-generated.nix
            {
              home-manager.users.samuel.imports =
                [ machines/amethyst/home.nix ];
            }
          ] ++ defaultModules;
        };

        beryl = lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            machines/beryl/configuration.nix
            machines/beryl/hardware-generated.nix
          ] ++ defaultModules;
        };

      };
    };

}
