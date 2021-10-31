{ self, ... }@flakes:
with self; {

  nixosModules = {
    default.imports = [
      # TODO Replace with `home-manager.nixosModule` on NixOS 21.11.
      ../modules/home-manager.nix
      ../main/chromium.nix
      ../main/firewall.nix
      ../main/kernel.nix
      ../main/misc.nix
      ../main/nix.nix
      ../main/packages.nix
      ../main/printing-scanning.nix
      ../main/services.nix
      ../main/terminal.nix
      ../main/user.nix

      ({ config, lib, ... }:
        let
          inherit (config.nixpkgs) system;
          pkgs = legacyPackages.${system};
          pkgs-master = legacyPackages_master.${system};
          pkgs-unstable = legacyPackages_unstable.${system};

          _module.args = pkgs // {
            inherit flakes pkgs pkgs-master pkgs-unstable system userData;
            binPaths = import ../main/binpaths.nix {
              inherit config lib pkgs pkgs-unstable;
            };
          };
        in {
          inherit _module;

          nixpkgs = { inherit pkgs; };

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "bak";
            extraSpecialArgs = { inherit lib; };
            sharedModules = [{ inherit _module; }];
            users.${userData.name} =
              homeConfigurations."${userData.name}@default";
          };
        })
    ];

    amethyst.imports = [
      ../machines/amethyst/configuration.nix
      ../machines/amethyst/hardware-generated.nix
      {
        home-manager.users.${userData.name} =
          homeManagerModules."${userData.name}@amethyst";
      }
    ];

    beryl.imports = [
      ../machines/beryl/configuration.nix
      ../machines/beryl/hardware-generated.nix
      {
        home-manager.users.${userData.name} =
          homeManagerModules."${userData.name}@beryl";
      }
    ];
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
