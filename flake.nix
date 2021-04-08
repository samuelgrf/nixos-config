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

  outputs =
    { home-manager, nixpkgs, nixpkgs-master, nixpkgs-unstable, self }@flakes: {
      nixosConfigurations = let

        # The NixOS release to be compatible with for stateful data such as databases.
        stateVersion = "20.09";

        lib = nixpkgs.lib;
        specialArgs.lib = lib // import ./lib { inherit lib; };

        defaultModules = [
          home-manager.nixosModules.home-manager
          main/general.nix
          main/hardware.nix
          main/kernel.nix
          main/misc.nix
          main/networking.nix
          main/packages.nix
          main/printing.nix
          main/scanning.nix
          main/services.nix
          main/terminal.nix

          ({ config, ... }:
            let
              pkgsImport = pkgs:
                import pkgs (removeAttrs config.nixpkgs [ "localSystem" ]);
            in {
              _module.args = pkgsImport nixpkgs // {
                inherit flakes;
                master = pkgsImport nixpkgs-master;
                unstable = pkgsImport nixpkgs-unstable;
              };

              nix.registry = lib.mapAttrs (id: flake: {
                from = {
                  type = "indirect";
                  inherit id;
                };
                inherit flake;
              }) flakes;

              nixpkgs.overlays = import ./overlays { inherit config flakes; };

              system = { inherit stateVersion; };

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.samuel.imports = [
                  { _module.args = pkgsImport nixpkgs; }
                  { home = { inherit stateVersion; }; }
                  home/modules/kde.nix
                  home/default-applications.nix
                  home/git.nix
                  home/kde.nix
                  home/mpv.nix
                  home/proton.nix
                ];
              };
            })
        ];
      in {

        HPx = lib.nixosSystem {
          system = "x86_64-linux";
          inherit specialArgs;
          modules = [
            machines/HPx/configuration.nix
            machines/HPx/hardware-generated.nix
            { home-manager.users.samuel.imports = [ machines/HPx/home.nix ]; }
          ] ++ defaultModules;
        };

        R3600 = lib.nixosSystem {
          system = "x86_64-linux";
          inherit specialArgs;
          modules = [
            machines/R3600/configuration.nix
            machines/R3600/hardware-generated.nix
          ] ++ defaultModules;
        };
      };
    };

}
