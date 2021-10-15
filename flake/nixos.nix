flakes:
with flakes; rec {

  lib = nixpkgs.lib // import ../lib { inherit (nixpkgs) lib; };

  overlays = import ../overlays;

  nixosModules = {
    default.imports = [
      home-manager.nixosModule
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

      ({ config, ... }:
        with self;
        let
          pkgs = legacyPackages.${config.nixpkgs.system};
          pkgs-master = legacyPackages_master.${config.nixpkgs.system};
          pkgs-unstable = legacyPackages_unstable.${config.nixpkgs.system};

          _module.args = pkgs // {
            inherit flakes pkgs pkgs-master pkgs-unstable;
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
            extraSpecialArgs.lib = lib
              // import "${home-manager}/modules/lib/stdlib-extended.nix" lib;
            users.samuel.imports = [
              ../home/modules/kde.nix
              ../home/default-applications.nix
              ../home/git.nix
              ../home/kde
              ../home/misc.nix
              ../home/mpv.nix
              ../home/nix-index-database
              { inherit _module; }
            ];
          };
        })
    ];

    amethyst.imports = [
      ../machines/amethyst/configuration.nix
      ../machines/amethyst/hardware-generated.nix
      { home-manager.users.samuel.imports = [ ../machines/amethyst/home.nix ]; }
    ];

    beryl.imports = [
      ../machines/beryl/configuration.nix
      ../machines/beryl/hardware-generated.nix
    ];
  };

  specialArgs = { inherit lib; };

  nixosConfigurations = {
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
