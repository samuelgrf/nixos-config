{ config, lib, pkgs, pkgs-unstable, ... }: {

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
        nix-diff
        nix-index
        nix-linter
        nix-tree
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
        whois
        youtube-dl
      ] ++ (with pkgs-unstable; [ manix python3Packages.adb-enhanced ]);
      X = [
        appimage-run
        caffeine-ng
        gimp
        imagemagick
        keepassxc
        libreoffice
        libstrangle
        mpv
        protontricks
        simple-scan
        steam
        steam-run
        ungoogled-chromium
        winetricks
        wineWowPackages.staging
      ] ++ (with kdeGear; [ ark gwenview kate kdialog kwin-dynamic-workspaces ])
        ++ (with pkgs-unstable; [ lutris lxqt.pavucontrol-qt pcsx2 ]);
      noX = [ ];
    in common ++ (if config.services.xserver.enable then X else noX);

  # System-wide fonts to install.
  fonts.fonts = with pkgs; [
    pkgs-unstable.meslo-lgs-nf # TODO Remove "pkgs-unstable." on 21.05.
    noto-fonts-cjk
  ];

  # Select allowed unfree packages.
  nixpkgs.config.allowUnfreePredicate = pkg:
    lib.elem (lib.getName pkg) [
      "chrome-widevine-cdm"
      "chromium-unwrapped"
      "steam"
      "steam-original"
      "steam-runtime"
      "ungoogled-chromium"
      "unrar"
    ];

  # Don't install optional default packages.
  environment.defaultPackages = [ ];

  # Don't allow package aliases.
  nixpkgs.config.allowAliases = false;

  # Install ADB and fastboot.
  programs.adb.enable = true;

}
