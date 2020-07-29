{ config, ... }:

{
  # Enable g810-led and set profile.
  hardware.g810-led.enable = true;
  hardware.g810-led.profile = ../modules/g810-led_profile;

  # Enable Steam hardware for additional controller support.
  hardware.steam-hardware.enable = true;

  # Enable 32-bit libraries for games.
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
}
