{ lib, ... }:

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
    # g810-led (https://github.com/NixOS/nixpkgs/pull/92124)
    (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixpkgs/992b26bf5774c74cfba5b4611116328292c51236/nixos/modules/hardware/g810-led.nix";
      sha256 = "1iirh5mcwf4swlnmhv5jf1v3h25mm872vf05h3v8z67cf5lgm55f";
    })

    # Overlays
    ./overlays
  ]
    # Secrets
    ++ (if lib.pathExists ./secrets then [ ./secrets ] else [ ]);

  # Home directory
  home-manager.users.samuel.imports = [
    ./common/home.nix
  ] ++ (if lib.pathExists ./host/home.nix then [ ./host/home.nix ] else [ ]);
}
