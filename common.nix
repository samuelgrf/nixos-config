# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

# Add variable for unstable packages
let
  unstable = import <nixos-unstable> {};
in {

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlo1.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    # consoleKeyMap = "de";
    consoleUseXkbConfig = true;
    defaultLocale = "en_DE.UTF-8";
  };

  # Set additional environment variables 
  environment.variables = {
    LANGUAGE="en";
    LC_ALL="C";
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Allow installating x86 packages (required for PCSX2)
  nixpkgs.config.allowUnsupportedSystem = true;

  # Allow the installation of unfree software (required for Steam)
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs;
    let
      nox = [
        aircrack-ng
        android-udev-rules
        apktool
        ddcutil
        ddgr
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
        zsh-syntax-highlighting
        # Install Vim plugins
        (pkgs.vim_configurable.customize {
          name = "vim";
          vimrcConfig.vam.pluginDictionaries = [
            { names = [ "vim-addon-nix" ]; ft_regex = "^nix\$"; }
          ];
        })
      ];
      x = [
        android-studio
        anki
        ark
        chromium
        emacs
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
    in
      if config.services.xserver.enable then nox ++ x else nox;

  # Set package overlays
  nixpkgs.overlays = [
    (self: super: {
      rpcs3 = super.callPackage ./overlays/rpcs3.nix { };
    })
  ];

  # Set Vim as default editor
  programs.vim.defaultEditor = true;

  # Set ZSH as default shell
  users.defaultUserShell = pkgs.zsh;

  # Configure ZSH
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
      ohMyZsh = {
        enable = true;
        theme = "powerlevel10k/powerlevel10k";
        custom = "/home/samuel/git-repos/oh-my-zsh/";
      };
      setOptions = [
        "CORRECT"
        "HIST_FCNTL_LOCK"
        "HIST_IGNORE_DUPS"
        "SHARE_HISTORY"
      ];
  };

  # Set shell aliases
  environment.shellAliases = {
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
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  # Enable Steam hardware for additional controller support
  hardware.steam-hardware.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "compose:caps, ctrl:ralt_rctrl";
  services.xserver.autorun = true;

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.samuel = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

  # Enable filesystem support
  boot.supportedFilesystems = [ "ntfs" "zfs" ];

  # Enable NetworkManager
  networking.networkmanager.enable = true;

  # Enable Early OOM
  services.earlyoom.enable = true;

  # Install ADB and fastboot
  programs.adb.enable = true;

  # Enable TLP
  services.tlp.enable = true;

  # Load kernel module for ddcutil
  boot.kernelModules = [ "i2c-dev" ];

  # Collect nix store garbage and optimise daily.
  nix.gc.automatic = true;
  nix.optimise.automatic = true;

  # Enable zram and use more efficient zstd compression
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # Set swappiness to 80 due to improved performance of zram.
  # Can be up to 100 but will increase process queue on intense load such as boot.
  boot.kernel.sysctl = { "vm.swappiness" = 80; };
}