{ config, flakes, pkgs, system, ... }: {

  # System-wide packages to install.
  environment.systemPackages = with pkgs;
    let
      common = [
        _7zz
        bat
        common-updater-scripts
        dos2unix
        exiftool
        fd
        file
        git
        git-open
        gptfdisk
        graalvm11-ce
        htop
        inetutils
        jq
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
        nix-update
        nixfmt
        nixpkgs-review
        nvd
        patchelf
        pciutils
        pipe-rename
        pre-commit
        python3
        python3Packages.adb-enhanced
        qrencode
        reptyr
        ripgrep
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
      ];
      X = [
        (gimp-with-plugins.override { plugins = with gimpPlugins; [ bimp ]; })
        (mpv.override {
          scripts = with mpvScripts; [ mpris sponsorblock youtube-quality ];
        })
        appimage-run
        calibre
        flakes.home-manager.packages.${system}.docs-html
        flakes.nixpkgs-unstable.htmlDocs.nixosManual
        flakes.nixpkgs-unstable.htmlDocs.nixpkgsManual
        imagemagickBig
        inkscape
        keepassxc
        libreoffice
        lutris
        lxqt.pavucontrol-qt
        multimc
        nixUnstable.doc
        ocrmypdf
        pcsx2
        pdfsizeopt
        pdftk
        protontricks
        scrcpy
        simple-scan
        tesseract4
        ungoogled-chromium
        wineWowPackages.staging
        winetricks
        yt-dlp
      ] ++ (with plasma5Packages; [
        ark
        gwenview
        kate
        kcolorchooser
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

  # Don't install optional default packages.
  environment.defaultPackages = [ ];
}
