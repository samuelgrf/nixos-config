flakes:
with flakes; rec {

  userData = import ../userdata.nix;

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
          pkgs = self.legacyPackages.${system};
          pkgs-master = self.legacyPackages_master.${system};
          pkgs-unstable = self.legacyPackages_unstable.${system};

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
              self.homeConfigurations."${userData.name}@default";
          };
        })
    ];

    amethyst.imports = [
      ../machines/amethyst/configuration.nix
      ../machines/amethyst/hardware-generated.nix
      {
        home-manager.users.${userData.name} =
          self.homeConfigurations."${userData.name}@amethyst";
      }
    ];

    beryl.imports = [
      ../machines/beryl/configuration.nix
      ../machines/beryl/hardware-generated.nix
      {
        home-manager.users.${userData.name} =
          self.homeConfigurations."${userData.name}@beryl";
      }
    ];
  };

  nixosConfigurations = let specialArgs = { inherit (self) lib; };
  in {
    amethyst = self.lib.nixosSystem {
      inherit specialArgs;
      system = "x86_64-linux";
      modules = with nixosModules; [ default amethyst ];
    };

    beryl = self.lib.nixosSystem {
      inherit specialArgs;
      system = "x86_64-linux";
      modules = with nixosModules; [ default beryl ];
    };
  };
}
