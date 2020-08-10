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
        killall
        lm_sensors
        lolcat
        lshw
        lynx
        ncdu
        neofetch
        nix-index
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
        imagemagick
        inkscape
        jetbrains.idea-community
        kate
        kdialog
        keepassxc
        konsole
        libreoffice
        unstable.lutris # TODO Remove "unstable." on 20.09.
        mpv
        multimc
        # TODO Remove "unstable." on 20.09.
        unstable.nixos-artwork.wallpapers.nineish-dark-gray
        okular
        openjdk
        partition-manager
        pavucontrol
        pcsx2
        protontricks
        qt5.qttools # Includes `qdbus` command, needed for `gray` alias.
        smartmontools
        spectacle
        steam
        steam-run
        torbrowser
        unstable.ungoogled-chromium # TODO Remove "unstable." on 20.09.
        wineWowPackages.staging # Comes with both x64 and x86 Wine.
        winetricks
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

  # Allow packages for other architectures, needed for pcsx2.
  nixpkgs.config.allowUnsupportedSystem = true;

  # Install ADB and fastboot.
  programs.adb.enable = true;

  # Install GnuPG agent.
  programs.gnupg.agent.enable = true;
}
