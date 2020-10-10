{ pkgs, ... }:

{
  # Enable g810-led and set profile.
  hardware.g810-led.enable = true;
  hardware.g810-led.profile = pkgs.writeText "g810-led_profile" ''
    # Set all keys to orange-red
    a ff3000
    c
  '';

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
}
