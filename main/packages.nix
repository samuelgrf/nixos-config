{ config, flakes, lib, pkgs, ... }: {

  # System-wide packages to install.
  environment.systemPackages = with pkgs;
    let
      common = [
        (writeShellScriptBin "java8" "${graalvm8-ce}/bin/java $@")
        bat
        dos2unix
        exiftool
        fd
        file
        git
        git-open
        graalvm11-ce
        htop
        killall
        kjv
        lm_sensors
        lolcat
        lshw
        manix
        ncdu
        neofetch
        nix-diff
        nix-index
        nix-linter
        nix-tree
        nixfmt
        nixpkgs-review
        nvd
        p7zip
        patchelf
        pciutils
        pre-commit
        python3
        python3Packages.adb-enhanced
        qrencode
        reptyr
        smartmontools
        strace
        sysstat
        tmpmail
        trash-cli
        tree
        unrar
        usbutils
        vim
        whois
        youtube-dl
      ];
      X = [
        (gimp-with-plugins.override { plugins = with gimpPlugins; [ bimp ]; })
        (import flakes.home-manager { inherit pkgs; }).docs.html
        (lib.hiPrio flakes.nixpkgs-unstable.htmlDocs.nixosManual)
        appimage-run
        calibre
        flakes.nixpkgs-unstable.htmlDocs.nixpkgsManual
        ghostscript
        imagemagick
        keepassxc
        libreoffice
        lutris
        lxqt.pavucontrol-qt
        mpv
        multimc
        nixUnstable.doc
        ocrmypdf
        pcsx2
        pdfsizeopt
        pdftk
        protontricks
        scrcpy
        simple-scan
        ungoogled-chromium
        winetricks
        wineWowPackages.staging
      ] ++ (with plasma5Packages; [
        ark
        gwenview
        kate
        kdialog
        ktimer
        kwin-dynamic-workspaces
      ]);
      noX = [ ];
    in common ++ (if config.services.xserver.enable then X else noX);

  # Install programs from modules.
  programs = {
    adb.enable = true;
    partition-manager.enable = true;
    steam.enable = true;
  };

  # System-wide fonts to install.
  fonts.fonts = with pkgs; [ meslo-lgs-nf noto-fonts-cjk ];

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

  # Disallow package aliases.
  nixpkgs.config.allowAliases = false;

}
