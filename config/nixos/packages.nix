{ config, flakes, pkgs, pkgs-unstable, system, ... }: {

  # System-wide packages to install.
  environment.systemPackages = with pkgs;
    let
      common = [
        _7zz
        bat
        common-updater-scripts
        dnsutils
        dos2unix
        exiftool
        fd
        file
        git-open
        gptfdisk
        graalvm11-ce
        htop-vim
        hydra-check
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
        stress
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
        (ungoogled-chromium.override { enableWideVine = true; })
        appimage-run
        calibre
        flakes.home-manager.packages.${system}.docs-html
        flakes.nixpkgs.htmlDocs.nixosManual
        flakes.nixpkgs.htmlDocs.nixpkgsManual
        gftp
        imagemagickBig
        inkscape
        keepassxc
        libreoffice
        lutris
        ocrmypdf
        pcsx2
        pdfsizeopt
        pdftk
        perl
        protontricks
        scrcpy
        tesseract4
        winetricks
        wineWowPackages.staging
        wl-clipboard
        yt-dlp
      ] ++ (with plasma5Packages; [
        ark
        gwenview
        kate
        kcolorchooser
        kdialog
        ktimer
        kwin-dynamic-workspaces
      ])
      # TODO Get packages from stable on NixOS 22.05.
        ++ (with pkgs-unstable; [ polymc skanpage wl-clipboard-x11 ]);
      noX = [ ];
    in common ++ (if config.services.xserver.enable then X else noX);

  # Install programs from modules.
  programs = {
    adb.enable = true;
    partition-manager.enable = true;
    steam.enable = true;
  };

  # System-wide fonts to install.
  fonts.fonts = with pkgs; [ meslo-lgs-nf noto-fonts-cjk times-newer-roman ];

  # Don't install optional default packages.
  environment.defaultPackages = [ ];
}
