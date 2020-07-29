{ config, pkgs, lib, ... }:

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
        imagemagick
        killall
        lm_sensors
        lolcat
        lshw
        lynx
        ncdu
        neofetch
        nix-linter
        nixfmt
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
        firefox-beta-bin
        gimp
        gnome3.adwaita-icon-theme # Needed for caffeine-ng to display icons.
        gwenview
        inkscape
        jetbrains.idea-community
        kate
        kdialog
        keepassxc
        konsole
        libreoffice
        unstable.lutris
        mpv
        multimc
        # TODO Remove "unstable." on 20.09.
        unstable.nixos-artwork.wallpapers.nineish-dark-gray
        okular
        openjdk
        partition-manager
        pavucontrol
        unstable.protontricks
        smartmontools
        spectacle
        unstable.steam
        unstable.steam-run
        torbrowser
        unstable.ungoogled-chromium # TODO Remove "unstable." on 20.09.
        unstable.wineWowPackages.staging # Comes with both x64 and x86 Wine.
        unstable.winetricks
        xclip
        xorg.xev
      ];
    in common ++ (if config.services.xserver.enable then X else noX);

  # Select allowed unfree packages.
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "android-studio-stable"
    "firefox-beta-bin"
    "firefox-beta-bin-unwrapped"
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
