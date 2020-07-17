{
  imports = [
    # All hosts
    ./common/fonts.nix
    ./common/general.nix
    ./common/kernel.nix
    ./common/locale.nix
    ./common/misc.nix
    ./common/networking.nix
    ./common/packages.nix
    ./common/printing.nix
    ./common/services.nix
    ./common/terminal.nix

    # Host specifics
    ./host/configuration.nix
    ./host/hardware.nix

    # Other
    ./modules/g810-led.nix
    ./overlays
  ];
}
