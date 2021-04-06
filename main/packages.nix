{ config, lib, pkgs, unstable, ... }: {

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
        unrar
        usbutils
        wget
        whois
        youtube-dl
      ] ++ (with unstable; [ manix ]);
      X = [
        anki
        appimage-run
        caffeine-ng
        gimp
        imagemagick
        keepassxc
        libreoffice
        libstrangle
        lutris
        mpv
        multimc
        protontricks
        simple-scan
        steam
        steam-run
        ungoogled-chromium
        winetricks
        wineWowPackages.staging
        xdotool
      ] ++ (with plasma5Packages; [
        ark
        gwenview
        kate
        kdialog
        kwin-dynamic-workspaces
        okular
      ]) ++ (with unstable; [
        ghidra-bin
        lxqt.pavucontrol-qt
        pcsx2
        python3Packages.adb-enhanced
      ]);
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
      "unrar"
    ];

  # Don't install optional default packages.
  environment.defaultPackages = [ ];

  # Don't allow package aliases.
  nixpkgs.config.allowAliases = false;

  # Install ADB and fastboot.
  programs.adb.enable = true;

}
