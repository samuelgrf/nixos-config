{ nixos-artwork }: {

  # Desktop
  "plasma-org.kde.plasma.desktop-appletsrc".Containments."1".Wallpaper."org.kde.image".General.Image =
    "file://${nixos-artwork.wallpapers.nineish-dark-gray}/share/backgrounds/nixos/nix-wallpaper-nineish-dark-gray.png";

  # Lockscreen
  kscreenlockerrc.Greeter.Wallpaper."org.kde.image".General.Image =
    "file://${nixos-artwork.wallpapers.nineish-dark-gray}/share/backgrounds/nixos/nix-wallpaper-nineish-dark-gray.png";

}
