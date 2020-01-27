{ config, pkgs, ... }:

{
  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_IE.UTF-8";
    consoleFont = "Lat2-Terminus16";
    consoleUseXkbConfig = true;
  };

  # Set keyboard layout
  services.xserver = {
    layout = "us";
    xkbVariant = "altgr-intl";
    xkbOptions = "caps:escape";
  };

  # Set time zone
  time.timeZone = "Europe/Berlin";

  # Configure Nixpkgs
  nixpkgs.config = {
    allowUnsupportedSystem = true; # required for PCSX2
    allowUnfree = true; # required for Steam
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs;
    let
      common = [
        aircrack-ng
        android-udev-rules
        apktool
        ddcutil
        ddgr
        fd
        fortune
        git
        gnupg
        htop
        imagemagick
        jdk
        lolcat
        lshw
        lynx
        neofetch
        patchelf
        p7zip
        pciutils
        powertop
        python3
        speedtest-cli
        unstable.tuir
        usbutils
        wget
        wineStaging
        youtube-dl
      ];
      noX = [
      ];
      X = [
        android-studio
        anki
        ark
        chromium
        filezilla
        firefox
        gimp
        gnome3.adwaita-icon-theme
        gnome-themes-extra
        gwenview
        jetbrains.idea-community
        kate
        kcalc
        keepassxc
        konsole
        libreoffice
        lutris
        mpv
        okular
        pavucontrol
        partition-manager
        unstable.pcsx2
        rpcs3
        spectacle
        steam
        torbrowser
        unclutter-xfixes
        xclip
        xorg.xev
      ];
    in common ++ (if config.services.xserver.enable then X else noX);

  # Set package overlays
  nixpkgs.overlays = [
    (self: super: {
      unstable = import <nixos-unstable> { config = config.nixpkgs.config; };
      rpcs3 = super.callPackage ./overlays/rpcs3.nix { };
      emacs-nox = pkgs.emacs.override {
        withX = false;
        withGTK2 = false;
        withGTK3 = false;
      };
    })
  ];

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
    promptInit = "source ${pkgs.unstable.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    setOptions = [
      "CORRECT"
      "HIST_FCNTL_LOCK"
      "HIST_IGNORE_DUPS"
      "SHARE_HISTORY"
    ];
  };

  # Set shell aliases
  environment.shellAliases = {
    "applyconfig" = "sudo git -C /etc/nixos fetch &&
                     git -C /etc/nixos diff master origin/master &&
                     sudo git -C /etc/nixos reset --hard origin/master";
    "c." = "cd ..";
    "pki" = "sudo nix-env -i";
    "pkl" = "nix-env -qaP";
    "pkp" = "command-not-found";
    "pkr" = "sudo nix-env -e";
    "pks" = "nix search";
    "pku" = "sudo nixos-rebuild switch --upgrade";
    "wttr" = "curl wttr.in";
  };

  # Enable 32-bit libraries for games
  hardware = {
    opengl.driSupport32Bit = true;
    pulseaudio.support32Bit = true;
  };

  # Enable Steam hardware for additional controller support
  hardware.steam-hardware.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable KDE Plasma 5
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    samuel = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
    };
      test = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

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
  nix = {
    gc.automatic = true;
    optimise.automatic = true;
  };

  # Enable zram and use more efficient zstd compression
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # Set swappiness to 80 due to improved performance of zram.
  # Can be up to 100 but will increase process queue on intense load such as boot.
  boot.kernel.sysctl = { "vm.swappiness" = 80; };

  # Disable GUI password prompt when using ssh
  programs.ssh.askPassword = "";
}
