{
  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-20.09";
      inputs.nixpkgs.follows = "/nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
    nixpkgs-master.url = "github:NixOS/nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, home-manager, nixpkgs, nixpkgs-master, nixpkgs-unstable }: {
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

        ({ config, ... }:
        let
          pkgsImport = pkgs:
            import pkgs {
              config = config.nixpkgs.config;
              overlays = config.nixpkgs.overlays;
              system = config.nixpkgs.system;
            };
        in {
          config = {
            _module.args = {
              master = pkgsImport nixpkgs-master;
              unstable = pkgsImport nixpkgs-unstable;
            };

            nix.registry = {
              nixpkgs.flake = nixpkgs;
              nixpkgs-unstable.flake = nixpkgs-unstable;
            };

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.samuel.imports = [
              ./common/home.nix
            ];
          };
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
