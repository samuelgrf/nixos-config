{ pulseaudio-modules-bt, ... }: {

  # Enable DDC support in Plasma 5.
  services.xserver.desktopManager.plasma5.supportDDC = true;

  # Enable sound.
  hardware.pulseaudio.enable = true;

  # Add LDAC, aptX, aptX HD, AAC codec support for Bluetooth playback.
  # TODO Remove when https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/merge_requests/473
  # is merged and in nixpkgs.
  hardware.pulseaudio.extraModules = [ pulseaudio-modules-bt ];

}
