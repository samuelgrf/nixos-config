# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./tlp.nix
    ];

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
    consoleKeyMap = "de";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    aircrack-ng
    android-studio
    android-udev-rules
    apktool
    ddgr
    firefox
    fortune
    git
    gnupg
    htop
    imagemagick
    jetbrains.idea-community
    kate
    konsole
    lolcat
    lynx
    neofetch
    networkmanager
    pavucontrol
    p7zip
    pciutils
    powertop
    python3
    speedtest-cli
    usbutils
    vim
    xclip
    youtube-dl
  ];

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
  services.xserver.layout = "de";
  services.xserver.xkbOptions = "eurosign:e";
  services.xserver.autorun = true;

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.samuel = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

  # Enable filesystem support
  boot.supportedFilesystems = [ "ntfs" "zfs" ];

  # Enable unstable ZFS features
  # required for ZFS encryption
  boot.zfs.enableUnstable = true;

  # Request ZFS decryption password on boot
  boot.zfs.requestEncryptionCredentials = true;

  # The 32-bit host ID of the machine, formatted as 8 hexadecimal characters.
  # generated via "head -c 8 /etc/machine-id"
  # required by ZFS
  networking.hostId = "52623593";

  # Enable NetworkManager
  networking.networkmanager.enable = true;

  # Install wifi kernel module
  boot.extraModulePackages = with pkgs; [
    linuxPackages.rtl8821ce
  ];

  # Blacklist sensor kernel modules
  boot.blacklistedKernelModules = ["intel_ishtp_hid" "intel_ish_ipc"];

  # Install ADB and fastboot
  programs.adb.enable = true;

  # Enable Z shell
  # programs.zsh.enable = true;

  # Set Z shell as default
  # users.users.samuel.shell = pkgs.zsh;
}
