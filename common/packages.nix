{ config, lib, pkgs, unstable, ... }:

{
  # System-wide packages to install.
  environment.systemPackages = with pkgs;
  let
    common = [
      bat
      dos2unix
      fd
      file
      git
      gitAndTools.delta
      htop
      killall
      lm_sensors
      lolcat
      lshw
      unstable.manix # TODO Remove "unstable." on 21.03.
      ncdu
      neofetch
      nix-index
      nix-linter
      nixfmt
      nixpkgs-review
      p7zip
      patchelf
      pciutils
      python3
      qrencode
      smartmontools
      strace
      sysstat
      trash-cli
      tree
      usbutils
      wget
      whois
      youtube-dl
    ];
    X = [
      anki
      appimage-run
      ark
      caffeine-ng
      # TODO Keep this on the most stable channel with official build settings.
      # https://github.com/NixOS/nixpkgs/pull/101467
      unstable.chromium
      gimp
      gwenview
      imagemagick
      kate
      kdialog
      keepassxc
      kwin-dynamic-workspaces
      libreoffice
      lutris
      lxqt.pavucontrol-qt
      mangohud
      mpv
      multimc
      nixos-artwork.wallpapers.nineish-dark-gray
      okular
      unstable.pcsx2
      protontricks
      steam
      steam-run
      torbrowser
      wineWowPackages.staging # Comes with both x64 and x86 Wine.
      winetricks
      xdotool
    ];
    noX = [ ];
  in common ++ (if config.services.xserver.enable then X else noX);

  # Select allowed unfree packages.
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "mfcl2700dnlpr"
    "steam"
    "steam-original"
    "steam-runtime"
  ];

  # Don't install optional default packages.
  environment.defaultPackages = [ ];

  # Install ADB and fastboot.
  programs.adb.enable = true;

  # Install GnuPG agent.
  programs.gnupg.agent.enable = true;
}
