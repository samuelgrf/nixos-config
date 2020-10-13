{ lib, ... }:

{
  imports = [
    # All hosts
    ./common/fonts.nix
    ./common/general.nix
    ./common/hardware.nix
    ./common/kernel.nix
    ./common/misc.nix
    ./common/networking.nix
    ./common/packages.nix
    ./common/printing.nix
    ./common/services.nix
    ./common/terminal.nix

    # Modules
    ./modules/g810-led.nix

    # Overlays
    ./overlays
  ]
    # Secrets
    ++ (with lib; optional (pathExists ./secrets) [ ./secrets ]);
}
