{ config, lib, ... }:

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

    # Host specifics
    ./host/configuration.nix
    ./host/hardware.nix

    # Modules
    <home-manager/nixos>
    ./modules/g810-led.nix

    # Overlays
    ./overlays
  ];

  # Home Manager
  home-manager.useGlobalPkgs = true;
  home-manager.users.samuel.imports = [
    ./common/home.nix
  ] ++ (if lib.pathExists ./host/home.nix then [ ./host/home.nix ] else [ ]);
}
