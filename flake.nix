{
  inputs = {
    home-manager.url = "github:nix-community/home-manager/release-20.09";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
  };

  outputs = { self, nixpkgs, nixos-unstable, home-manager }: {
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
                unstable = import nixos-unstable {
                  config = config.nixpkgs.config;
                  localSystem = config.nixpkgs.localSystem;
                  crossSystem = config.nixpkgs.crossSystem;
                };
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
