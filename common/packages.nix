{ config, pkgs, lib, ... }:

{
  # System-wide packages
  environment.systemPackages = with pkgs;
    let
      common = [
        apktool
        bat
        bind
        ddgr
        fd
        git
        gnupg
        htop
        imagemagick
        lm_sensors
        lolcat
        lshw
        lynx
        ncdu
        neofetch
        patchelf
        pciutils
        python3
        sysstat
        tuir
        unar
        usbutils
        wget
        whois
        unstable.youtube-dl
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
        firefox-beta-bin
        gimp
        gnome3.adwaita-icon-theme # Needed for caffeine-ng to display icons
        gwenview
        inkscape
        jetbrains.idea-community
        kate
        kdialog
        keepassxc
        konsole
        libreoffice
        lutris
        unstable.mpv_sponsorblock # Use unstable channel because of youtube-dl
        multimc
        # TODO Remove "unstable." on 20.09
        unstable.nixos-artwork.wallpapers.nineish-dark-gray
        okular
        openjdk
        partition-manager
        pavucontrol
        spectacle
        unstable.steam
        torbrowser
        unstable.ungoogled-chromium # TODO Remove "unstable." on 20.09
        unstable.wineWowPackages.staging # Comes with both x64 and x86 Wine
        unstable.winetricks
        xclip
        xorg.xev
      ];
    in common ++ (if config.services.xserver.enable then X else noX);

  # Select allowed unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "android-studio-stable"
    "firefox-beta-bin"
    "firefox-beta-bin-unwrapped"
    "mfcl2700dnlpr"
    "steam"
    "steam-original"
    "steam-runtime"
  ];

  # Install ADB and fastboot
  programs.adb.enable = true;

  # Enable GnuPG agent
  programs.gnupg.agent.enable = true;
}
