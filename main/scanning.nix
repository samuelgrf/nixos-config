{ sane-airscan, ... }: {

  # Setup SANE for Apple AirScan and Microsoft WSD scanning.
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ sane-airscan ];

}
