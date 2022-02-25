{ pkgs }: {

  # Desktop: Get picture of the day from Unsplash.
  "plasma-org.kde.plasma.desktop-appletsrc".Containments."1".Wallpaper."org.kde.potd".General =
    {
      Provider = "unsplash";
      FillMode = 2; # Scaled and cropped
    };

  # Lockscreen
  kscreenlockerrc.Greeter.Wallpaper."org.kde.image".General.Image =
    pkgs.nixos-artwork.wallpapers.nineish-dark-gray.kdeFilePath;
}
