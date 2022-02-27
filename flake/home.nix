{ self, ... }:
with self; {

  homeManagerModules = {
    "${userData.name}@default".imports = [
      homeManagerModules.moduleArgs
      ../config/home/modules/kde.nix
      ../config/home/default-applications.nix
      ../config/home/git.nix
      ../config/home/kde
      ../config/home/lutris-wine.nix
      ../config/home/misc.nix
      ../config/home/mpv.nix
      ../config/home/nix-index-database.nix
      ../config/home/spacemacs
    ];

    "${userData.name}@amethyst".imports =
      [ ../config/machines/amethyst/home.nix ];

    "${userData.name}@beryl".imports = [ ];

    moduleArgs = { nixosConfig, ... }:
      nixosModules.moduleArgs { config = nixosConfig; };
  };
}
