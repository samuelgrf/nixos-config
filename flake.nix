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

  outputs = { self, home-manager, nixpkgs, nixpkgs-master, nixpkgs-unstable } @inputs: {
    nixosConfigurations =
    let
      defaultModules = [
        home-manager.nixosModules.home-manager
        ./modules/g810-led.nix
        ./main/general.nix
        ./main/hardware.nix
        ./main/kernel.nix
        ./main/misc.nix
        ./main/networking.nix
        ./main/packages.nix
        ./main/printing.nix
        ./main/services.nix
        ./main/terminal.nix

        ({ config, lib, ... }:
        {
          config = {
            _module.args = let
              pkgsImport = pkgs:
                import pkgs { inherit (config.nixpkgs) config overlays system; };
            in {
              flakes = inputs;
              lib' = lib // import ./lib { inherit lib; };
              master = pkgsImport nixpkgs-master;
              unstable = pkgsImport nixpkgs-unstable;
            };

            nix.registry = lib.mapAttrs (id: flake: {
              from = { type = "indirect"; inherit id; }; inherit flake;
            }) inputs;

            nixpkgs.overlays = [
              (import ./overlays)
            ];

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.samuel.imports = [
                ./home/modules/kde.nix
                ./home/default.nix
                ./home/kde.nix
              ];
            };
          };
        })
      ];
    in
    {
      HPx = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machines/HPx/configuration.nix
          ./machines/HPx/hardware.nix
          { home-manager.users.samuel.imports = [ ./machines/HPx/home.nix ]; }
        ] ++ defaultModules;
      };

      R3600 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machines/R3600/configuration.nix
          ./machines/R3600/hardware.nix
        ] ++ defaultModules;
      };
    };
  };
}
