{ config, lib, pkgs, ... }:

{
  # System-wide packages to install.
  environment.systemPackages = with pkgs;
    let
      common = [
        apktool
        bat
        bind
        unstable.cod # TODO Remove "unstable." on 21.03.
        ddgr
        fd
        file
        git
        gnupg
        htop
        killall
        lm_sensors
        lolcat
        lshw
        lynx
        manix
        ncdu
        neofetch
        nix-index
        nixfmt
        nixpkgs-review
        patchelf
        pciutils
        python3
        strace
        sysstat
        trash-cli
        tuir
        unar
        usbutils
        wget
        whois
        youtube-dl
      ];
      noX = [
        openjdk_headless
      ];
      X = [
        android-studio
        anki
        ark
        caffeine-ng
        filezilla
        gimp
        google-chrome-beta
        gwenview
        imagemagick
        inkscape
        iw
        jetbrains.idea-community
        kate
        kdialog
        keepassxc
        konsole
        kwin-dynamic-workspaces
        libreoffice
        lutris
        lxqt.pavucontrol-qt
        mpv
        multimc
        nixos-artwork.wallpapers.nineish-dark-gray
        okular
        openjdk
        partition-manager
        pcsx2
        protontricks
        smartmontools
        spectacle
        steam
        torbrowser
        wineWowPackages.staging # Comes with both x64 and x86 Wine.
        winetricks
        xclip
        xorg.xev
      ];
    in common ++ (if config.services.xserver.enable then X else noX);

  # Select allowed unfree packages.
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "android-studio-stable"
    "google-chrome-beta"
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
