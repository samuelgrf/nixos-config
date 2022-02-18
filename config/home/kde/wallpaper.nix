{ pkgs }: {

  # Desktop
  "plasma-org.kde.plasma.desktop-appletsrc".Containments."1".Wallpaper."org.kde.image".General.Image =
    pkgs.nixos-artwork.wallpapers.nineish-dark-gray.kdeFilePath;

  # Lockscreen
  kscreenlockerrc.Greeter.Wallpaper."org.kde.image".General.Image =
    pkgs.nixos-artwork.wallpapers.nineish-dark-gray.kdeFilePath;
}
