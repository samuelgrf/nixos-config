{ config, lib, pkgs, ... }:

{
  imports = [
    ../modules/qemu-user.nix
  ];

  # Set GRUB timeout
  boot.loader.timeout = 1;

  # networking.hostName = "nixos"; # Define your hostname.

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.autorun = true;

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # The 32-bit host ID of this machine, formatted as 8 hexadecimal characters.
  # generated via "head -c 8 /etc/machine-id"
  # this is required by ZFS
  networking.hostId = "97e4f3b3";

  # Randomize MAC addresses
  networking.networkmanager.ethernet.macAddress = "random";
  networking.networkmanager.wifi.macAddress = "random";

  # Install wifi kernel module
  boot.extraModulePackages = [ pkgs.linuxPackages.rtl8821ce ];

  # Blacklist sensor kernel modules
  boot.blacklistedKernelModules = [ "intel_ishtp_hid" "intel_ish_ipc" ];

  # Setup virtualization
  boot.kernelModules = [ "kvm-intel" ];

  # Configure TLP
  services.tlp.enable = true;
  services.tlp.extraConfig = "RUNTIME_PM_BLACKLIST='02:00.0'"; # Blacklist wifi card

  # Undervolting
  services.undervolt = {
    enable = true;
    coreOffset = "-125";
    gpuOffset = "-115";
    uncoreOffset = "-125";
    # TODO: Test with USB devices
    analogioOffset = "-105";
  };

 # Install additional packages
  environment.systemPackages = with pkgs; [
    alsaTools
    libva-utils
  ];

  # Create a systemd service to fix audio crackling on startup/resume
  systemd.services.fixaudio = {
    description = "Fix audio crackling on Realtek ALC295";
    script = ''
      ${pkgs.alsaTools}/bin/hda-verb /dev/snd/hwC[[:print:]]*D0 0x20 SET_COEF_INDEX 0x67
      ${pkgs.alsaTools}/bin/hda-verb /dev/snd/hwC[[:print:]]*D0 0x20 SET_PROC_COEF 0x3000
    '';
    wantedBy = [ "multi-user.target" "post-resume.target" ];
    after = [ "post-resume.target" ];
  };

  # Install libraries for VA-API
  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];

  # Always start mpv with VA-API enabled
  environment.shellAliases = {
    "mpv" = "mpv --vo=vaapi --hwdec=vaapi";
  };

  # Enable Bluetooth support
  hardware.bluetooth.enable = true;

  # Use full PulseAudio package for Bluetooth support
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  # Enable weekly TRIM on ZFS
  services.zfs.trim.enable = true;

  # Add custom resolutions (for playing games at lower resolutions)
  services.xserver.xrandrHeads =
    [
      {
        output = "eDP-1";
        monitorConfig =
          ''
            Modeline "1600x900"  118.25  1600 1696 1856 2112  900 903 908 934 -hsync +vsync
            Modeline "1366x768"   85.25  1366 1440 1576 1784  768 771 781 798 -hsync +vsync
            Modeline "1280x720"   74.50  1280 1344 1472 1664  720 723 728 748 -hsync +vsync
         '';
      }
      {
        output = "HDMI-1";
        monitorConfig =
          ''
            Modeline "1600x900"  118.25  1600 1696 1856 2112  900 903 908 934 -hsync +vsync
            Modeline "1366x768"   85.25  1366 1440 1576 1784  768 771 781 798 -hsync +vsync
         '';
      }
    ];

  # Setup qemu user
  qemu-user.aarch64 = true;
  qemu-user.arm = true;
}
