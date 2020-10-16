{
  inputs = {
    home-manager.url = "github:nix-community/home-manager/release-20.09";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
    nixpkgs-master.url = "github:NixOS/nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";
  };

  outputs = { self, nixpkgs, nixpkgs-master, nixpkgs-unstable, home-manager }: {
    nixosConfigurations = {

      HPx = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hosts/HPx/configuration.nix
          ./hosts/HPx/hardware.nix
          home-manager.nixosModules.home-manager

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

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.samuel.imports = [
              ./common/home.nix
              ./hosts/HPx/home.nix
            ];
          })
        ];
      };

      R3600 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hosts/HPx/configuration.nix
          ./hosts/HPx/hardware.nix
          home-manager.nixosModules.home-manager
        ];
      };

    };
  };
}
