{ config, lib, pkgs, ... }:

let
  trueIfX = if config.services.xserver.enable then true else false;
in
{
  # Set locale
  i18n.defaultLocale = "en_IE.UTF-8";

  # Set console settings
  console.font = "Lat2-Terminus16";
  console.useXkbConfig = true;

  # Set keyboard layout
  services.xserver = {
    layout = "us";
    xkbVariant = "altgr-intl";
    xkbOptions = "caps:escape";
  };

  # Set time zone
  time.timeZone = "Europe/Berlin";

  # Select allowed unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "android-studio-stable"
    "firefox-bin"
    "firefox-release-bin-unwrapped"
    "mfcl2700dnlpr"
    "steam"
    "steam-original"
    "steam-runtime"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs;
    let
      common = [
        android-udev-rules
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
        firefox-bin
        gamemode
        gamemode32
        gimp
        gnome3.adwaita-icon-theme # Needed for caffeine-ng to display icons
        gwenview
        jetbrains.idea-community
        kate
        kdialog
        keepassxc
        konsole
        libreoffice
        lutris
        mpv
        multimc
        okular
        openjdk
        partition-manager
        pavucontrol
        unstable.pcsx2_nativeOptimizations
        rpcs3_nativeOptimizations
        spectacle
        spotify-tui
        unstable.steam
        torbrowser
        unstable.ungoogled-chromium # TODO: Switch to stable channel when package is available
        unstable.wineWowPackages.staging # Comes with both x64 and x86 Wine
        unstable.winetricks
        xclip
        xorg.xev
      ];
    in common ++ (if config.services.xserver.enable then X else noX);

  # Hides the mouse cursor if it isn’t being used
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
      if config.services.xserver.enable
        then emacs
      else
        emacs-nox
    );
  };

  # Set ZSH as default shell
  users.defaultUserShell = pkgs.zsh;

  # Configure ZSH
  programs.zsh = {
    enable = true;
    ohMyZsh.enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    # This is needed for Git to use the GPG pinentry program set in home.nix
    shellInit = ''
      export GPG_TTY=$(tty)
    '';
    setOptions = [
      "CORRECT"
      "HIST_FCNTL_LOCK"
      "HIST_IGNORE_DUPS"
      "SHARE_HISTORY"
    ];
  };

  # Set shell aliases
  environment.shellAliases = {
    "applyconfig" = "
      OLDBRANCH=$(git -C /etc/nixos rev-parse --abbrev-ref HEAD) &&
      NEWBRANCH=$(git -C /home/samuel/git-repos/nixconfig rev-parse --abbrev-ref HEAD) &&
      sudo git -C /etc/nixos fetch &&
      git -C /etc/nixos diff $OLDBRANCH origin/$NEWBRANCH &&
      sudo git -C /etc/nixos reset --hard origin/$NEWBRANCH";
    "testconfig" = "sudo nixos-rebuild test -I nixos-config=/home/samuel/git-repos/nixconfig/configuration.nix";
    "nix-stray-roots" = ''nix-store --gc --print-roots | grep -Ev "^(/nix/var|/run/\w+-system|\{memory|\{censored)"'';
    "pks" = "nix search";
    "pku" = "sudo nixos-rebuild switch --upgrade";
    "wttr" = "curl wttr.in";
  };

  # Enable 32-bit libraries for games
  hardware.opengl.driSupport32Bit = trueIfX;
  hardware.pulseaudio.support32Bit = trueIfX;

  # Open ports needed for Steam In-Home Streaming
  # https://support.steampowered.com/kb_article.php?ref=8571-GLVN-8711
  networking.firewall.allowedUDPPortRanges = [ { from = 27031; to = 27036; } ];
  networking.firewall.allowedTCPPorts = [ 27036 ];

  # Enable Steam hardware for additional controller support
  hardware.steam-hardware.enable = trueIfX;

  # Enable g810-led and set profile
  hardware.g810-led.enable = true;
  hardware.g810-led.profile = ./modules/g810-led_profile;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable KDE Plasma 5
  services.xserver.desktopManager.plasma5.enable = trueIfX;
  services.xserver.displayManager.sddm = {
    enable = trueIfX;
    autoLogin.enable = trueIfX;
    autoLogin.user = "samuel";
  };

  # Define user accounts. Don't forget to set a password with ‘passwd’.
  users.users = {
    samuel = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?

  # Enable support for additional filesystems
  boot.supportedFilesystems = [ "ntfs" "zfs" ];

  # Enable NetworkManager
  networking.networkmanager.enable = true;

  # Enable Early OOM
  services.earlyoom.enable = true;

  # Install ADB and fastboot
  programs.adb.enable = true;

  # Load kernel module for ddcutil
  boot.kernelModules = [ "i2c-dev" ];

  # Optimize Nix store and run garbage collector daily
  nix.gc.automatic = false;
  nix.optimise.automatic = true;

  # Enable zram and use more efficient zstd compression
  zramSwap.enable = true;
  zramSwap.algorithm = "zstd";

  # Set swappiness to 80 due to improved performance of zram.
  # Can be up to 100 but will increase process queue on intense load such as boot.
  boot.kernel.sysctl = { "vm.swappiness" = 80; };

  # Disable GUI password prompt when using ssh
  programs.ssh.askPassword = "";

  # Enable GnuPG agent
  programs.gnupg.agent.enable = true;
}
