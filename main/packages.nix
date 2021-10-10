{ config, flakes, lib, pkgs, pkgs-unstable, ... }: {

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
        gptfdisk
        graalvm11-ce
        htop
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
        youtube-dl
      ]
      # TODO Get packages from stable on NixOS 21.11.
        ++ (with pkgs-unstable; [ pipe-rename ]);
      X = [
        (gimp-with-plugins.override { plugins = with gimpPlugins; [ bimp ]; })
        # TODO Replace with `flakes.home-manager.packages.${system}.docs-html` on NixOS 21.11.
        (import flakes.home-manager { inherit pkgs; }).docs.html
        (mpv.override {
          scripts = with mpvScripts; [
            mpris
            sponsorblock
            # TODO Remove `pkgs-unstable.mpvScripts.` on NixOS 21.11.
            pkgs-unstable.mpvScripts.youtube-quality
          ];
        })
        (winetricks.override { wine = wineWowPackages.staging; })
        appimage-run
        calibre
        flakes.nixpkgs-unstable.htmlDocs.nixosManual
        flakes.nixpkgs-unstable.htmlDocs.nixpkgsManual
        ghostscript
        imagemagick
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

  # Select allowed unfree packages.
  nixpkgs.config.allowUnfreePredicate = pkg:
    __elem (lib.getName pkg) [
      "chrome-widevine-cdm"
      "chromium-unwrapped"
      "mpv-youtube-quality"
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
