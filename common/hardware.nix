{ config, ... }:

let
  trueIfX = config.services.xserver.enable;
in
{
  # Enable g810-led and set profile
  hardware.g810-led.enable = true;
  hardware.g810-led.profile = ../modules/g810-led_profile;

  # Enable Steam hardware for additional controller support
  hardware.steam-hardware.enable = trueIfX;

  # Enable 32-bit libraries for games
  hardware.opengl.driSupport32Bit = trueIfX;
  hardware.pulseaudio.support32Bit = trueIfX;

  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;
}
