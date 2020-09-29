{ config, lib, ... }:

{
  # Nix channels
  home-manager.users.root.home.file.".nix-channels".text = ''
    https://github.com/nix-community/home-manager/archive/release-20.09.tar.gz home-manager
    https://channels.nixos.org/nixos-20.09 nixos
    https://channels.nixos.org/nixos-unstable-small nixos-unstable
  '';

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

  # Home directory
  home-manager.users.samuel.imports = [
    ./common/home.nix
  ] ++ (if lib.pathExists ./host/home.nix then [ ./host/home.nix ] else [ ]);
}
