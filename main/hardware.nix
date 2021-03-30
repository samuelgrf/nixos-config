{ pulseaudio-modules-bt, ... }: {

  # Enable Steam hardware for additional controller support.
  hardware.steam-hardware.enable = true;

  # Enable 32-bit libraries for games.
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  # Enable DDC support in Plasma 5.
  services.xserver.desktopManager.plasma5.supportDDC = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Add LDAC, aptX, aptX HD, AAC codec support for Bluetooth playback.
  # TODO Remove when https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/merge_requests/473
  # is merged and in nixpkgs.
  hardware.pulseaudio.extraModules = [ pulseaudio-modules-bt ];

}
