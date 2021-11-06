{ self, ... }@flakes:
with self; {

  nixosModules = {
    default.imports = [
      nixosModules.moduleArgs
      # TODO Replace with `home-manager.nixosModule` on NixOS 21.11.
      ../nixos/modules/home-manager.nix
      ../nixos/chromium.nix
      ../nixos/firewall.nix
      ../nixos/kernel.nix
      ../nixos/misc.nix
      ../nixos/nix.nix
      ../nixos/packages.nix
      ../nixos/printing-scanning.nix
      ../nixos/services.nix
      ../nixos/terminal.nix
      ../nixos/user.nix

      ({ system, ... }: {
        nixpkgs.pkgs = legacyPackages.${system};

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "bak";
          extraSpecialArgs = { inherit lib; };
          users.${userData.name} =
            homeManagerModules."${userData.name}@default";
        };
      })
    ];

    amethyst.imports = [
      ../machines/amethyst/nixos.nix
      ../machines/amethyst/nixos-generated.nix
      {
        home-manager.users.${userData.name} =
          homeManagerModules."${userData.name}@amethyst";
      }
    ];

    beryl.imports = [
      ../machines/beryl/nixos.nix
      ../machines/beryl/nixos-generated.nix
      {
        home-manager.users.${userData.name} =
          homeManagerModules."${userData.name}@beryl";
      }
    ];

    moduleArgs = { config, ... }:
      let
        inherit (config.nixpkgs) system;
        pkgs = legacyPackages.${system};
        pkgs-master = legacyPackages_master.${system};
        pkgs-unstable = legacyPackages_unstable.${system};
      in {
        _module.args = pkgs // {
          inherit flakes pkgs pkgs-master pkgs-unstable system userData;
          binPaths = import ../nixos/binpaths.nix {
            inherit config lib pkgs pkgs-unstable;
          };
        };
      };
  };

  nixosConfigurations = let specialArgs = { inherit lib; };
  in {
    amethyst = lib.nixosSystem {
      inherit specialArgs;
      system = "x86_64-linux";
      modules = with nixosModules; [ default amethyst ];
    };

    beryl = lib.nixosSystem {
      inherit specialArgs;
      system = "x86_64-linux";
      modules = with nixosModules; [ default beryl ];
    };
  };
}
