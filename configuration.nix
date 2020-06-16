{
  imports = [
    ./common.nix
    ./overlays
    ./host/configuration.nix
    ./host/hardware.nix
    ./modules/g810-led.nix
  ];
}
