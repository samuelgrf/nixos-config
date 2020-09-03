{ config, lib, pkgs, ... }:

{
  # System-wide packages to install.
  environment.systemPackages = with pkgs;
    let
      common = [
        apktool
        bat
        bind
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
        ncdu
        neofetch
        nix-index
        nixfmt
        nixpkgs-review
        patchelf
        pciutils
        python3
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
        gnome3.adwaita-icon-theme # Needed for caffeine-ng to display icons.
        # TODO Remove "unstable." on 20.09.
        unstable.google-chrome-beta
        gwenview
        imagemagick
        inkscape
        jetbrains.idea-community
        kate
        kdialog
        keepassxc
        konsole
        libreoffice
        unstable.lutris # TODO Remove "unstable." on 20.09.
        lxqt.pavucontrol-qt
        mpv
        multimc
        # TODO Remove "unstable." on 20.09.
        unstable.nixos-artwork.wallpapers.nineish-dark-gray
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

  # Install ADB and fastboot.
  programs.adb.enable = true;

  # Install GnuPG agent.
  programs.gnupg.agent.enable = true;
}
