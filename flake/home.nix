{ self, ... }:
with self; {

  homeManagerModules = {
    "${userData.name}@default".imports = [
      homeManagerModules.moduleArgs
      ../home/modules/kde.nix
      ../home/default-applications.nix
      ../home/git.nix
      ../home/kde
      ../home/misc.nix
      ../home/mpv.nix
      ../home/nix-index-database
    ];

    "${userData.name}@amethyst".imports = [ ../machines/amethyst/home.nix ];

    "${userData.name}@beryl".imports = [ ];

    moduleArgs = { nixosConfig, ... }:
      nixosModules.moduleArgs { config = nixosConfig; };
  };
}
