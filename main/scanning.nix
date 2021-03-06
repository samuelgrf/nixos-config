{ sane-airscan, ... }:

{
  # Setup SANE for Apple AirScan and Microsoft WSD scanning.
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ sane-airscan ];

  # Enable Avahi daemon for zero-configuration (zeroconf) networking.
  services.avahi.enable = true;
}
