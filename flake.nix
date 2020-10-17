{
  inputs = {
    home-manager.url = "github:nix-community/home-manager/release-20.09";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
    nixpkgs-master.url = "github:NixOS/nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";
  };

  outputs = { self, nixpkgs, nixpkgs-master, nixpkgs-unstable, home-manager }: {
    nixosConfigurations =
    let
      defaultModules = [
        home-manager.nixosModules.home-manager
        ./modules/g810-led.nix
        ./common/fonts.nix
        ./common/general.nix
        ./common/hardware.nix
        ./common/kernel.nix
        ./common/misc.nix
        ./common/networking.nix
        ./common/packages.nix
        ./common/printing.nix
        ./common/services.nix
        ./common/terminal.nix
        ./overlays

        ({ config, ... }: {
          nixpkgs.overlays = [
            (final: prev: {

              pkgsImport = pkgs:
                import pkgs {
                  config = config.nixpkgs.config;
                  system = config.nixpkgs.system;
                };

              master = final.pkgsImport nixpkgs-master;
              unstable = final.pkgsImport nixpkgs-unstable;
            })
          ];

          nix.registry = {
            nixpkgs.flake = nixpkgs;
            nixpkgs-master.flake = nixpkgs-master;
            nixpkgs-unstable.flake = nixpkgs-unstable;
          };

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.samuel.imports = [
            ./common/home.nix
          ];
        })
      ];
    in
    {
      HPx = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/HPx/configuration.nix
          ./hosts/HPx/hardware.nix

          ({ ... }: {
            home-manager.users.samuel.imports = [
              ./hosts/HPx/home.nix
            ];
          })
        ] ++ defaultModules;
      };

      R3600 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/R3600/configuration.nix
          ./hosts/R3600/hardware.nix
        ] ++ defaultModules;
      };
    };
  };
}
