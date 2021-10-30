flakes:
with flakes; {

  homeConfigurations = {
    "${self.userData.name}@default".imports = [
      ../home/modules/kde.nix
      ../home/default-applications.nix
      ../home/git.nix
      ../home/kde
      ../home/misc.nix
      ../home/mpv.nix
      ../home/nix-index-database
    ];

    "${self.userData.name}@amethyst".imports =
      [ ../machines/amethyst/home.nix ];

    "${self.userData.name}@beryl".imports = [ ];
  };
}
