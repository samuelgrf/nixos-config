{ config, lib, pkgs, unstable, ... }:

{
  # System-wide packages to install.
  environment.systemPackages = with pkgs;
    let
      common = [
        bat
        dos2unix
        exiftool
        fd
        file
        git
        htop
        killall
        lm_sensors
        lolcat
        lshw
        unstable.manix # TODO Remove "unstable." on 21.05.
        ncdu
        neofetch
        nix-index
        nix-linter
        nixfmt
        nixpkgs-review
        p7zip
        patchelf
        pciutils
        pre-commit
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
        unstable.ghidra-bin # TODO Remove "unstable." on 21.05.
        gimp
        gwenview
        imagemagick
        kate
        kdialog
        keepassxc
        kwin-dynamic-workspaces
        libreoffice
        libstrangle
        unstable.lutris # TODO Remove "unstable." on 21.05.
        lxqt.pavucontrol-qt
        mpv
        multimc
        nixos-artwork.wallpapers.nineish-dark-gray
        okular
        unstable.pcsx2
        protontricks
        unstable.python3Packages.adb-enhanced # TODO Remove "unstable." on 21.05.
        simple-scan
        steam
        steam-run
        ungoogled-chromium
        winetricks
        wineWowPackages.staging # Comes with both x64 and x86 Wine.
        xdotool
      ];
      noX = [ ];
    in common ++ (if config.services.xserver.enable then X else noX);

  # System-wide fonts to install.
  fonts.fonts = with pkgs; [
    unstable.meslo-lgs-nf # TODO Remove "unstable." on 21.05.
    noto-fonts-cjk
  ];

  # Select allowed unfree packages.
  nixpkgs.config.allowUnfreePredicate = pkg:
    lib.elem (lib.getName pkg) [
      "mfcl2700dnlpr"
      "steam"
      "steam-original"
      "steam-runtime"
    ];

  # Don't install optional default packages.
  environment.defaultPackages = [ ];

  # Install ADB and fastboot.
  programs.adb.enable = true;
}
