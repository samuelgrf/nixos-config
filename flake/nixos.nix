{ home-manager, self, ... }@flakes:
with self; {

  nixosModules = {
    default.imports = [
      home-manager.nixosModule
      nixosModules.moduleArgs
      ../config/nixos/chromium/bookmarks.nix
      ../config/nixos/chromium/policies.nix
      ../config/nixos/firewall.nix
      ../config/nixos/kernel.nix
      ../config/nixos/misc.nix
      ../config/nixos/nix.nix
      ../config/nixos/packages.nix
      ../config/nixos/printing+scanning.nix
      ../config/nixos/services.nix
      ../config/nixos/terminal.nix
      ../config/nixos/user.nix

      ({ system, ... }: {
        nixpkgs.pkgs = legacyPackages.${system};

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit lib; };
          users.${userData.name} =
            homeManagerModules."${userData.name}@default";
        };
      })
    ];

    amethyst.imports = [
      ../config/machines/amethyst/nixos.nix
      ../config/machines/amethyst/nixos-generated.nix
      {
        home-manager.users.${userData.name} =
          homeManagerModules."${userData.name}@amethyst";
      }
    ];

    beryl.imports = [
      ../config/machines/beryl/nixos.nix
      ../config/machines/beryl/nixos-generated.nix
      {
        home-manager.users.${userData.name} =
          homeManagerModules."${userData.name}@beryl";
      }
    ];

    moduleArgs = { config, ... }:
      let
        inherit (config.nixpkgs) system;
        pkgs = legacyPackages.${system};
        pkgs-emacs = legacyPackages_emacs.${system};
        pkgs-master = legacyPackages_master.${system};
        pkgs-unstable = legacyPackages_unstable.${system};
      in {
        _module.args = {
          inherit flakes pkgs-emacs pkgs-master pkgs-unstable system userData;
          inherit (pkgs) pkgsi686Linux;
          homeConfig = config.home-manager.users.${userData.name};
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
