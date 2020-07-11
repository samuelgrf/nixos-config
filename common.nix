{ config, lib, pkgs, ... }:

let
  trueIfX = if config.services.xserver.enable then true else false;
in
{
  ##############################################################################
  ## General
  ##############################################################################

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "20.03";

  # Enable support for additional filesystems
  boot.supportedFilesystems = [ "ntfs" "zfs" ];

  # Automatically optimize Nix store
  nix.autoOptimiseStore = true;


  ##############################################################################
  ## Locale
  ##############################################################################

  # Set locale
  i18n.defaultLocale = "en_IE.UTF-8";

  # Set time zone
  time.timeZone = "Europe/Berlin";

  # Set keyboard layout
  services.xserver = {
    layout = "us";
    xkbVariant = "altgr-intl";
    xkbOptions = "caps:escape";
  };


  ##############################################################################
  ## Package management
  ##############################################################################

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
        unstable.nixos-artwork.wallpapers.nineish-dark-gray # TODO Remove "unstable." on 20.09
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


  ##############################################################################
  ## Xorg & Services
  ##############################################################################

  # Enable KDE Plasma 5
  services.xserver.desktopManager.plasma5.enable = trueIfX;
  services.xserver.displayManager.sddm = {
    enable = trueIfX;
    autoLogin.enable = trueIfX;
    autoLogin.user = "samuel";
  };

  # Hides the mouse cursor if it isn’t being moved
  systemd.user.services.unclutter = {
    description = "unclutter-xfixes";
    script = "${pkgs.unclutter-xfixes}/bin/unclutter";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
  };

  # Configure Emacs
  services.emacs = {
    enable = true;
    defaultEditor = true;
    package = with pkgs; (
      if config.services.xserver.enable then emacs else emacs-nox
    );
  };

  # Enable Early OOM
  services.earlyoom.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;


  ##############################################################################
  ## Console & Shell
  ##############################################################################

  # Set console settings
  console.font = "Lat2-Terminus16";
  console.useXkbConfig = true;

  # Set ZSH as default shell
  users.defaultUserShell = pkgs.zsh;

  # Configure ZSH
  programs.zsh = {
    enable = true;
    ohMyZsh.enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    interactiveShellInit = ''
      # Use powerlevel10k theme
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      # Use zsh instead of bash for nix-shell
      # TODO Remove "unstable." on 20.09
      source ${pkgs.unstable.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh

      # Run nixos-rebuild as root and reload zsh when needed
      nixos-rebuild () {
        if [ "$1" = "switch" -o "$1" = "test" ]; then
          sudo nixos-rebuild "$@" &&
          exec zsh
        elif [ "$1" = "boot" ]; then
          sudo nixos-rebuild "$@"
        else
          command nixos-rebuild "$@"
        fi
      }

      # Run nix-collect-garbage as root when needed
      nix-collect-garbage () {
        if [ "$1" = "-d" -o \
             "$1" = "--delete-old" -o \
             "$1" = "--delete-older-than" ]; then
          sudo nix-collect-garbage "$@"
        else
          command nix-collect-garbage "$@"
        fi
      }
    '';
    setOptions = [
      "HIST_FCNTL_LOCK"
      "HIST_IGNORE_DUPS"
      "SHARE_HISTORY"
    ];
  };

  # Set environment variables
  environment.variables = {
    # Used for WIP changes (push changes to $SYSTEMCONFIG by running 'applyconfig')
    USERCONFIG = "/home/samuel/git-repos/nixconfig";
    # Used for finished configuration (set $USERCONFIG as remote)
    SYSTEMCONFIG = "/etc/nixos";
  };

  # Set shell aliases
  environment.shellAliases = {
    # NixOS & Nix
    applyconfig = ''(
      cd $SYSTEMCONFIG &&
      sudo git fetch &&
      git diff master origin/master &&
      sudo git reset --hard origin/master)\
    '';
    testconfig = ''
      nixos-rebuild test \
        -I nixos-config=$USERCONFIG/configuration.nix\
    '';
    nixos-upgrade = ''
      sudo nix-channel --update &&
      nixos-rebuild\
    '';
    nix-stray-roots = ''
      nix-store --gc --print-roots | \
        grep -Ev "^(/nix/var|/run/\w+-system|\{memory|\{censored)"\
    '';
    pks = "nix search";

    # Other
    incognito = "unset HISTFILE";
    unincognito = "HISTFILE=$HOME/.zsh_history";
    isincognito = ''
      if [ -z "$HISTFILE" ]; then
        echo "Yes"
        else echo "No"
      fi\
    '';
    reload = "exec zsh";
    level = "echo $SHLVL";
    wttr = "curl wttr.in";
  };


  ##############################################################################
  ## Networking
  ##############################################################################

  # Enable NetworkManager
  networking.networkmanager.enable = true;

  # Open ports needed for Steam In-Home Streaming
  # https://support.steampowered.com/kb_article.php?ref=8571-GLVN-8711
  networking.firewall.allowedUDPPortRanges = [ { from = 27031; to = 27036; } ];
  networking.firewall.allowedTCPPorts = [ 27036 ];


  ##############################################################################
  ## Kernel
  ##############################################################################

  # Load kernel module for ddcutil
  boot.kernelModules = [ "i2c-dev" ];

  # Enable zram and use more efficient zstd compression
  zramSwap.enable = true;
  zramSwap.algorithm = "zstd";

  # Set swappiness to 80 due to improved performance of zram.
  # Can be up to 100, but will increase process queue on intense load such as boot.
  boot.kernel.sysctl = { "vm.swappiness" = 80; };


  ##############################################################################
  ## Hardware
  ##############################################################################

  # Enable g810-led and set profile
  hardware.g810-led.enable = true;
  hardware.g810-led.profile = ./modules/g810-led_profile;

  # Enable Steam hardware for additional controller support
  hardware.steam-hardware.enable = trueIfX;

  # Enable 32-bit libraries for games
  hardware.opengl.driSupport32Bit = trueIfX;
  hardware.pulseaudio.support32Bit = trueIfX;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;


  ##############################################################################
  ## Printing
  ##############################################################################

  # Setup CUPS for printing documents
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ hplip mfcl2700dncupswrapper ];

  # Add printers
  hardware.printers.ensurePrinters = [
    {
      name = "Brother_MFC-L2700DW";
      description = "Brother MFC-L2700DW";
      location = "Office Upstairs";
      deviceUri = "ipp://192.168.178.37/ipp";
      # Get installed PPD files by running "lpinfo -m"
      model = "brother-MFCL2700DN-cups-en.ppd";
      # Get options by running "lpoptions -p Brother_MFC-L2700DW -l"
      ppdOptions = {
        "PageSize" = "A4";
        "BrMediaType" = "PLAIN";
        "Resolution" = "600dpi";
        "InputSlot" = "TRAY1"; # Scanning?
        "Duplex" = "None";
        "TonerSaveMode" = "OFF";
        # Timeout before going to sleep after printing.
        # Can be "PrinterDefault", "2minutes", "10minutes" or "30minutes"
        "Sleep" = "PrinterDefault";
      };
    }
    {
      name = "HP_OfficeJet_Pro_7720";
      description = "HP Officejet Pro 7720";
      location = "Office Downstairs";
      deviceUri = "hp:/net/OfficeJet_Pro_7720_series?ip=192.168.178.36";
      model = "drv:///hp/hpcups.drv/hp-officejet_pro_7720_series.ppd";
      ppdOptions = {
        "PageSize" = "A3";
        "ColorModel" = "RGB";
        "MediaType" = "Plain";
        "OutputMode" = "Normal"; # Quality, can be "Normal", "FastDraft", "Best" or "Photo"
        "InputSlot" = "Upper"; # Scanning?
        "Duplex" = "None";
      };
    }
  ];

  ##############################################################################
  ## Fonts
  ##############################################################################

  # System-wide fonts
  fonts.fonts = with pkgs; [
    unstable.hack_nerdfont # Emacs, TODO Remove "unstable." on 20.09
    liberation_ttf # Free replacement for MS Fonts
    unstable.meslo-lg_nerdfont # TODO Remove "unstable." on 20.09
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];

  # Set default fonts
  fonts.fontconfig.defaultFonts = {
    sansSerif = [
      "Noto Sans"
    ];
    serif = [
      "Noto Serif"
    ];
    monospace = [
      "MesloLGS Nerd Font"
      "Noto Sans Mono"
    ];
    emoji = [
      "Noto Color Emoji"
    ];
  };


  ##############################################################################
  ## Users & Misc
  ##############################################################################

  # Define user accounts. Don't forget to set a password with ‘passwd’.
  users.users = {
    samuel = {
      description = "Samuel Gräfenstein";
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
    };
  };

  # Disable GUI password prompt when using ssh
  programs.ssh.askPassword = "";
}
